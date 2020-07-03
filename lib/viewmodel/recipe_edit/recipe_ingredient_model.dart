import 'package:cookly/constants.dart';
import 'package:cookly/model/entities/abstract/ingredient_entity.dart';
import 'package:cookly/model/entities/abstract/ingredient_note_entity.dart';
import 'package:cookly/model/entities/mutable/mutable_ingredient_note.dart';
import 'package:cookly/services/recipe_manager.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:cookly/services/unit_of_measure.dart';
import 'package:cookly/viewmodel/recipe_view/recipe_view_model.dart';
import 'package:flutter/material.dart';

class RecipeIngredientModel extends ChangeNotifier {
  MutableIngredientNote _note;
  bool _deleted = false;
  RecipeViewModel _recipe;

  RecipeIngredientModel.of(IngredientNoteEntity note) {
    this._note = MutableIngredientNote.of(note);
  }

  String get name => _note.ingredient.name;

  double get amount => _note.amount;

  IngredientEntity get ingredient => _note.ingredient;

  bool get isDeleted => _deleted;

  bool get isRecipeReference => _note.ingredient.recipeReference != null;

  String get unitOfMeasure => _note.unitOfMeasure;

  String get uomDisplayText {
    var uom = this.uom;
    if (uom == null) {
      return '';
    } else {
      return uom.getDisplayName(this.amount == null ? 1 : this.amount.toInt());
    }
  }

  Future<RecipeViewModel> get recipe async {
    assert(this.isRecipeReference);
    if (this._recipe == null) {
      var recipe = await sl
          .get<RecipeManager>()
          .getRecipeById([_note.ingredient.recipeReference]);
      this._recipe = RecipeViewModel.of(recipe.first);
    }
    return this._recipe;
  }

  IngredientNoteEntity toIngredientNote() => _note;

  UnitOfMeasure get uom =>
      sl.get<UnitOfMeasureProvider>().getUnitOfMeasureById(_note.unitOfMeasure);

  void removeRecipeReference() {
    this.name = '';
    notifyListeners();
  }

  void setRecipeReference(String id) async {
    var recipe = await sl.get<RecipeManager>().getRecipeById([id]);
    this._recipe = RecipeViewModel.of(recipe.first);
    this.name = this._recipe.name;
    this._note.ingredient.recipeReference = id;
    this._note.unitOfMeasure = kUoMPortion;
    notifyListeners();
  }

  set name(String name) {
    this._note.ingredient.name = name;
    this._note.ingredient.recipeReference = null;
    // notifyListeners();
  }

  set amount(double amount) {
    this._note.amount = amount;
    // keep following listener deactivated
    // notifyListeners();
  }

  set uom(UnitOfMeasure uom) {
    this._note.unitOfMeasure = uom.id;
  }

  void setDeleted() => _deleted = true;
}

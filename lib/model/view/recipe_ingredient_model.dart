import 'package:cookly/constants.dart';
import 'package:cookly/model/json/ingredient.dart';
import 'package:cookly/model/json/ingredient_note.dart';
import 'package:cookly/model/view/recipe_view_model.dart';
import 'package:cookly/services/abstract/data_store.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:cookly/services/unit_of_measure.dart';
import 'package:flutter/material.dart';

class RecipeIngredientModel extends ChangeNotifier {
  IngredientNote _note;
  bool _deleted = false;
  RecipeViewModel _recipe;

  RecipeIngredientModel.of(this._note);

  String get name => _note.ingredient.name;

  double get amount => _note.amount;

  Ingredient get ingredient => _note.ingredient;

  bool get isDeleted => _deleted;

  bool get isRecipeReference => _note.ingredient.recipeReference != null;

  String get unitOfMeasure => _note.unitOfMeasure;

  String get uomDisplayText {
    var uom = this.uom;
    if (uom == null) {
      return '';
    } else {
      return uom.getDisplayName(this.amount.toInt());
    }
  }

  RecipeViewModel get recipe {
    assert(this.isRecipeReference);
    if (this._recipe == null) {
      this._recipe = sl
          .get<DataStore>()
          .appProfile
          .getRecipeById(_note.ingredient.recipeReference);
    }
    return this._recipe;
  }

  IngredientNote toIngredientNote() => _note;

  UnitOfMeasure get uom =>
      sl.get<UnitOfMeasureProvider>().getUnitOfMeasureById(_note.unitOfMeasure);

  void removeRecipeReference() {
    this.name = '';
    notifyListeners();
  }

  void setRecipeReference(String id) {
    this._recipe = sl.get<DataStore>().appProfile.getRecipeById(id);
    this.name = this._recipe.name;
    this._note.ingredient.recipeReference = id;
    this._note.unitOfMeasure = kUoMPortion;
    notifyListeners();
  }

  set name(String name) {
    this._note.ingredient.name = name;
    this._note.ingredient.recipeReference = null;
    //  notifyListeners();
  }

  set amount(double amount) {
    this._note.amount = amount;
    // notifyListeners();
  }

  set uom(UnitOfMeasure uom) {
    this._note.unitOfMeasure = uom.id;
  }

  void setDeleted() => _deleted = false;
}

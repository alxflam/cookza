import 'package:cookza/constants.dart';
import 'package:cookza/model/entities/abstract/ingredient_entity.dart';
import 'package:cookza/model/entities/abstract/ingredient_note_entity.dart';
import 'package:cookza/model/entities/mutable/mutable_ingredient_note.dart';
import 'package:cookza/services/recipe/recipe_manager.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/services/unit_of_measure.dart';
import 'package:cookza/viewmodel/recipe_view/recipe_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecipeIngredientModel extends ChangeNotifier {
  final MutableIngredientNote _note;
  bool _deleted = false;
  RecipeViewModel? _recipe;
  bool _supportsRecipeReference = true;

  RecipeIngredientModel.empty(this._supportsRecipeReference)
      : this._note = MutableIngredientNote.empty();

  RecipeIngredientModel.of(IngredientNoteEntity note)
      : this._note = MutableIngredientNote.of(note) {
    if (this._note.ingredient.isRecipeReference) {
      this.setRecipeReference(this._note.ingredient.recipeReference);
    }
  }

  RecipeIngredientModel.noteOnlyModelOf(IngredientNoteEntity note)
      : this._note = MutableIngredientNote.of(note),
        this._supportsRecipeReference = false;

  bool get supportsRecipeReference => _supportsRecipeReference;

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

  RecipeViewModel? get recipe {
    assert(this.isRecipeReference);
    assert(this._recipe != null);
    return this._recipe;
  }

  IngredientNoteEntity toIngredientNote() => _note;

  UnitOfMeasure get uom =>
      sl.get<UnitOfMeasureProvider>().getUnitOfMeasureById(_note.unitOfMeasure);

  void removeRecipeReference() {
    this.name = '';
    notifyListeners();
  }

  Future<void> setRecipeReference(String? id) async {
    assert(this.supportsRecipeReference);
    var recipe = await sl.get<RecipeManager>().getRecipeById([id!]);
    this._recipe = RecipeViewModel.of(recipe.first);
    this.name = this._recipe!.name;
    this._note.ingredient.recipeReference = id;
    this._note.unitOfMeasure = kUoMPortion;
    this._note.amount = this._note.amount > 0 ? this._note.amount : 1;
    notifyListeners();
  }

  set name(String name) {
    this._note.ingredient.name = name;
    this._note.ingredient.recipeReference = null;
  }

  set amount(double amount) {
    this._note.amount = amount;
  }

  set uom(UnitOfMeasure uom) {
    this._note.unitOfMeasure = uom.id;
  }

  void setDeleted() => _deleted = true;

  void validate(BuildContext context) {
    var noNameGiven = this.name == null || this.name.isEmpty;
    if (noNameGiven && !this.isRecipeReference) {
      throw AppLocalizations.of(context)!.missingIngredientName;
    }
  }
}

import 'package:cookly/model/entities/abstract/ingredient_note_entity.dart';
import 'package:cookly/model/entities/mutable/mutable_ingredient.dart';

class MutableIngredientNote implements IngredientNoteEntity {
  double _amount;
  String _uom;
  MutableIngredient _ingredient;

  MutableIngredientNote.of(IngredientNoteEntity note) {
    this._amount = note.amount;
    this._uom = note.unitOfMeasure;
    this._ingredient = MutableIngredient.of(note.ingredient);
  }

  MutableIngredientNote.empty() {
    this._amount = 0;
    this._uom = '';
    this._ingredient = MutableIngredient.empty();
  }

  @override
  double get amount => _amount;

  @override
  MutableIngredient get ingredient => _ingredient;

  @override
  String get unitOfMeasure => _uom;

  set amount(double value) {
    if (value > 0) {
      _amount = value;
    }
  }

  set unitOfMeasure(String value) {
    if (value != null && value.isNotEmpty) {
      this._uom = value;
    }
  }

  set name(String value) {
    this._ingredient.name = value;
  }

  set recipeReference(String value) {
    this._ingredient.recipeReference = value;
  }

  set ingredient(MutableIngredient value) {
    this._ingredient = value;
  }
}
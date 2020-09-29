import 'package:cookza/model/entities/abstract/ingredient_entity.dart';
import 'package:cookza/model/entities/abstract/ingredient_note_entity.dart';
import 'package:cookza/model/entities/json/ingredient_entity.dart';
import 'package:cookza/model/json/ingredient.dart';
import 'package:cookza/model/json/ingredient_note.dart';

class IngredientNoteEntityJson implements IngredientNoteEntity {
  IngredientNote _ingredient;

  IngredientNoteEntityJson.of(IngredientNote ingredient) {
    this._ingredient = ingredient;
  }

  IngredientNoteEntityJson.empty() {
    this._ingredient = IngredientNote(
        amount: 0, ingredient: Ingredient(name: ''), unitOfMeasure: '');
  }

  @override
  double get amount => this._ingredient.amount;

  @override
  IngredientEntity get ingredient =>
      IngredientEntityJson.of(this._ingredient.ingredient);

  @override
  String get unitOfMeasure => this._ingredient.unitOfMeasure;
}

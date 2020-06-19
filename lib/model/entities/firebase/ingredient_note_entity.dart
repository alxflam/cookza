import 'package:cookly/model/entities/abstract/ingredient_entity.dart';
import 'package:cookly/model/entities/abstract/ingredient_note_entity.dart';
import 'package:cookly/model/entities/ingredient_entity.dart';
import 'package:cookly/model/firebase/recipe/firebase_ingredient.dart';
import 'package:cookly/model/json/ingredient.dart';

class IngredientNoteEntityFirebase implements IngredientNoteEntity {
  FirebaseIngredient _ingredient;

  IngredientNoteEntityFirebase.of(FirebaseIngredient ingredient) {
    this._ingredient = ingredient;
  }

  IngredientNoteEntityFirebase.copy(IngredientNoteEntityFirebase original) {
    this._ingredient = FirebaseIngredient(
      unitOfMeasure: original.unitOfMeasure,
      amount: original.amount,
      ingredient: Ingredient(
          name: original.ingredient.name,
          recipeReference: original.ingredient.recipeReference),
    );
  }

  @override
  double get amount => this._ingredient.amount;

  @override
  IngredientEntity get ingredient =>
      IngredientEntityImpl.of(this._ingredient.ingredient);

  @override
  String get unitOfMeasure => this._ingredient.unitOfMeasure;
}

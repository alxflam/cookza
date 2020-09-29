import 'package:cookza/model/entities/mutable/mutable_ingredient.dart';
import 'package:cookza/model/entities/mutable/mutable_ingredient_note.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'empty ingredient',
    () async {
      var cut = MutableIngredientNote.empty();

      expect(cut.ingredient, isNotNull);
      expect(cut.amount, 0);
      expect(cut.unitOfMeasure, '');
    },
  );

  test(
    'set name',
    () async {
      var cut = MutableIngredientNote.empty();
      cut.name = 'Onion';
      expect(cut.ingredient.name, 'Onion');
    },
  );

  test(
    'set recipe reference',
    () async {
      var cut = MutableIngredientNote.empty();
      cut.recipeReference = 'recipeRef';
      expect(cut.ingredient.isRecipeReference, true);
    },
  );

  test(
    'mutable ingredient note of without reference',
    () async {
      var note = MutableIngredientNote.empty();
      note.name = 'Pepper';
      var cut = MutableIngredientNote.of(note);
      expect(cut.ingredient.isRecipeReference, false);
      expect(cut.ingredient.name, 'Pepper');
    },
  );

  test(
    'mutable ingredient note of without reference',
    () async {
      var note = MutableIngredientNote.empty();
      note.recipeReference = 'recipeRef';
      var cut = MutableIngredientNote.of(note);
      expect(cut.ingredient.isRecipeReference, true);
      expect(cut.ingredient.name, '');
    },
  );

  test(
    'set uom',
    () async {
      var cut = MutableIngredientNote.empty();
      cut.unitOfMeasure = 'KGM';
      expect(cut.unitOfMeasure, 'KGM');
    },
  );

  test(
    'set ingredient',
    () async {
      var cut = MutableIngredientNote.empty();
      var ing = MutableIngredient.empty();
      ing.name = 'Mushrooms';
      cut.ingredient = MutableIngredient.of(ing);
      expect(cut.ingredient.isRecipeReference, false);
      expect(cut.ingredient.name, 'Mushrooms');
    },
  );
}

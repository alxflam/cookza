import 'package:cookza/model/entities/firebase/ingredient_note_entity.dart';
import 'package:cookza/model/firebase/recipe/firebase_ingredient.dart';
import 'package:flutter_test/flutter_test.dart';

const name = 'Something';

void main() {
  test(
    'of constructor with empty source',
    () async {
      var ingredient = FirebaseIngredient.create();
      ingredient.ingredient.name = name;
      var cut = IngredientNoteEntityFirebase.of(ingredient);
      expect(cut.ingredient.isRecipeReference, false);
      expect(cut.amount, null);
      expect(cut.unitOfMeasure, null);
    },
  );

  test(
    'of constructor with recipe reference',
    () async {
      var ingredient = FirebaseIngredient.create();
      ingredient.ingredient.name = name;
      ingredient.ingredient.recipeReference = 'ABCD';
      var cut = IngredientNoteEntityFirebase.of(ingredient);
      expect(cut.ingredient.isRecipeReference, true);
      expect(cut.ingredient.recipeReference, 'ABCD');
      expect(cut.amount, null);
      expect(cut.unitOfMeasure, null);
    },
  );

  test(
    'amount',
    () async {
      var ingredient = FirebaseIngredient.create();
      ingredient.amount = 2.5;
      var cut = IngredientNoteEntityFirebase.of(ingredient);
      expect(cut.amount, 2.5);
    },
  );

  test(
    'unit of measure',
    () async {
      var ingredient = FirebaseIngredient.create();
      ingredient.unitOfMeasure = 'KGM';
      var cut = IngredientNoteEntityFirebase.of(ingredient);
      expect(cut.unitOfMeasure, 'KGM');
    },
  );

  test(
    'name',
    () async {
      var ingredient = FirebaseIngredient.create();
      ingredient.ingredient.name = name;
      var cut = IngredientNoteEntityFirebase.of(ingredient);
      expect(cut.ingredient.name, name);
    },
  );

  test(
    'copy constructor with empty source',
    () async {
      var ingredient = FirebaseIngredient.create();
      ingredient.ingredient.name = name;
      var ingredientEntity = IngredientNoteEntityFirebase.of(ingredient);
      var cut = IngredientNoteEntityFirebase.copy(ingredientEntity);
      expect(cut.ingredient.isRecipeReference, false);
      expect(cut.amount, null);
      expect(cut.unitOfMeasure, null);
    },
  );

  test(
    'copy constructor with recipe reference',
    () async {
      var ingredient = FirebaseIngredient.create();
      ingredient.ingredient.name = name;
      ingredient.unitOfMeasure = 'KGM';
      ingredient.amount = 2.5;
      ingredient.ingredient.recipeReference = 'ABCD';

      var ingredientEntity = IngredientNoteEntityFirebase.of(ingredient);
      var cut = IngredientNoteEntityFirebase.copy(ingredientEntity);
      expect(cut.ingredient.isRecipeReference, true);
      expect(cut.ingredient.recipeReference, 'ABCD');
      expect(cut.amount, 2.5);
      expect(cut.unitOfMeasure, 'KGM');
    },
  );
}

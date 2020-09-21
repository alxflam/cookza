import 'package:cookly/model/entities/mutable/mutable_ingredient_note.dart';
import 'package:cookly/model/entities/mutable/mutable_recipe.dart';
import 'package:cookly/model/firebase/recipe/firebase_ingredient.dart';
import 'package:cookly/model/json/ingredient.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'Parse from JSON - no recipe reference',
    () async {
      var json = {
        'unitOfMeasure': 'KGM',
        'amount': 3,
        'ingredient': Ingredient(name: 'Pepper').toJson()
      };
      var cut = FirebaseIngredient.fromJson(json);

      expect(cut.amount, 3);
      expect(cut.unitOfMeasure, 'KGM');
      expect(cut.ingredient.name, 'Pepper');
      expect(cut.ingredient.recipeReference, null);
    },
  );

  test(
    'Object to JSON - no recipe reference',
    () async {
      var json = {
        'unitOfMeasure': 'KGM',
        'amount': 3,
        'ingredient': Ingredient(name: 'Pepper').toJson()
      };

      var cut = FirebaseIngredient.fromJson(json);
      var generatedJson = cut.toJson();

      expect(generatedJson, json);
    },
  );

  test(
    'Parse from JSON - recipe reference',
    () async {
      var json = {
        'unitOfMeasure': 'KGM',
        'amount': 3,
        'ingredient':
            Ingredient(name: 'Pasta', recipeReference: '1234').toJson()
      };
      var cut = FirebaseIngredient.fromJson(json);

      expect(cut.amount, 3);
      expect(cut.unitOfMeasure, 'KGM');
      expect(cut.ingredient.name, 'Pasta');
      expect(cut.ingredient.recipeReference, '1234');
    },
  );

  test(
    'Create from Recipe',
    () async {
      var recipe = MutableRecipe.empty();

      var pepper = MutableIngredientNote.empty();
      pepper.name = 'Pepper';
      pepper.amount = 3;
      pepper.unitOfMeasure = 'KGM';

      var onion = MutableIngredientNote.empty();
      onion.name = 'Onion';
      onion.amount = 300;
      onion.unitOfMeasure = 'GRM';
      onion.recipeReference = '1234';

      recipe.ingredientList = [pepper, onion];
      var cut = await FirebaseIngredient.from(recipe);

      expect(cut.length, 2);
      expect(cut.first.ingredient.name, 'Pepper');
      expect(cut.first.amount, 3);
      expect(cut.first.unitOfMeasure, 'KGM');
      expect(cut.first.ingredient.recipeReference, null);

      expect(cut.last.ingredient.name, 'Onion');
      expect(cut.last.ingredient.recipeReference, '1234');
      expect(cut.last.amount, 300);
      expect(cut.last.unitOfMeasure, 'GRM');
    },
  );

  test(
    'Ingredient document - Parse from JSON',
    () async {
      var json = {
        'recipeID': '1234',
        'ingredients': [
          {
            'unitOfMeasure': 'KGM',
            'amount': 3,
            'ingredient':
                Ingredient(name: 'Pasta', recipeReference: '1234').toJson()
          },
          {
            'unitOfMeasure': 'KGM',
            'amount': 3,
            'ingredient': Ingredient(name: 'Pepper').toJson()
          }
        ]
      };

      var cut = FirebaseIngredientDocument.fromJson(json, '4567');

      expect(cut.documentID, '4567');
      expect(cut.recipeID, '1234');
      expect(cut.ingredients.length, 2);
      expect(cut.ingredients.first.ingredient.name, 'Pasta');
      expect(cut.ingredients.last.ingredient.name, 'Pepper');
    },
  );

  test(
    'Ingredient document - Object to JSON',
    () async {
      var sourceJson = {
        'recipeID': '1234',
        'ingredients': [
          {
            'unitOfMeasure': 'KGM',
            'amount': 3,
            'ingredient':
                Ingredient(name: 'Pasta', recipeReference: '1234').toJson()
          },
          {
            'unitOfMeasure': 'KGM',
            'amount': 3,
            'ingredient': Ingredient(name: 'Pepper').toJson()
          }
        ]
      };

      var cut = FirebaseIngredientDocument.fromJson(sourceJson, '4567');
      var generatedJson = cut.toJson();

      expect(generatedJson, sourceJson);
    },
  );
}

import 'package:cookza/model/firebase/recipe/firebase_ingredient.dart';
import 'package:cookza/model/json/ingredient.dart';
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
      expect(cut.ingredients!.length, 2);
      expect(cut.ingredients!.first.ingredient.name, 'Pasta');
      expect(cut.ingredients!.last.ingredient.name, 'Pepper');
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

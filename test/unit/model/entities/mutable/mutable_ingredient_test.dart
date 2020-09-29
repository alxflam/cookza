import 'package:cookza/model/entities/json/ingredient_entity.dart';
import 'package:cookza/model/entities/mutable/mutable_ingredient.dart';
import 'package:cookza/model/json/ingredient.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'empty ingredient',
    () async {
      var cut = MutableIngredient.empty();

      expect(cut.isRecipeReference, false);
      expect(cut.name, '');
      expect(cut.recipeReference, null);
    },
  );

  test(
    'set name',
    () async {
      var cut = MutableIngredient.empty();
      cut.name = 'dummy name';
      expect(cut.name, 'dummy name');
    },
  );

  test(
    'set recipe reference',
    () async {
      var cut = MutableIngredient.empty();
      cut.recipeReference = 'dummyRef';
      expect(cut.isRecipeReference, true);
      expect(cut.recipeReference, 'dummyRef');
    },
  );

  test(
    'mutable ingredient of without reference',
    () async {
      var cut = MutableIngredient.of(
          IngredientEntityJson.of(Ingredient(name: 'Onion')));
      expect(cut.isRecipeReference, false);
      expect(cut.name, 'Onion');
    },
  );

  test(
    'mutable ingredient of without reference',
    () async {
      var cut = MutableIngredient.of(
          IngredientEntityJson.of(Ingredient(recipeReference: 'recipeRef')));
      expect(cut.isRecipeReference, true);
      expect(cut.recipeReference, 'recipeRef');
    },
  );
}

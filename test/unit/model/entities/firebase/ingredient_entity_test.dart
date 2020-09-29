import 'package:cookza/model/entities/firebase/ingredient_entity.dart';
import 'package:cookza/model/json/ingredient.dart';
import 'package:flutter_test/flutter_test.dart';

const name = 'A Test';

void main() {
  test(
    'is not a recipe reference',
    () async {
      var cut = IngredientEntityFirebase.of(Ingredient(name: name));
      expect(cut.isRecipeReference, false);
      expect(cut.recipeReference, null);
    },
  );

  test(
    'is a recipe reference',
    () async {
      var cut = IngredientEntityFirebase.of(
          Ingredient(name: name, recipeReference: 'ABCD'));
      expect(cut.isRecipeReference, true);
      expect(cut.recipeReference, 'ABCD');
    },
  );

  test(
    'name is resolved',
    () async {
      var cut = IngredientEntityFirebase.of(Ingredient(name: name));
      expect(cut.name, name);
    },
  );
}

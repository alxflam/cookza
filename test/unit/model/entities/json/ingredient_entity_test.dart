import 'package:cookza/model/entities/json/ingredient_entity.dart';
import 'package:cookza/model/json/ingredient.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'No recipe reference',
    () async {
      var cut = IngredientEntityJson.of(Ingredient(name: 'Onion'));

      expect(cut.isRecipeReference, false);
      expect(cut.name, 'Onion');
      expect(cut.recipeReference, null);
    },
  );

  test(
    'Recipe reference',
    () async {
      var cut = IngredientEntityJson.of(
          Ingredient(name: 'Some Recipe', recipeReference: '1234'));

      expect(cut.isRecipeReference, true);
      expect(cut.name, 'Some Recipe');
      expect(cut.recipeReference, '1234');
    },
  );
}

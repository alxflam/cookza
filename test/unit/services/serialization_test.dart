import 'package:cookly/model/entities/abstract/recipe_entity.dart';
import 'package:cookly/model/json/ingredient.dart';
import 'package:cookly/model/json/ingredient_note.dart';
import 'package:cookly/model/json/recipe.dart';
import 'package:cookly/model/json/recipe_list.dart';
import 'package:cookly/services/util/id_gen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

void main() {
  test(
    'Serialize',
    () async {
      GetIt.I.registerSingleton<IdGenerator>(UniqueKeyIdGenerator());

      var list = [
        IngredientNote(
            ingredient: Ingredient(name: 'Onion'),
            amount: 2,
            unitOfMeasure: 'pieces'),
        IngredientNote(
            ingredient: Ingredient(name: 'Potato'),
            amount: 250,
            unitOfMeasure: 'g'),
      ];

      var recipe = Recipe(
        creationDate: DateTime.now(),
        modificationDate: DateTime.now(),
        duration: 15,
        diff: DIFFICULTY.EASY,
        name: 'A sample recipe',
        shortDescription: 'easy but tasty',
        tags: ['vegan'],
        ingredients: list,
        instructions: [
          'First step',
          'Second step',
          'Last step',
        ],
      );

      var cut = RecipeList(recipes: [recipe]);

      // IngredientNoteToJson => instance to json!

      var json = cut.toJson();
      RecipeList deserialized = RecipeList.fromJson(json);

      expect(deserialized.recipes.first.name, 'A sample recipe');
      expect(deserialized.recipes.first.ingredients.first.ingredient.name,
          'Onion');
    },
  );
}

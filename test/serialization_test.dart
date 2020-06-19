import 'package:cookly/model/firebase/firebase_recipe.dart';
import 'package:cookly/model/json/ingredient.dart';
import 'package:cookly/model/json/ingredient_note.dart';
import 'package:cookly/model/json/profile.dart';
import 'package:cookly/model/json/recipe.dart';
import 'package:cookly/model/json/recipe_list.dart';
import 'package:cookly/services/id_gen.dart';
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

      var cut = Profile(recipeList: RecipeList(recipes: [recipe]));

      // IngredientNoteToJson => instance to json!

      var json = cut.toJson();
      Profile deserialized = Profile.fromJson(json);

      expect(deserialized.recipeList.recipes.first.name, 'A sample recipe');
      expect(
          deserialized
              .recipeList.recipes.first.ingredients.first.ingredient.name,
          'Onion');
    },
  );
}

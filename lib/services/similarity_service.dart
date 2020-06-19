import 'dart:collection';

import 'package:cookly/model/entities/abstract/ingredient_note_entity.dart';
import 'package:cookly/model/entities/abstract/recipe_entity.dart';
import 'package:cookly/services/levenshtein.dart';
import 'package:cookly/services/recipe_manager.dart';
import 'package:cookly/services/service_locator.dart';

class SimilarityService {
  Future<List<RecipeEntity>> getSimilarRecipes(
      RecipeEntity sourceRecipe) async {
    List<RecipeEntity> result = [];

    // immediately return if the recipe does not exist or does not contain any ingredients
    if (sourceRecipe == null) {
      return result;
    }

    var sourceIngredients = await sourceRecipe.ingredients;
    if (sourceIngredients.isEmpty) {
      return result;
    }

    // check for each other recipe each ingredient
    // does the source recipe contain an ingredient which is likely to be the same?
    //  then add one to the counter
    //  if the source recipe contains more than 33% of the same ingredients, add it as possibly similar

    var recipes = await sl.get<RecipeManager>().getAllRecipes();

    var ingredients =
        sourceIngredients.map((element) => element.ingredient).toSet();
    var count = 0;
    for (var item in recipes) {
      if (item.id == sourceRecipe.id) {
        continue;
      }
      count = 0;

      var ing = await item.ingredients;

      for (var origIng in ingredients) {
        if (this.containsIngredient(ing, origIng.name)) {
          count++;
        }
      }

      if (count > ing.length / 3) {
        result.add(item);
      }
    }

    return result;
  }

  bool containsIngredient(
      UnmodifiableListView<IngredientNoteEntity> ingredients,
      String targetIngredient) {
    for (var ing in ingredients) {
      var res = levenshtein(ing.ingredient.name, targetIngredient);
      if (res < (ing.ingredient.name.length / 2)) {
        return true;
      }
    }
    return false;
  }

  Future<List<RecipeEntity>> getRecipesContaining(
      List<String> targetIngredients) async {
    final result = Future(() async {
      var recipes = await sl.get<RecipeManager>().getAllRecipes();
      List<RecipeEntity> result = [];

      for (var recipe in recipes) {
        var containsAll = true;
        var ing = await recipe.ingredients;
        for (var ingredient in targetIngredients) {
          if (!this.containsIngredient(ing, ingredient)) {
            containsAll = false;
            break;
          }
        }

        if (containsAll) {
          result.add(recipe);
        }
      }

      return result;
    });

    return result;
  }
}

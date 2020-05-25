import 'dart:io';

import 'package:cookly/model/view/recipe_view_model.dart';
import 'package:cookly/services/abstract/data_store.dart';
import 'package:cookly/services/levenshtein.dart';
import 'package:cookly/services/service_locator.dart';

class SimilarityService {
  Future<List<RecipeViewModel>> getSimilarRecipes(String id) async {
    List<RecipeViewModel> result = [];
    var profile = sl.get<DataStore>().appProfile;

    var recipe = profile.getRecipeById(id);
    // immediately return if the recipe does not exist or does not contain any ingredients
    if (recipe == null || recipe.ingredients.isEmpty) {
      return result;
    }

    // check for each other recipe each ingredient
    // does the source recipe contain an ingredient which is likely to be the same?
    //  then add one to the counter
    //  if the source recipe contains more than 33% of the same ingredients, add it as possibly similar

    var recipes = profile.recipes;
    var ingredients =
        recipe.ingredients.map((element) => element.ingredient).toSet();
    var count = 0;
    for (var item in recipes) {
      if (item.id == id) {
        continue;
      }
      count = 0;

      for (var origIng in ingredients) {
        if (this.containsIngredient(item, origIng.name)) {
          count++;
        }
      }

      if (count > item.ingredients.length / 3) {
        result.add(item);
      }
    }

    return result;
  }

  bool containsIngredient(RecipeViewModel recipe, String targetIngredient) {
    for (var ing in recipe.ingredients) {
      var res = levenshtein(ing.ingredient.name, targetIngredient);
      if (res < (ing.ingredient.name.length / 2)) {
        return true;
      }
    }
    return false;
  }

  Future<List<RecipeViewModel>> getRecipesContaining(
      List<String> targetIngredients) async {
    final result = Future(() {
      var recipes = sl.get<DataStore>().appProfile.recipes;
      List<RecipeViewModel> result = [];

      for (var recipe in recipes) {
        var containsAll = true;
        for (var ingredient in targetIngredients) {
          if (!this.containsIngredient(recipe, ingredient)) {
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

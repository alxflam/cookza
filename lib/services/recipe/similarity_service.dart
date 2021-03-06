import 'package:cookza/model/entities/abstract/ingredient_note_entity.dart';
import 'package:cookza/model/entities/abstract/recipe_entity.dart';
import 'package:cookza/services/util/levenshtein.dart';
import 'package:cookza/services/recipe/recipe_manager.dart';
import 'package:cookza/services/flutter/service_locator.dart';

class SimilarityService {
  List<RecipeEntity> _lastResult = [];
  Set<String> _lastSearch = {};

  Future<List<RecipeEntity>> getSimilarRecipes(
      RecipeEntity sourceRecipe) async {
    List<RecipeEntity> result = [];

    // immediately return if the recipe does not contain any ingredients
    var sourceGroups = await sourceRecipe.ingredientGroups;
    if (sourceGroups.isEmpty) {
      return result;
    }

    // check for each other recipe each ingredient
    // does the source recipe contain an ingredient which is likely to be the same?
    //  then add one to the counter
    //  if the source recipe contains more than 33% of the same ingredients, add it as possibly similar

    var recipes = await sl.get<RecipeManager>().getAllRecipes();

    var ingredients =
        sourceGroups.map((e) => e.ingredients).expand((e) => e).toSet();
    var count = 0;
    for (var item in recipes) {
      if (item.id == sourceRecipe.id) {
        continue;
      }

      var refRecipeGroups = await item.ingredientGroups;
      final refRecipeIngredients =
          refRecipeGroups.map((e) => e.ingredients).expand((e) => e).toSet();

      count = 0;
      for (var origIng in ingredients) {
        if (this.containsIngredient(
            refRecipeIngredients, origIng.ingredient.name)) {
          count++;
        }
      }

      // recipes are similar if more than one third of the similar recipe's ingredients are also contained in the source recipe
      // and also at least one third of the ingredients of the source recipe are contained in the similar recipe's ingredients
      if (count > refRecipeIngredients.length / 3 &&
          count > ingredients.length / 3) {
        result.add(item);
      }
    }

    return result;
  }

  bool containsIngredient(
      Set<IngredientNoteEntity> ingredients, String targetIngredient) {
    for (var ing in ingredients) {
      var res = levenshtein(ing.ingredient.name, targetIngredient);
      if (res < (ing.ingredient.name.length / 2)) {
        return true;
      }
    }
    return false;
  }

  Future<List<RecipeEntity>> getRecipesContaining(
      Set<String> targetIngredients) async {
    // if only a single new ingredient got added,
    // then fetch the last result and filter it
    var cachedRecipes = _getCachedResult(targetIngredients);
    // otherwise retrieve all ingredients
    var recipes = cachedRecipes.isEmpty
        ? await sl.get<RecipeManager>().getAllRecipes()
        : cachedRecipes;

    List<RecipeEntity> result = [];

    for (var recipe in recipes) {
      var containsAll = true;
      var refRecipeGroups = await recipe.ingredientGroups;
      final refRecipeIngredients =
          refRecipeGroups.map((e) => e.ingredients).expand((e) => e).toSet();

      for (var ingredient in targetIngredients) {
        if (!this.containsIngredient(refRecipeIngredients, ingredient)) {
          containsAll = false;
          break;
        }
      }

      if (containsAll) {
        result.add(recipe);
      }
    }

    _lastResult = result;
    _lastSearch = targetIngredients;

    return result;
  }

  List<RecipeEntity> _getCachedResult(Set<String> targetIngredients) {
    if (_lastResult.isNotEmpty) {
      final diff = _lastSearch.difference(targetIngredients);
      if (diff.length == 1 && !_lastSearch.contains(diff.first)) {
        return _lastResult;
      }
    }
    _lastResult = [];
    _lastSearch = {};
    return _lastResult;
  }
}

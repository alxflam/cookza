import 'package:cookly/constants.dart';
import 'package:cookly/model/entities/abstract/recipe_entity.dart';
import 'package:cookly/model/json/recipe.dart';
import 'package:cookly/model/json/recipe_list.dart';
import 'package:cookly/services/recipe/recipe_manager.dart';
import 'package:cookly/services/flutter/service_locator.dart';

abstract class RecipeFileExport {
  // use exportRecipesFromEntity if entities are already loaded
  void exportRecipes(List<String> ids);

  void exportRecipesFromEntity(List<RecipeEntity> recipes);

  String getExportFileName() {
    return 'cooklyRecipes${kFileNameDateFormatter.format(DateTime.now())}';
  }

  Future<RecipeList> idsToExportModel(List<String> ids) async {
    var recipes = await sl.get<RecipeManager>().getRecipeById(ids);
    return entitiesToExportModel(recipes);
  }

  Future<RecipeList> entitiesToExportModel(List<RecipeEntity> recipes) async {
    List<Recipe> result = [];
    for (var item in recipes) {
      var recipe = await Recipe.applyFrom(item);
      result.add(recipe);
    }

    return RecipeList(recipes: result);
  }
}

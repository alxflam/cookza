import 'package:cookly/constants.dart';
import 'package:cookly/model/json/recipe.dart';
import 'package:cookly/model/json/recipe_list.dart';
import 'package:cookly/services/recipe_manager.dart';
import 'package:cookly/services/service_locator.dart';

abstract class RecipeFileExport {
  void exportRecipes(List<String> ids);

  String getExportFileName() {
    return 'cooklyRecipes${kFileNameDateFormatter.format(DateTime.now())}';
  }

  Future<RecipeList> idsToExportModel(List<String> ids) async {
    var recipes = await sl.get<RecipeManager>().getRecipeById(ids);
    var result = [];
    for (var item in recipes) {
      var recipe = await Recipe.applyFrom(item);
      result.add(recipe);
    }

    return RecipeList(recipes: result);
  }
}

import 'package:cookly/constants.dart';
import 'package:cookly/model/json/recipe_list.dart';
import 'package:cookly/services/image_manager.dart';
import 'package:cookly/services/service_locator.dart';

abstract class RecipeFileExport {
  void exportRecipes(List<String> ids);

  String getExportFileName() {
    return 'cooklyRecipes${kFileNameDateFormatter.format(DateTime.now())}';
  }

  // TODO: rework from firebase
  RecipeList idsToExportModel(List<String> ids) {
    var recipes = []; // sl.get<ImageManager>().getRecipesByID(ids);

    return RecipeList(recipes: recipes);
  }
}

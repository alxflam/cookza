import 'package:cookly/constants.dart';
import 'package:cookly/model/json/recipe_list.dart';
import 'package:cookly/services/abstract/data_store.dart';
import 'package:cookly/services/service_locator.dart';

abstract class RecipeFileExport {
  void exportRecipes(List<String> ids);

  String getExportFileName() {
    return 'cooklyRecipes${kFileNameDateFormatter.format(DateTime.now())}';
  }

  RecipeList idsToExportModel(List<String> ids) {
    var recipes = sl.get<DataStore>().appProfile.getRawRecipes(ids);
    return RecipeList(recipes: recipes);
  }
}

import 'package:cookly/model/view/recipe_view_model.dart';
import 'package:cookly/services/abstract/data_store.dart';
import 'package:cookly/services/levenshtein.dart';
import 'package:cookly/services/service_locator.dart';

class SimilarityService {
  Future<List<RecipeViewModel>> getSimilarRecipes(String id) async {
    List<RecipeViewModel> result = [];
    var profile = sl.get<DataStore>().appProfile;

    var recipe = profile.getRecipeById(id);
    if (recipe == null) {
      return result;
    }

    var recipes = profile.recipes;
    var ingredients =
        recipe.ingredients.map((element) => element.ingredient).toSet();
    var count = 0;
    for (var item in recipes) {
      if (item.id == id) {
        continue;
      }

      for (var ing in item.ingredients) {
        for (var origIng in ingredients) {
          var res = levenshtein(ing.ingredient.name, origIng.name);
          if (res < ing.ingredient.name.length) {
            count++;
          }
        }
      }

      if (count > item.ingredients.length / 3) {
        result.add(item);
      }
    }

    return result;
  }
}

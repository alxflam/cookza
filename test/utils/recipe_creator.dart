import 'package:cookza/model/entities/mutable/mutable_ingredient_note.dart';
import 'package:cookza/model/entities/mutable/mutable_recipe.dart';
import 'package:cookza/services/util/id_gen.dart';

class RecipeCreator {
  static MutableRecipe createRecipe(String name) {
    var recipe = MutableRecipe.empty();
    recipe.id = UniqueKeyIdGenerator().id;
    recipe.name = name;
    return recipe;
  }

  static MutableIngredientNote createIngredient(String name,
      {double amount, String uom}) {
    var ingredient = MutableIngredientNote.empty();
    ingredient.name = name;
    ingredient.amount = amount ?? 0;
    ingredient.unitOfMeasure = uom ?? '';
    return ingredient;
  }
}

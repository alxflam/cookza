import 'package:cookly/model/entities/mutable/mutable_ingredient_note.dart';
import 'package:cookly/model/entities/mutable/mutable_recipe.dart';
import 'package:cookly/services/id_gen.dart';

class RecipeCreator {
  static MutableRecipe createRecipe(String name) {
    var recipe = MutableRecipe.empty();
    recipe.id = UniqueKeyIdGenerator().id;
    recipe.name = name;
    return recipe;
  }

  static MutableIngredientNote createIngredient(String name) {
    var ingredient = MutableIngredientNote.empty();
    ingredient.name = name;
    return ingredient;
  }
}

import 'package:cookza/model/entities/abstract/recipe_entity.dart';
import 'package:cookza/model/entities/mutable/mutable_ingredient_note.dart';
import 'package:cookza/model/entities/mutable/mutable_recipe.dart';

import 'id_gen.dart';

class RecipeCreator {
  static MutableRecipe createRecipe(String name) {
    var recipe = MutableRecipe.empty();
    recipe.id = UniqueKeyIdGenerator().id;
    recipe.name = name;
    recipe.recipeCollectionId = '';
    return recipe;
  }

  static MutableIngredientNote createIngredient(String name,
      {double? amount, String? uom}) {
    var ingredient = MutableIngredientNote.empty();
    ingredient.name = name;
    ingredient.amount = amount ?? 0;
    ingredient.unitOfMeasure = uom ?? '';
    return ingredient;
  }

  static MutableIngredientNote createIngredientFromRecipe(RecipeEntity recipe,
      {double? amount, String? uom}) {
    var ingredient = MutableIngredientNote.empty();
    ingredient.name = recipe.name;
    ingredient.amount = amount ?? 0;
    ingredient.unitOfMeasure = uom ?? '';
    ingredient.recipeReference = recipe.id!;
    return ingredient;
  }
}

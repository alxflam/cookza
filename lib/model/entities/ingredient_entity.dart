import 'package:cookly/model/entities/abstract/ingredient_entity.dart';
import 'package:cookly/model/json/ingredient.dart';

class IngredientEntityImpl implements IngredientEntity {
  Ingredient _ingredient;

  IngredientEntityImpl.of(Ingredient ingredient) {
    this._ingredient = ingredient;
  }

  @override
  bool get isRecipeReference =>
      this._ingredient.recipeReference != null &&
      this._ingredient.recipeReference.isNotEmpty;

  @override
  String get name => this._ingredient.name;

  @override
  String get recipeReference => this._ingredient.recipeReference;
}

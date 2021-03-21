import 'package:cookza/model/entities/abstract/ingredient_entity.dart';
import 'package:cookza/model/json/ingredient.dart';

class IngredientEntityImpl implements IngredientEntity {
  Ingredient _ingredient;

  IngredientEntityImpl.of(Ingredient ingredient)
      : this._ingredient = ingredient;

  @override
  bool get isRecipeReference =>
      this._ingredient.recipeReference?.isNotEmpty ?? false;

  @override
  String get name => this._ingredient.name;

  @override
  String? get recipeReference => this._ingredient.recipeReference;
}

import 'package:cookza/model/entities/abstract/ingredient_entity.dart';
import 'package:cookza/model/json/ingredient.dart';

class IngredientEntityJson implements IngredientEntity {
  Ingredient _ingredient;

  IngredientEntityJson.of(this._ingredient);

  @override
  bool get isRecipeReference =>
      this._ingredient.recipeReference != null &&
      this._ingredient.recipeReference!.isNotEmpty;

  @override
  String get name => this._ingredient.name;

  @override
  String? get recipeReference => this._ingredient.recipeReference;
}

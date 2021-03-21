import 'package:cookza/model/entities/abstract/ingredient_entity.dart';

class MutableIngredient implements IngredientEntity {
  String? _recipeReference;

  String _name;

  MutableIngredient.of(IngredientEntity ingredient)
      : this._recipeReference = ingredient.recipeReference,
        this._name = ingredient.name;

  MutableIngredient.empty()
      : this._recipeReference = null,
        this._name = '';

  @override
  bool get isRecipeReference =>
      _recipeReference != null && _recipeReference!.isNotEmpty;

  @override
  String get name => _name;

  @override
  String? get recipeReference => _recipeReference;

  set name(String value) {
    if (value != null && value.isNotEmpty) {
      this._name = value;
    }
  }

  set recipeReference(String? value) {
    this._recipeReference = value;
  }
}

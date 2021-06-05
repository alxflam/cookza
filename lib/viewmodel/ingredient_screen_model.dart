import 'package:cookza/model/entities/abstract/ingredient_group_entity.dart';
import 'package:cookza/viewmodel/recipe_edit/recipe_ingredient_model.dart';

class IngredientScreenModel {
  final RecipeIngredientModel model;
  final bool supportsRecipeReference;
  final bool requiresIngredientGroup;
  final List<IngredientGroupEntity> groups;
  IngredientGroupEntity? group;

  IngredientScreenModel(
      {required this.model,
      required this.supportsRecipeReference,
      required this.requiresIngredientGroup,
      required this.groups,
      this.group});
}

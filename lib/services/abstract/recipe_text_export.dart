import 'package:cookza/model/entities/abstract/recipe_entity.dart';

abstract class RecipeTextExporter {
  Future<void> exportRecipesAsText(List<RecipeEntity> entities);
}

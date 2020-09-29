import 'package:cookza/model/entities/abstract/recipe_entity.dart';
import 'package:cookza/services/abstract/recipe_text_export.dart';
import 'package:cookza/services/recipe/recipe_text_generator.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:share_extend/share_extend.dart';

// TODO: add web implementation!
class RecipeTextExporterApp implements RecipeTextExporter {
  @override
  Future<void> exportRecipesAsText(List<RecipeEntity> entities) async {
    var text = await sl.get<RecipeTextGenerator>().generateRecipeText(entities);

    ShareExtend.share(text, 'text');
  }
}

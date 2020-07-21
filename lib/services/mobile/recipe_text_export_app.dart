import 'package:cookly/model/entities/abstract/recipe_entity.dart';
import 'package:cookly/services/abstract/recipe_text_export.dart';
import 'package:cookly/services/recipe_text_generator.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:share_extend/share_extend.dart';

// TODO: add web implementation!
class RecipeTextExporterApp implements RecipeTextExporter {
  @override
  Future<void> exportRecipesAsText(List<RecipeEntity> entities) async {
    var text = await sl.get<RecipeTextGenerator>().generateRecipeText(entities);

    ShareExtend.share(text, 'text');
  }
}

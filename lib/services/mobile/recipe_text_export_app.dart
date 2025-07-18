import 'package:cookza/model/entities/abstract/recipe_entity.dart';
import 'package:cookza/services/abstract/recipe_text_export.dart';
import 'package:cookza/services/flutter/navigator_service.dart';
import 'package:cookza/services/recipe/recipe_text_generator.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';

class RecipeTextExporterApp implements RecipeTextExporter {
  @override
  Future<void> exportRecipesAsText(List<RecipeEntity> entities) async {
    var context = sl.get<NavigatorService>().currentContext;
    var ingTitle = AppLocalizations.of(context!).ingredient(2);
    var insTitle = AppLocalizations.of(context).instructions;
    var text = await sl
        .get<RecipeTextGenerator>()
        .generateRecipeText(entities, ingTitle, insTitle);

    await Share.share(text);
  }
}

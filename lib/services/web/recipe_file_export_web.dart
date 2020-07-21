import 'dart:convert';
import 'dart:html' as html;
import 'package:cookly/model/entities/abstract/recipe_entity.dart';
import 'package:cookly/services/abstract/recipe_file_export.dart';

class RecipeFileExportImpl extends RecipeFileExport {
  @override
  void exportRecipes(List<String> ids) async {
    var model = await this.idsToExportModel(ids);

    var json = model.toJson();
    var exportJson = jsonEncode(json);

    final bytes = utf8.encode(exportJson);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = '${this.getExportFileName()}.json';
    html.document.body.children.add(anchor);

    // trigger downlaod
    anchor.click();

    // remove DOM element
    html.document.body.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }

  @override
  void exportRecipesFromEntity(List<RecipeEntity> recipes) {
    // TODO: implement exportRecipesFromEntity
  }
}

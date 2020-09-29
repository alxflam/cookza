import 'dart:convert';
import 'dart:io';

import 'package:cookza/model/entities/abstract/recipe_entity.dart';
import 'package:cookza/model/json/recipe_list.dart';
import 'package:cookza/services/abstract/recipe_file_export.dart';
import 'package:cookza/services/local_storage.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:share_extend/share_extend.dart';

class RecipeFileExportImpl extends RecipeFileExport {
  @override
  void exportRecipes(List<String> ids) async {
    String directory = await sl.get<StorageProvider>().getTempDirectory();
    var file = File('$directory/${this.getExportFileName()}.json');

    var model = await this.idsToExportModel(ids);
    await _export(model, file);
  }

  Future _export(RecipeList model, File file) async {
    var json = model.toJson();

    await file.writeAsString(jsonEncode(json));
    print('profile saved at ${file.path}');

    ShareExtend.share(file.path, 'file');
  }

  @override
  void exportRecipesFromEntity(List<RecipeEntity> recipes) async {
    String directory = await sl.get<StorageProvider>().getTempDirectory();
    var file = File('$directory/${this.getExportFileName()}.json');

    var model = await this.entitiesToExportModel(recipes);
    await _export(model, file);
  }
}

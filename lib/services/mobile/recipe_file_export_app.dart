import 'dart:convert';
import 'dart:io';

import 'package:cookly/services/abstract/recipe_file_export.dart';
import 'package:cookly/services/local_storage.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:share_extend/share_extend.dart';

class RecipeFileExportImpl extends RecipeFileExport {
  @override
  void exportRecipes(List<String> ids) async {
    String directory = await sl.get<StorageProvider>().getTempDirectory();
    var file = File('$directory/${this.getExportFileName()}.json');

    var model = await this.idsToExportModel(ids);
    var json = model.toJson();

    await file.writeAsString(jsonEncode(json));
    print('profile saved at ${file.path}');

    ShareExtend.share(file.path, 'file');
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:cookza/model/entities/json/recipe_entity.dart';
import 'package:cookza/model/json/recipe.dart';
import 'package:cookza/model/json/recipe_list.dart';
import 'package:cookza/viewmodel/recipe_selection_model.dart';
import 'package:cookza/screens/recipe_selection_screen.dart';
import 'package:cookza/services/abstract/recipe_file_import.dart';
import 'package:cookza/viewmodel/recipe_view/recipe_view_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecipeFileImportImpl extends RecipeFileImport {
  @override
  void parseAndImport(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final localizations = AppLocalizations.of(context);
    final navigator = Navigator.of(context);

    var filePickerResult = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        allowedExtensions: ['json'],
        type: FileType.custom,
        allowCompression: true);
    if (filePickerResult == null || filePickerResult.paths.length != 1) {
      scaffoldMessenger
          .showSnackBar(SnackBar(content: Text(localizations.noFileSelected)));
      return;
    }
    File file = File(filePickerResult.paths.first!);

    List<Recipe> result = [];
    if (!file.existsSync()) {
      scaffoldMessenger
          .showSnackBar(SnackBar(content: Text(localizations.fileNotFound)));
      return;
    }

    var content = file.readAsStringSync();
    RecipeList model = RecipeList.fromJson(jsonDecode(content));
    for (var item in model.recipes) {
      result.add(item);
    }

    var viewModel = result
        .map((item) => RecipeViewModel.of(RecipeEntityJson.of(item)))
        .toList();
    // create the view model with type import
    var selectionModel = RecipeSelectionModel.forImport(viewModel);
    // navigate to the selection screen
    await navigator.pushNamed(RecipeSelectionScreen.id,
        arguments: selectionModel);
  }
}

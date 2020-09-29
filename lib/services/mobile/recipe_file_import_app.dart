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
import 'package:flutter_translate/flutter_translate.dart';
import 'package:cookza/localization/keys.dart';

class RecipeFileImportImpl extends RecipeFileImport {
  @override
  void parseAndImport(BuildContext context) async {
    var filePickerResult = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        allowedExtensions: ['json'],
        type: FileType.custom,
        allowCompression: true);
    if (filePickerResult == null || filePickerResult.paths.length != 1) {
      return;
    }
    File file = File(filePickerResult.paths.first);

    List<Recipe> result = [];
    if (file == null) {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text(translate(Keys.Ui_Nofileselected))));

      return; // no file selected
    }
    if (!file.existsSync()) {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text(translate(Keys.Ui_Filenotfound))));
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
    Navigator.pushNamed(context, RecipeSelectionScreen.id,
        arguments: selectionModel);
  }
}

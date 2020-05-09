import 'dart:convert';

import 'package:cookly/model/json/recipe.dart';
import 'package:cookly/model/json/recipe_list.dart';
import 'package:cookly/model/view/recipe_selection_model.dart';
import 'package:cookly/model/view/recipe_view_model.dart';
import 'package:cookly/screens/recipe_selection_screen.dart';
import 'package:cookly/services/abstract/recipe_file_import.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class RecipeFileImportImpl extends RecipeFileImport {
  @override
  void parseAndImport(BuildContext context,
      {bool selectionDialog = true}) async {
    var file = await FilePicker.getFile(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    List<Recipe> result = [];
    if (file == null) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('No file was selected')));

      return; // no file selected
    }
    if (!file.existsSync()) {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('The selected file does not exist')));
      return;
    }

    var content = file.readAsStringSync();
    RecipeList model = RecipeList.fromJson(jsonDecode(content));
    for (var item in model.recipes) {
      result.add(item);
    }

    var viewModel = result.map((item) => RecipeViewModel.of(item)).toList();
    // create the view model with type import
    var selectionModel = RecipeSelectionModel(SELECTION_MODE.IMPORT, viewModel);
    // navigate to the selection screen
    Navigator.pushNamed(context, RecipeSelectionScreen.id,
        arguments: selectionModel);
  }
}

import 'dart:convert';

import 'package:cookly/model/json/profile.dart';
import 'package:cookly/model/json/recipe.dart';
import 'package:cookly/model/json/recipe_list.dart';
import 'package:cookly/model/view/recipe_selection_model.dart';
import 'package:cookly/model/view/recipe_view_model.dart';
import 'package:cookly/screens/recipe_selection_screen.dart';
import 'package:cookly/services/abstract/recipe_file_import.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:html' as html;

class RecipeFileImportImpl extends RecipeFileImport {
  @override
  void parseAndImport(BuildContext context, {bool selectionDialog = true}) {
    // configure file selection dialog
    html.InputElement uploadInput = html.FileUploadInputElement();
    uploadInput.multiple = false;
    uploadInput.click();

    // on file selection
    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files.length == 1) {
        final file = files[0];
        html.FileReader reader = html.FileReader();

        // if reading selected file succeeds
        reader.onLoadEnd.listen((e) {
          String data = reader.result;
          print('Read from file load up: $data');
          List<Recipe> result = [];

          var json = jsonDecode(data);
          RecipeList import = RecipeList.fromJson(json);
          for (var item in import.recipes) {
            result.add(item);
          }

          var viewModel =
              result.map((item) => RecipeViewModel.of(item)).toList();
          // create the view model with type import
          var model = RecipeSelectionModel.forImport(viewModel);
          // navigate to the selection screen
          Navigator.pushNamed(context, RecipeSelectionScreen.id,
              arguments: model);
        });

        // if reading file fails
        reader.onError.listen((fileEvent) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('Error parsing the file'),
            ),
          );
        });

        reader.readAsText(file);
      }
    });
  }
}

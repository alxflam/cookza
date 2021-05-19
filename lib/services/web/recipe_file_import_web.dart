import 'dart:convert';

import 'package:cookza/model/entities/json/recipe_entity.dart';
import 'package:cookza/model/json/recipe.dart';
import 'package:cookza/model/json/recipe_list.dart';
import 'package:cookza/viewmodel/recipe_selection_model.dart';
import 'package:cookza/screens/recipe_selection_screen.dart';
import 'package:cookza/services/abstract/recipe_file_import.dart';
import 'package:cookza/viewmodel/recipe_view/recipe_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:html' as html;

class RecipeFileImportImpl extends RecipeFileImport {
  @override
  void parseAndImport(BuildContext context) {
    // configure file selection dialog
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.multiple = false;
    uploadInput.click();

    // on file selection
    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files?.length == 1) {
        final file = files![0];
        html.FileReader reader = html.FileReader();

        // if reading selected file succeeds
        reader.onLoadEnd.listen((e) {
          String data = reader.result?.toString() ?? '';
          print('Read from file load up: $data');
          List<Recipe> result = [];

          var json = jsonDecode(data);
          RecipeList import = RecipeList.fromJson(json);
          for (var item in import.recipes) {
            result.add(item);
          }

          var viewModel = result
              .map((item) => RecipeViewModel.of(RecipeEntityJson.of(item)))
              .toList();
          // create the view model with type import
          var model = RecipeSelectionModel.forImport(viewModel);
          // navigate to the selection screen
          Navigator.pushNamed(context, RecipeSelectionScreen.id,
              arguments: model);
        });

        // if reading file fails
        reader.onError.listen((fileEvent) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context).parseErrorRecipe),
            ),
          );
        });

        reader.readAsText(file);
      }
    });
  }
}

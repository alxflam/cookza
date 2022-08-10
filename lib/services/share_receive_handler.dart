import 'dart:convert';

import 'package:cookza/constants.dart';
import 'package:cookza/model/entities/json/recipe_entity.dart';
import 'package:cookza/model/entities/mutable/mutable_recipe.dart';
import 'package:cookza/model/json/recipe_list.dart';
import 'package:cookza/services/api/registry.dart';
import 'package:cookza/services/flutter/navigator_service.dart';
import 'package:cookza/viewmodel/recipe_edit/recipe_edit_model.dart';
import 'package:cookza/viewmodel/recipe_selection_model.dart';
import 'package:cookza/screens/recipe_modify/new_recipe_screen.dart';
import 'package:cookza/screens/recipe_selection_screen.dart';
import 'package:cookza/viewmodel/recipe_view/recipe_view_model.dart';
import 'package:flutter/cupertino.dart';

import 'flutter/service_locator.dart';

class ShareReceiveHandler {
  void handleReceivedText(String? text, NavigatorState navigator) {
    if (text == null || text.isEmpty) {
      return;
    }

    var importers = ImporterRegistry().getImporters();
    for (var importer in importers) {
      if (importer.canHandle(text)) {
        importer.getRecipe(text).then((recipe) => {
              MutableRecipe.createFrom(recipe).then(
                (mutableRecipe) => navigator.pushNamed(NewRecipeScreen.id,
                    arguments: RecipeEditModel.modify(mutableRecipe)),
              )
            });
        // only process the first importer which is capable of processing the data
        return;
      }
    }

    kErrorDialog(
        sl.get<NavigatorService>().currentContext!,
        'Could not import text',
        'The text that got shared to Cookza could not be imported. There\'s no registered handler for the given text: $text.');
  }

  void handleReceivedJson(String? text, NavigatorState navigator) {
    if (text == null || text.isEmpty) {
      return;
    }
    var map = jsonDecode(text);

    var isRecipeList = map['recipes'] != null;
    if (isRecipeList) {
      var importData = RecipeList.fromJson(map);
      var viewModel = importData.recipes
          .map((item) => RecipeViewModel.of(RecipeEntityJson.of(item)))
          .toList();

      var model = RecipeSelectionModel.forImport(viewModel);
      navigator.pushNamed(RecipeSelectionScreen.id, arguments: model);
    }
  }
}

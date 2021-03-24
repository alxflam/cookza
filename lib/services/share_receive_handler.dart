import 'dart:convert';

import 'package:cookza/constants.dart';
import 'package:cookza/model/entities/json/recipe_entity.dart';
import 'package:cookza/model/json/recipe_list.dart';
import 'package:cookza/viewmodel/recipe_edit/recipe_edit_model.dart';
import 'package:cookza/viewmodel/recipe_selection_model.dart';
import 'package:cookza/screens/recipe_modify/new_recipe_screen.dart';
import 'package:cookza/screens/recipe_selection_screen.dart';
import 'package:cookza/services/api/chefkoch.dart';
import 'package:cookza/viewmodel/recipe_view/recipe_view_model.dart';
import 'package:flutter/cupertino.dart';

class ShareReceiveHandler {
  void handleReceivedText(String? text, BuildContext context) {
    if (text == null || text.isEmpty) {
      return;
    }
    print('received in handler: $text');

    // todo: make it more flexible: register multiple handlers, with methods canHandle() to identify which one can handle the shared text...
    var exp = RegExp(r'rezepte\/([0-9]*)\/');
    var matches = exp.allMatches(text);

    if (matches.isEmpty) {
      kErrorDialog(context, 'Could not import text',
          'The text that got shared to Cookza could not be imported. There\'s no registered handler for the given text: $text.');
    }

    matches.forEach(
      (match) {
        var id = text.substring(match.start + 8, match.end - 1);
        Chefkoch().getRecipe(id).then(
          (recipe) {
            Navigator.pushNamed(context, NewRecipeScreen.id,
                arguments: RecipeEditModel.modify(recipe));
          },
        );
      },
    );
  }

  void handleReceivedJson(String? text, BuildContext context) {
    if (text == null || text.isEmpty) {
      return;
    }

    // find out what kind of json we got

    var map = jsonDecode(text);
    print('received json $map');

    var isRecipeList = map['recipes'] != null;
    if (isRecipeList) {}

    var importData = RecipeList.fromJson(map);
    var viewModel = importData.recipes
        .map((item) => RecipeViewModel.of(RecipeEntityJson.of(item)))
        .toList();

    // todo: create named constructors for import / export instead of giving a parameter
    var model = RecipeSelectionModel.forImport(viewModel);
    Navigator.pushNamed(context, RecipeSelectionScreen.id, arguments: model);
  }
}

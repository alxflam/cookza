import 'package:cookly/localization/keys.dart';
import 'package:cookly/services/recipe_manager.dart';
import 'package:cookly/viewmodel/recipe_selection_model.dart';
import 'package:cookly/screens/recipe_selection_screen.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:cookly/viewmodel/recipe_view/recipe_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ExportSettingsScreen extends StatelessWidget {
  static final String id = 'exportSettings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          translate(Keys.Ui_Export),
        ),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Share with other cookly users'),
            leading: FaIcon(FontAwesomeIcons.fileExport),
            onTap: () async {
              // fetch all recipes the app currently stores
              var recipes = await sl.get<RecipeManager>().getAllRecipes();
              // create the view model with type export
              var model = RecipeSelectionModel.forExport(
                  recipes.map((e) => RecipeViewModel.of(e)).toList());
              // navigate to the selection screen
              Navigator.pushNamed(context, RecipeSelectionScreen.id,
                  arguments: model);
            },
          ),
          ListTile(
            title: Text('PDF'),
            leading: FaIcon(FontAwesomeIcons.filePdf),
            onTap: () async {
              // fetch all recipes the app currently stores
              var recipes = await sl.get<RecipeManager>().getAllRecipes();
              //sl.get<ImageManager>().appProfile.recipes;
              // create the view model with type export
              var model = RecipeSelectionModel.forExportPDF(
                  recipes.map((e) => RecipeViewModel.of(e)).toList());
              // navigate to the selection screen
              Navigator.pushNamed(context, RecipeSelectionScreen.id,
                  arguments: model);
            },
          ),
        ],
      ),
    );
  }
}

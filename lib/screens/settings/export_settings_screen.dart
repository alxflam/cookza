import 'package:cookza/services/abstract/recipe_file_export.dart';
import 'package:cookza/services/recipe/recipe_manager.dart';
import 'package:cookza/viewmodel/recipe_selection_model.dart';
import 'package:cookza/screens/recipe_selection_screen.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/viewmodel/recipe_view/recipe_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ExportSettingsScreen extends StatelessWidget {
  static final String id = 'exportSettings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.export,
        ),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text(AppLocalizations.of(context)!.json),
            leading: FaIcon(FontAwesomeIcons.fileExport),
            onTap: () async {
              // fetch all recipes the app currently stores
              var recipes = await sl.get<RecipeManager>().getAllRecipes();
              // create the view model with type export
              var model = RecipeSelectionModel.forExport(
                  recipes.map((e) => RecipeViewModel.of(e)).toList());
              // navigate to the selection screen
              await Navigator.pushNamed(context, RecipeSelectionScreen.id,
                  arguments: model);
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.pdf),
            leading: FaIcon(FontAwesomeIcons.filePdf),
            onTap: () async {
              // fetch all recipes the app currently stores
              var recipes = await sl.get<RecipeManager>().getAllRecipes();
              //sl.get<ImageManager>().appProfile.recipes;
              // create the view model with type export
              var model = RecipeSelectionModel.forExportPDF(
                  recipes.map((e) => RecipeViewModel.of(e)).toList());
              // navigate to the selection screen
              await Navigator.pushNamed(context, RecipeSelectionScreen.id,
                  arguments: model);
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.backup),
            leading: FaIcon(FontAwesomeIcons.fileArchive),
            onTap: () async {
              // fetch all recipes the app currently stores
              var recipes = await sl.get<RecipeManager>().getAllRecipes();
              // export all the recipes
              sl.get<RecipeFileExport>().exportRecipesFromEntity(recipes);
            },
          ),
        ],
      ),
    );
  }
}

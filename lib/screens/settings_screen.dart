import 'package:cookly/constants.dart';
import 'package:cookly/localization/keys.dart';
import 'package:cookly/model/recipe_selection_model.dart';
import 'package:cookly/model/recipe_view_model.dart';
import 'package:cookly/screens/camera.dart';
import 'package:cookly/screens/ocr_screen.dart';
import 'package:cookly/screens/onboarding_screen.dart';
import 'package:cookly/screens/recipe_selection_screen.dart';
import 'package:cookly/services/data_store.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';

class SettingsScreen extends StatelessWidget {
  static final String id = 'settingsScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate(Keys.Ui_Settings)),
      ),
      body: ListView(
        children: <Widget>[
          // SwitchListTile(
          //   title: Text('Switch'),
          //   value: false,
          //   onChanged: (bool value) {},
          //   secondary: const Icon(Icons.lightbulb_outline),
          // ),
          // RadioListTile<SingingCharacter>(
          //   title: const Text('Lafayette'),
          //   value: SingingCharacter.lafayette,
          //   groupValue: _character,
          //   onChanged: (SingingCharacter value) {},
          // ),
          // RadioListTile<SingingCharacter>(
          //   title: const Text('Thomas Jefferson'),
          //   value: SingingCharacter.jefferson,
          //   groupValue: _character,
          //   onChanged: (SingingCharacter value) {},
          // ),
          ListTile(
            title: Text(translate(Keys.Ui_Export)),
            leading: FaIcon(FontAwesomeIcons.fileExport),
            onTap: () {
              // fetch all recipes the app currently stores
              var recipes = sl.get<DataStore>().appProfile.recipes;
              // create the view model with type export
              var model = RecipeSelectionModel(
                  mode: DATA_EXCHANGE_DIRECTION.EXPORT,
                  recipes: recipes.toList());
              // navigate to the selection screen
              Navigator.pushNamed(context, RecipeSelectionScreen.id,
                  arguments: model);
            },
          ),
          ListTile(
            title: Text(translate(Keys.Ui_Import)),
            leading: FaIcon(FontAwesomeIcons.fileImport),
            onTap: () async {
              // open the file selection dialog for the user to select a json file
              var recipes = await sl.get<DataStore>().getRecipesFromJsonFile();
              // construct the list of recipes fom the json
              var viewModel =
                  recipes.map((item) => RecipeViewModel.of(item)).toList();
              // create the view model with type import
              var model = RecipeSelectionModel(
                  mode: DATA_EXCHANGE_DIRECTION.IMPORT, recipes: viewModel);
              // navigate to the selection screen
              Navigator.pushNamed(context, RecipeSelectionScreen.id,
                  arguments: model);
            },
          ),
          ListTile(
            title: Text('§Test OCR'),
            onTap: () => Navigator.pushNamed(context, OCRTestScreen.id),
          ),
          ListTile(
            title: Text('§Show Onboarding Intro'),
            onTap: () => Navigator.pushNamed(context, OnBoardingScreen.id),
          ),
          ListTile(
            title: Text('§Show Changelog'),
            onTap: () => kNotImplementedDialog(context),
          ),
          ListTile(
            title: Text('§Test Camera Picker'),
            onTap: () => Navigator.pushNamed(context, MyHomePage.id),
          ),
        ],
      ),
    );
  }
}

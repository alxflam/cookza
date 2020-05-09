import 'package:cookly/constants.dart';
import 'package:cookly/localization/keys.dart';
import 'package:cookly/model/view/recipe_selection_model.dart';
import 'package:cookly/model/view/recipe_view_model.dart';
import 'package:cookly/screens/settings/camera.dart';
import 'package:cookly/screens/settings/ocr_screen.dart';
import 'package:cookly/screens/settings/onboarding_screen.dart';
import 'package:cookly/screens/recipe_selection_screen.dart';
import 'package:cookly/services/abstract/data_store.dart';
import 'package:cookly/services/abstract/recipe_file_import.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsScreen extends StatelessWidget {
  static final String id = 'settings';

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
              var model =
                  RecipeSelectionModel(SELECTION_MODE.EXPORT, recipes.toList());
              // navigate to the selection screen
              Navigator.pushNamed(context, RecipeSelectionScreen.id,
                  arguments: model);
            },
          ),
          ListTile(
            title: Text(translate(Keys.Ui_Import)),
            leading: FaIcon(FontAwesomeIcons.fileImport),
            onTap: () async {
              sl.get<RecipeFileImport>().parseAndImport(context);
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

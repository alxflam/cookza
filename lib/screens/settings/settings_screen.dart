import 'package:cookly/constants.dart';
import 'package:cookly/localization/keys.dart';
import 'package:cookly/model/view/recipe_selection_model.dart';
import 'package:cookly/model/view/recipe_view_model.dart';
import 'package:cookly/screens/settings/camera.dart';
import 'package:cookly/screens/settings/export_settings_screen.dart';
import 'package:cookly/screens/settings/meal_plan_settings_screen.dart';
import 'package:cookly/screens/settings/ocr_screen.dart';
import 'package:cookly/screens/settings/onboarding_screen.dart';
import 'package:cookly/screens/recipe_selection_screen.dart';
import 'package:cookly/screens/settings/saved_images_screen.dart';
import 'package:cookly/screens/settings/theme_settings_screen.dart';
import 'package:cookly/screens/settings/uom_visibility_settings_screen.dart';
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
      body: Builder(
        builder: (context) {
          return ListView(
            children: <Widget>[
              ListTile(
                title: Text(translate(Keys.Ui_Export)),
                leading: FaIcon(FontAwesomeIcons.fileExport),
                onTap: () =>
                    Navigator.pushNamed(context, ExportSettingsScreen.id),
              ),
              ListTile(
                title: Text(translate(Keys.Ui_Import)),
                leading: FaIcon(FontAwesomeIcons.fileImport),
                onTap: () {
                  sl.get<RecipeFileImport>().parseAndImport(context);
                },
              ),
              ListTile(
                title: Text(translate(Keys.Recipe_Unit)),
                leading: FaIcon(FontAwesomeIcons.unity),
                onTap: () {
                  Navigator.pushNamed(context, UoMVisibilityScreen.id);
                },
              ),
              ListTile(
                title: Text(translate(Keys.Theme_Title)),
                leading: FaIcon(FontAwesomeIcons.themeco),
                onTap: () {
                  Navigator.pushNamed(context, ThemeSettingsScreen.id);
                },
              ),
              ListTile(
                title: Text(translate(Keys.Functions_Mealplanner)),
                leading: FaIcon(kMealPlannerIconData),
                onTap: () {
                  Navigator.pushNamed(context, MealPlanSettingsScreen.id);
                },
              ),
              ListTile(
                title: Text('§Saved Images'),
                leading: FaIcon(FontAwesomeIcons.camera),
                onTap: () {
                  Navigator.pushNamed(context, SavedImagesScreen.id);
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
          );
        },
      ),
    );
  }
}

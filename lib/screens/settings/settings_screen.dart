import 'package:cookza/constants.dart';
import 'package:cookza/localization/keys.dart';
import 'package:cookza/screens/settings/about_screen.dart';
import 'package:cookza/screens/settings/export_settings_screen.dart';
import 'package:cookza/screens/settings/meal_plan_settings_screen.dart';
import 'package:cookza/screens/settings/shopping_list_settings_screen.dart';
import 'package:cookza/screens/settings/theme_settings_screen.dart';
import 'package:cookza/screens/settings/uom_visibility_settings_screen.dart';
import 'package:cookza/services/abstract/recipe_file_import.dart';
import 'package:cookza/services/flutter/service_locator.dart';
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
                title: Text(translate(Keys.Recipe_Unitlongplural)),
                leading: FaIcon(FontAwesomeIcons.unity),
                onTap: () {
                  Navigator.pushNamed(context, UoMVisibilityScreen.id);
                },
              ),
              ListTile(
                title: Text(translate(Keys.Theme_Title)),
                leading: FaIcon(FontAwesomeIcons.paintBrush),
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
                title: Text(translate(Keys.Functions_Shoppinglist)),
                leading: FaIcon(kShoppingListIconData),
                onTap: () {
                  Navigator.pushNamed(context, ShoppingListSettingsScreen.id);
                },
              ),
              ListTile(
                title: Text(MaterialLocalizations.of(context)
                    .aboutListTileTitle(translate(Keys.App_Title))),
                leading: FaIcon(Icons.info),
                onTap: () {
                  Navigator.pushNamed(context, AboutScreen.id);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

import 'package:cookza/constants.dart';
import 'package:cookza/screens/settings/about_screen.dart';
import 'package:cookza/screens/settings/meal_plan_settings_screen.dart';
import 'package:cookza/screens/settings/shopping_list_settings_screen.dart';
import 'package:cookza/screens/settings/theme_settings_screen.dart';
import 'package:cookza/screens/settings/uom_visibility_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsScreen extends StatelessWidget {
  static final String id = 'settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).settings),
      ),
      body: Builder(
        builder: (context) {
          return ListView(
            children: <Widget>[
              ListTile(
                title: Text(AppLocalizations.of(context).unitLongPlural),
                leading: FaIcon(FontAwesomeIcons.unity),
                onTap: () {
                  Navigator.pushNamed(context, UoMVisibilityScreen.id);
                },
              ),
              ListTile(
                title: Text(AppLocalizations.of(context).themeTitle),
                leading: FaIcon(FontAwesomeIcons.paintBrush),
                onTap: () {
                  Navigator.pushNamed(context, ThemeSettingsScreen.id);
                },
              ),
              ListTile(
                title: Text(AppLocalizations.of(context).functionsMealPlanner),
                leading: FaIcon(kMealPlannerIconData),
                onTap: () {
                  Navigator.pushNamed(context, MealPlanSettingsScreen.id);
                },
              ),
              ListTile(
                title: Text(AppLocalizations.of(context).functionsShoppingList),
                leading: FaIcon(kShoppingListIconData),
                onTap: () {
                  Navigator.pushNamed(context, ShoppingListSettingsScreen.id);
                },
              ),
              ListTile(
                title: Text(MaterialLocalizations.of(context)
                    .aboutListTileTitle(kAppName)),
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

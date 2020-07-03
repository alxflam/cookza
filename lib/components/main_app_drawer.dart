import 'package:cookly/localization/keys.dart';
import 'package:cookly/screens/collections/share_account_screen.dart';
import 'package:cookly/screens/meal_plan/meal_plan_screen.dart';
import 'package:cookly/screens/recipe_list_screen.dart';
import 'package:cookly/screens/recipe_modify/new_recipe_screen.dart';
import 'package:cookly/screens/settings/settings_screen.dart';
import 'package:cookly/screens/web_login_app.dart';
import 'package:cookly/viewmodel/recipe_edit/recipe_edit_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants.dart';

class MainAppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(kAppIconData),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Cookly',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                  ],
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          ListTile(
            title: Text(translatePlural(Keys.Ui_Recipe, 2)),
            leading: FaIcon(kRecipesIconData),
            onTap: () {
              Navigator.pushNamed(context, RecipeListScreen.id);
            },
          ),
          ListTile(
            title: Text(translate(Keys.Functions_Mealplanner)),
            leading: FaIcon(kMealPlannerIconData),
            onTap: () {
              Navigator.pushNamed(context, MealPlanScreen.id);
            },
          ),
          ListTile(
            title: Text(translate(Keys.Functions_Shoppinglist)),
            leading: FaIcon(kShoppingListIconData),
            onTap: () {},
          ),
          ListTile(
            title: Text(translate(Keys.Functions_Addrecipe)),
            leading: FaIcon(FontAwesomeIcons.plus),
            onTap: () => Navigator.pushNamed(context, NewRecipeScreen.id,
                arguments: RecipeEditModel.create()),
          ),
          ListTile(
            title:
                Text('${translate(Keys.App_Title)} ${translate(Keys.Ui_Web)}'),
            leading: FaIcon(kWebAppData),
            onTap: () => Navigator.pushNamed(context, WebLoginOnAppScreen.id),
          ),
          ListTile(
            title: Text(translate(Keys.Ui_Shareaccount)),
            leading: FaIcon(FontAwesomeIcons.handshake),
            onTap: () => Navigator.pushNamed(context, ShareAccountScreen.id),
          ),
          ListTile(
            title: Text(translate(Keys.Ui_Settings)),
            leading: FaIcon(FontAwesomeIcons.cog),
            onTap: () => Navigator.pushNamed(context, SettingsScreen.id),
          ),
        ],
      ),
    );
  }
}

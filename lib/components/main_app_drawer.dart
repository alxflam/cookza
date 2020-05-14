import 'package:cookly/localization/keys.dart';
import 'package:cookly/model/view/recipe_edit_model.dart';
import 'package:cookly/screens/meal_plan/meal_plan_screen.dart';
import 'package:cookly/screens/recipe_modify/new_recipe_screen.dart';
import 'package:cookly/screens/settings/settings_screen.dart';
import 'package:cookly/services/app_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class MainAppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.subtitle1;

    final List<Widget> aboutBoxChildren = <Widget>[
      SizedBox(height: 24),
      RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
                style: textStyle,
                text:
                    'Cookly enables you to store, collect and share your favourite recipes in a data-privacy friendly manner.'),
          ],
        ),
      ),
    ];

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
                Text(
                    '${Provider.of<AppProfile>(context).countRecipes} Recipes available'),
                Text(
                    'Last added: ${Provider.of<AppProfile>(context).lastAddedRecipe}'),
                Text(
                    'Last planned: ${Provider.of<AppProfile>(context).lastPlannedRecipe}'),
              ],
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          ListTile(
            title: Text(translatePlural(Keys.Ui_Recipe, 2)),
            leading: Icon(kRecipesIconData),
            onTap: () {},
          ),
          ListTile(
            title: Text(translate(Keys.Functions_Mealplanner)),
            leading: Icon(kMealPlannerIconData),
            onTap: () {
              Navigator.pushNamed(context, MealPlanScreen.id);
            },
          ),
          ListTile(
            title: Text(translate(Keys.Functions_Shoppinglist)),
            leading: Icon(kShoppingListIconData),
            onTap: () {},
          ),
          ListTile(
            title: Text(translate(Keys.Functions_Addrecipe)),
            leading: Icon(FontAwesomeIcons.plus),
            onTap: () => Navigator.pushNamed(context, NewRecipeScreen.id,
                arguments: RecipeEditModel.create()),
          ),
          ListTile(
            title: Text(translate(Keys.Ui_Settings)),
            leading: Icon(FontAwesomeIcons.cog),
            onTap: () => Navigator.pushNamed(context, SettingsScreen.id),
          ),
          AboutListTile(
            icon: Icon(kInfoIconData),
            applicationVersion: '2020-05',
            applicationIcon: Icon(kAppIconData),
            applicationLegalese: '© 2020',
            aboutBoxChildren: aboutBoxChildren,
          ),
        ],
      ),
    );
  }
}

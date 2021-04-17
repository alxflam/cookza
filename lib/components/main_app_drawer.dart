import 'package:cookza/components/app_icon_text.dart';
import 'package:cookza/screens/collections/share_account_screen.dart';
import 'package:cookza/screens/leftovers_screen.dart';
import 'package:cookza/screens/meal_plan/meal_plan_screen.dart';
import 'package:cookza/screens/recipe_list_screen.dart';
import 'package:cookza/screens/recipe_modify/new_recipe_screen.dart';
import 'package:cookza/screens/settings/settings_screen.dart';
import 'package:cookza/screens/shopping_list/shopping_list_overview_screen.dart';
import 'package:cookza/viewmodel/recipe_edit/recipe_edit_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: AppIconTextWidget(),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.functionsListRecipes),
            leading: FaIcon(kRecipesIconData),
            onTap: () {
              Navigator.pushNamed(context, RecipeListScreen.id);
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.functionsAddRecipe),
            leading: FaIcon(kNewRecipe),
            onTap: () => Navigator.pushNamed(context, NewRecipeScreen.id,
                arguments: RecipeEditModel.create()),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.functionsMealPlanner),
            leading: FaIcon(kMealPlannerIconData),
            onTap: () {
              Navigator.pushNamed(context, MealPlanScreen.id);
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.functionsShoppingList),
            leading: FaIcon(kShoppingListIconData),
            onTap: () {
              Navigator.pushNamed(context, ShoppingListOverviewScreen.id);
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.functionsLeftovers),
            leading: FaIcon(kLeftoversIconData),
            onTap: () => Navigator.pushNamed(context, LeftoversScreen.id),
          ),
          _getWebAppListTile(context),
          ListTile(
            title: Text(AppLocalizations.of(context)!.shareAccount),
            leading: FaIcon(kShareAccountIcon),
            onTap: () => Navigator.pushNamed(context, ShareAccountScreen.id),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.settings),
            leading: FaIcon(kSettingsIcon),
            onTap: () => Navigator.pushNamed(context, SettingsScreen.id),
          ),
        ],
      ),
    );
  }

  ListTile _getWebAppListTile(BuildContext context) {
    if (kIsWeb) {
      return ListTile(
          title: Text(AppLocalizations.of(context)!.logout),
          leading: Icon(Icons.power_settings_new),
          onTap: () async {
            // var util = sl.get<FirebaseProvider>();
            // await util.logOffFromWebClient(util.userUid);
          });
    }
    return ListTile(
      title: Text('$kAppName ${AppLocalizations.of(context)!.web}'),
      leading: FaIcon(kWebAppData),
      // onTap: () => Navigator.pushNamed(context, WebLoginOnAppScreen.id),
    );
  }
}

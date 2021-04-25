import 'package:cookza/components/main_app_drawer.dart';
import 'package:cookza/constants.dart';
import 'package:cookza/screens/favorites/favorites_screen.dart';
import 'package:cookza/screens/leftovers_screen.dart';
import 'package:cookza/screens/meal_plan/meal_plan_screen.dart';
import 'package:cookza/screens/recipe_list_screen.dart';
import 'package:cookza/screens/recipe_modify/new_recipe_screen.dart';
import 'package:cookza/screens/shopping_list/shopping_list_overview_screen.dart';
import 'package:cookza/services/abstract/receive_intent_handler.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/viewmodel/recipe_edit/recipe_edit_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  static final id = 'home';

  void init(BuildContext context) async {
    // check for shared content on mobile platforms
    if (!kIsWeb) {
      // setup share intent listener
      SystemChannels.lifecycle.setMessageHandler((msg) {
        if (msg == AppLifecycleState.resumed.toString()) {
          var handler = sl.get<ReceiveIntentHandler>();
          handler.handleSharedText(context);
          handler.handleSharedJson(context);
        }
        return Future.value(null);
      });

      // get share handler
      var handler = sl.get<ReceiveIntentHandler>();
      handler.handleSharedText(context);
      handler.handleSharedJson(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    init(context);

    var tileColor = Theme.of(context).cardColor;

    return Scaffold(
      drawer: MainAppDrawer(),
      appBar: AppBar(
        title: Text(
          kAppName,
          style: TextStyle(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: MainFunctionCard(
                    onPress: () => Navigator.pushNamed(
                        context, NewRecipeScreen.id,
                        arguments: RecipeEditModel.create()),
                    color: tileColor,
                    cardChild: IconContent(
                      icon: kNewRecipe,
                      label: AppLocalizations.of(context)!.functionsAddRecipe,
                    ),
                  ),
                ),
                Expanded(
                  child: MainFunctionCard(
                    onPress: () =>
                        Navigator.pushNamed(context, FavoriteRecipesScreen.id),
                    color: tileColor,
                    cardChild: IconContent(
                      icon: kFavoriteRecipes,
                      label: AppLocalizations.of(context)!.functionsFavorites,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: MainFunctionCard(
                    onPress: () =>
                        Navigator.pushNamed(context, LeftoversScreen.id),
                    color: tileColor,
                    cardChild: IconContent(
                      icon: kLeftoversIconData,
                      label: AppLocalizations.of(context)!.functionsLeftovers,
                    ),
                  ),
                ),
                Expanded(
                  child: MainFunctionCard(
                    onPress: () =>
                        Navigator.pushNamed(context, RecipeListScreen.id),
                    color: tileColor,
                    cardChild: IconContent(
                      icon: kRecipesIconData,
                      label: AppLocalizations.of(context)!.functionsListRecipes,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: MainFunctionCard(
                    onPress: () => Navigator.pushNamed(
                        context, ShoppingListOverviewScreen.id),
                    color: tileColor,
                    cardChild: IconContent(
                      icon: kShoppingListIconData,
                      label:
                          AppLocalizations.of(context)!.functionsShoppingList,
                    ),
                  ),
                ),
                Expanded(
                  child: MainFunctionCard(
                    onPress: () =>
                        Navigator.pushNamed(context, MealPlanScreen.id),
                    color: tileColor,
                    cardChild: IconContent(
                      icon: kMealPlannerIconData,
                      label: AppLocalizations.of(context)!.functionsMealPlanner,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MainFunctionCard extends StatelessWidget {
  MainFunctionCard(
      {required this.color, required this.cardChild, required this.onPress});

  final Color color;
  final Widget cardChild;
  final GestureTapCallback onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: this.color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: cardChild,
      ),
    );
  }
}

class IconContent extends StatelessWidget {
  IconContent({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FaIcon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 70,
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          label,
        )
      ],
    );
  }
}

import 'package:cookly/components/main_app_drawer.dart';
import 'package:cookly/constants.dart';
import 'package:cookly/localization/keys.dart';
import 'package:cookly/model/view/recipe_edit_model.dart';
import 'package:cookly/screens/leftovers_screen.dart';
import 'package:cookly/screens/meal_plan/meal_plan_screen.dart';
import 'package:cookly/screens/recipe_list_screen.dart';
import 'package:cookly/screens/recipe_modify/new_recipe_screen.dart';
import 'package:cookly/screens/shopping_list/shopping_list_overview_screen.dart';
import 'package:cookly/services/abstract/receive_intent_handler.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    return Scaffold(
      drawer: MainAppDrawer(),
      appBar: AppBar(
        title: Text(
          translate(Keys.App_Title),
          style: TextStyle(),
        ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(kAppIconData),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ReusableCard(
                    onPress: () => Navigator.pushNamed(
                        context, NewRecipeScreen.id,
                        arguments: RecipeEditModel.create()),
                    color: Colors.teal.shade900,
                    cardChild: IconContent(
                      icon: Icons.star,
                      label: translate(Keys.Functions_Addrecipe),
                    ),
                  ),
                ),
                Expanded(
                  child: ReusableCard(
                    onPress: () =>
                        Navigator.pushNamed(context, RecipeListScreen.id),
                    color: Colors.teal.shade900,
                    cardChild: IconContent(
                      icon: kRecipesIconData,
                      label: translate(Keys.Functions_Listrecipes),
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
                  child: ReusableCard(
                    onPress: () => Navigator.pushNamed(
                        context, ShoppingListOverviewScreen.id),
                    color: Colors.teal.shade900,
                    cardChild: IconContent(
                      icon: kShoppingListIconData,
                      label: translate(Keys.Functions_Shoppinglist),
                    ),
                  ),
                ),
                Expanded(
                  child: ReusableCard(
                    onPress: () =>
                        Navigator.pushNamed(context, MealPlanScreen.id),
                    color: Colors.teal.shade900,
                    cardChild: IconContent(
                      icon: kMealPlannerIconData,
                      label: translate(Keys.Functions_Mealplanner),
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
                  child: ReusableCard(
                    onPress: () =>
                        Navigator.pushNamed(context, LeftoversScreen.id),
                    color: Colors.teal.shade900,
                    cardChild: IconContent(
                      icon: kLeftoversIconData,
                      label: translate(Keys.Functions_Leftovers),
                    ),
                  ),
                ),
                Expanded(
                  child: ReusableCard(
                    onPress: () => kNotImplementedDialog(context),
                    color: Colors.teal.shade900,
                    cardChild: IconContent(
                      icon: kMarketplaceIconData,
                      label: translate(Keys.Functions_Marketplace),
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

class ReusableCard extends StatelessWidget {
  ReusableCard({@required this.color, this.cardChild, this.onPress});

  final Color color;
  final Widget cardChild;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        child: cardChild,
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: this.color,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

class IconContent extends StatelessWidget {
  IconContent({@required this.icon, @required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FaIcon(
          icon,
          size: 80,
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

class TopBarIconButton extends StatelessWidget {
  final IconData icon;
  final Function onTap;

  TopBarIconButton({this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0),
      onPressed: onTap != null ? onTap : () {},
      child: Icon(
        this.icon,
        color: Colors.white,
        size: 20.0,
      ),
    );
  }
}

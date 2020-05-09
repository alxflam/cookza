import 'package:cookly/components/main_app_drawer.dart';
import 'package:cookly/constants.dart';
import 'package:cookly/localization/keys.dart';
import 'package:cookly/model/view/recipe_edit_model.dart';
import 'package:cookly/screens/recipe_list_screen.dart';
import 'package:cookly/screens/recipe_modify/new_recipe_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';

class HomeScreen extends StatelessWidget {
  static final id = 'home';

  static const platform = const MethodChannel('app.channel.shared.data');

  void init(BuildContext context) async {
    // todo: maybe needed if app is completely closed when intent is received
    // SystemChannels.lifecycle.setMessageHandler((msg) {
    //   if (msg.contains('resumed')) {
    //     _getSharedText().then((d) {
    //       handleReceivedText(d, context);
    //     });
    //   }
    // });

// TODO: as this is platform dependent, refactor it to a service call!
    // get share handler
    // var handler = sl.get<ShareReceiveHandler>();

    // // handle shared text
    // var data = await _getSharedText();
    // handler.handleReceivedText(data, context);

    // // handle shared json
    // var jsonData = await _getSharedJson();
    // handler.handleReceivedJson(jsonData, context);
  }

  /// read shared text
  Future<String> _getSharedText() async =>
      await platform.invokeMethod('getSharedText');

  /// read shared json
  Future<String> _getSharedJson() async =>
      await platform.invokeMethod('getSharedJson');

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

                    // RecipeViewModel()),
                    color: Colors.teal.shade900,
                    cardChild: IconContent(
                      icon: Icons.add,
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
                      icon: Icons.list,
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
                    onPress: () => kNotImplementedDialog(context),
                    color: Colors.teal.shade900,
                    cardChild: IconContent(
                      icon: kShoppingListIconData,
                      label: translate(Keys.Functions_Shoppinglist),
                    ),
                  ),
                ),
                Expanded(
                  child: ReusableCard(
                    onPress: () => kNotImplementedDialog(context),
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
        Icon(
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

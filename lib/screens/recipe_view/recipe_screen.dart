import 'package:cookly/constants.dart';
import 'package:cookly/localization/keys.dart';
import 'package:cookly/model/view/recipe_edit_model.dart';
import 'package:cookly/model/view/recipe_view_model.dart';
import 'package:cookly/screens/home_screen.dart';
import 'package:cookly/screens/recipe_modify/new_recipe_screen.dart';
import 'package:cookly/screens/recipe_view/ingredients_tab.dart';
import 'package:cookly/screens/recipe_view/instructions_tab.dart';
import 'package:cookly/screens/recipe_view/overview_tab.dart';
import 'package:cookly/screens/recipe_view/similar_recipes_tab.dart';
import 'package:cookly/services/app_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class PopupMenuButtonChoices {
  final _key;
  final _icon;
  const PopupMenuButtonChoices._internal(this._key, this._icon);
  toString() => translate(_key);
  IconData get icon => this._icon;

  static const SHARE =
      const PopupMenuButtonChoices._internal(Keys.Ui_Share, Icons.share);
  static const EDIT =
      const PopupMenuButtonChoices._internal(Keys.Ui_Edit, Icons.edit);
  static const DELETE =
      const PopupMenuButtonChoices._internal(Keys.Ui_Delete, Icons.delete);
}

class RecipeScreen extends StatelessWidget {
  static final String id = 'recipe';

  @override
  Widget build(BuildContext context) {
    final String recipeId = ModalRoute.of(context).settings.arguments as String;

    RecipeViewModel baseModel =
        Provider.of<AppProfile>(context, listen: false).getRecipeById(recipeId);

    return ChangeNotifierProvider<RecipeViewModel>(
      create: (BuildContext context) {
        return baseModel;
      },
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: Text(baseModel.name != null ? baseModel.name : ''),
            actions: <Widget>[
              PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      child: Icon(PopupMenuButtonChoices.SHARE.icon),
                      value: PopupMenuButtonChoices.SHARE,
                    ),
                    PopupMenuItem(
                      child: Icon(PopupMenuButtonChoices.EDIT.icon),
                      value: PopupMenuButtonChoices.EDIT,
                    ),
                    PopupMenuItem(
                      child: Icon(PopupMenuButtonChoices.DELETE.icon),
                      value: PopupMenuButtonChoices.DELETE,
                    ),
                  ];
                },
                onSelected: (value) {
                  switch (value) {
                    case PopupMenuButtonChoices.SHARE:
                      kNotImplementedDialog(context);
                      break;
                    case PopupMenuButtonChoices.EDIT:
                      Navigator.pushNamed(context, NewRecipeScreen.id,
                          arguments: RecipeEditModel.modify(baseModel.recipe));
                      break;
                    case PopupMenuButtonChoices.DELETE:
                      showDialog(
                        context: context,
                        barrierDismissible: false, // user must tap button!
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(translate(Keys.Ui_Delete)),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Text(translate(Keys.Ui_Confirmdelete,
                                      args: {"0": baseModel.name})),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text(
                                  translate(Keys.Ui_Cancel),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: Text(
                                  translate(Keys.Ui_Delete),
                                ),
                                color: Colors.red,
                                onPressed: () {
                                  Provider.of<AppProfile>(context,
                                          listen: false)
                                      .deleteRecipe(baseModel.id);
                                  Navigator.pushNamed(context, HomeScreen.id);
                                },
                              ),
                            ],
                          );
                        },
                      );

                      break;
                    default:
                  }
                },
              ),
            ],
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: FaIcon(kInfoIconData),
                ),
                Tab(
                  icon: FaIcon(kIngredientsIconData),
                ),
                Tab(
                  icon: FaIcon(kRecipesIconData),
                ),
                Tab(
                  icon: FaIcon(kSimilarRecipesIconData),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              OverviewTab(),
              ListView(
                children: <Widget>[
                  ListOfIngredients(),
                ],
              ),
              ListView(
                children: <Widget>[
                  CookingInstructions(),
                ],
              ),
              SimilarRecipesScreen(),
            ],
          ),
        ),
      ),
    );
  }
}

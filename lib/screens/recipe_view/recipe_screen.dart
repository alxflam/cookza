import 'package:cookly/constants.dart';
import 'package:cookly/localization/keys.dart';
import 'package:cookly/model/entities/abstract/recipe_entity.dart';
import 'package:cookly/screens/home_screen.dart';
import 'package:cookly/screens/meal_plan/meal_plan_screen.dart';
import 'package:cookly/screens/recipe_modify/new_recipe_screen.dart';
import 'package:cookly/screens/recipe_view/ingredients_tab.dart';
import 'package:cookly/screens/recipe_view/instructions_tab.dart';
import 'package:cookly/screens/recipe_view/overview_tab.dart';
import 'package:cookly/screens/recipe_view/similar_recipes_tab.dart';
import 'package:cookly/services/abstract/pdf_export.dart';
import 'package:cookly/services/abstract/pdf_generator.dart';
import 'package:cookly/services/abstract/recipe_file_export.dart';
import 'package:cookly/services/abstract/recipe_text_export.dart';
import 'package:cookly/services/recipe/recipe_manager.dart';
import 'package:cookly/services/flutter/service_locator.dart';
import 'package:cookly/viewmodel/recipe_edit/recipe_edit_model.dart';
import 'package:cookly/viewmodel/recipe_view/recipe_view_model.dart';
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
  static const ADD_MEAL_PLAN = const PopupMenuButtonChoices._internal(
      Keys.Functions_Mealplanner, kMealPlannerIconData);
  static const DELETE =
      const PopupMenuButtonChoices._internal(Keys.Ui_Delete, Icons.delete);
}

class RecipeScreen extends StatelessWidget {
  static final String id = 'recipe';

  @override
  Widget build(BuildContext context) {
    final RecipeEntity recipe = ModalRoute.of(context).settings.arguments;

    RecipeViewModel baseModel = RecipeViewModel.of(recipe);
    return ChangeNotifierProvider<RecipeViewModel>(
      create: (BuildContext context) {
        return baseModel;
      },
      child: DefaultTabController(
        length: 4,
        child: Consumer<RecipeViewModel>(
          builder: (context, model, child) {
            return Scaffold(
              appBar: AppBar(
                title: Text(model.name != null ? model.name : ''),
                actions: <Widget>[
                  PopupMenuButton(
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(PopupMenuButtonChoices.SHARE.icon),
                              Text(PopupMenuButtonChoices.SHARE.toString())
                            ],
                          ),
                          value: PopupMenuButtonChoices.SHARE,
                        ),
                        PopupMenuItem(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(PopupMenuButtonChoices.EDIT.icon),
                              Text(PopupMenuButtonChoices.EDIT.toString())
                            ],
                          ),
                          value: PopupMenuButtonChoices.EDIT,
                        ),
                        PopupMenuItem(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(PopupMenuButtonChoices.ADD_MEAL_PLAN.icon),
                              Text(
                                PopupMenuButtonChoices.ADD_MEAL_PLAN.toString(),
                              )
                            ],
                          ),
                          value: PopupMenuButtonChoices.ADD_MEAL_PLAN,
                        ),
                        PopupMenuItem(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(PopupMenuButtonChoices.DELETE.icon),
                              Text(PopupMenuButtonChoices.DELETE.toString())
                            ],
                          ),
                          value: PopupMenuButtonChoices.DELETE,
                        ),
                      ];
                    },
                    onSelected: (value) async {
                      switch (value) {
                        case PopupMenuButtonChoices.SHARE:
                          _showShareDialog(context, baseModel);
                          break;
                        case PopupMenuButtonChoices.EDIT:
                          var result = await Navigator.pushNamed(
                              context, NewRecipeScreen.id,
                              arguments: RecipeEditModel.modify(model.recipe));
                          // refresh the current model as it now show stale data that got updated by editing the recipe
                          if (result != null && result is RecipeEntity) {
                            model.refreshFrom(result);
                          }

                          break;
                        case PopupMenuButtonChoices.ADD_MEAL_PLAN:
                          Navigator.pushNamed(context, MealPlanScreen.id,
                              arguments: model.recipe);
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
                                          args: {"0": model.name})),
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
                                      sl
                                          .get<RecipeManager>()
                                          .deleteRecipe(model.recipe);

                                      Navigator.pushNamed(
                                          context, HomeScreen.id);
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
                      IngredientsTab(),
                    ],
                  ),
                  ListView(
                    children: <Widget>[
                      InstructionsTab(),
                    ],
                  ),
                  SimilarRecipesScreen(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showShareDialog(BuildContext context, RecipeViewModel model) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(translate(Keys.Ui_Delete)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(translate(Keys.Ui_Shareas)),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                translate(Keys.Settings_Pdf),
              ),
              onPressed: () async {
                var doc = await sl.get<PDFGenerator>().generatePDF([model]);
                sl.get<PDFExporter>().export(doc);
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text(
                translate(Keys.Settings_Json),
              ),
              onPressed: () {
                sl
                    .get<RecipeFileExport>()
                    .exportRecipesFromEntity([model.recipe]);
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text(
                translate(Keys.Settings_Text),
              ),
              onPressed: () {
                sl
                    .get<RecipeTextExporter>()
                    .exportRecipesAsText([model.recipe]);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

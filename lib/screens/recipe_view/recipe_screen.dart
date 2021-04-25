import 'package:cookza/components/alert_dialog_title.dart';
import 'package:cookza/constants.dart';
import 'package:cookza/model/entities/abstract/recipe_entity.dart';
import 'package:cookza/screens/home_screen.dart';
import 'package:cookza/screens/meal_plan/meal_plan_screen.dart';
import 'package:cookza/screens/recipe_modify/new_recipe_screen.dart';
import 'package:cookza/screens/recipe_view/ingredients_tab.dart';
import 'package:cookza/screens/recipe_view/instructions_tab.dart';
import 'package:cookza/screens/recipe_view/overview_tab.dart';
import 'package:cookza/screens/recipe_view/similar_recipes_tab.dart';
import 'package:cookza/services/abstract/pdf_export.dart';
import 'package:cookza/services/abstract/pdf_generator.dart';
import 'package:cookza/services/abstract/recipe_file_export.dart';
import 'package:cookza/services/abstract/recipe_text_export.dart';
import 'package:cookza/services/recipe/recipe_manager.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/viewmodel/recipe_edit/recipe_edit_model.dart';
import 'package:cookza/viewmodel/recipe_view/recipe_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class PopupMenuButtonChoices {
  final _icon;
  const PopupMenuButtonChoices._internal(this._icon);
  IconData get icon => this._icon;

  static const SHARE = PopupMenuButtonChoices._internal(Icons.share);
  static const EDIT = PopupMenuButtonChoices._internal(Icons.edit);
  static const ADD_MEAL_PLAN =
      PopupMenuButtonChoices._internal(kMealPlannerIconData);
  static const DELETE = PopupMenuButtonChoices._internal(Icons.delete);
}

class RecipeScreen extends StatelessWidget {
  static final String id = 'recipe';

  @override
  Widget build(BuildContext context) {
    final recipe = ModalRoute.of(context)!.settings.arguments as RecipeEntity;

    RecipeViewModel baseModel = RecipeViewModel.of(recipe);
    return ChangeNotifierProvider<RecipeViewModel>(
      create: (BuildContext context) {
        return baseModel;
      },
      child: DefaultTabController(
        length: 4,
        child: Consumer<RecipeViewModel>(
          builder: (context, model, child) {
            var theme = Theme.of(context);
            var color = theme.brightness == Brightness.dark
                ? theme.colorScheme.primary
                : theme.colorScheme.onPrimary;

            return Scaffold(
              appBar: AppBar(
                title: Text(model.name),
                actions: <Widget>[
                  PopupMenuButton(
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          value: PopupMenuButtonChoices.SHARE,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(PopupMenuButtonChoices.SHARE.icon),
                              Text(AppLocalizations.of(context)!.share)
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: PopupMenuButtonChoices.EDIT,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(PopupMenuButtonChoices.EDIT.icon),
                              Text(AppLocalizations.of(context)!.edit)
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: PopupMenuButtonChoices.ADD_MEAL_PLAN,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(PopupMenuButtonChoices.ADD_MEAL_PLAN.icon),
                              Text(AppLocalizations.of(context)!
                                  .functionsMealPlanner)
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: PopupMenuButtonChoices.DELETE,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(PopupMenuButtonChoices.DELETE.icon),
                              Text(AppLocalizations.of(context)!.delete)
                            ],
                          ),
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
                          await Navigator.pushNamed(context, MealPlanScreen.id,
                              arguments: model.recipe);
                          break;
                        case PopupMenuButtonChoices.DELETE:
                          await showDialog(
                            context: context,
                            barrierDismissible: false, // user must tap button!
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: AlertDialogTitle(
                                    title:
                                        AppLocalizations.of(context)!.delete),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text(AppLocalizations.of(context)!
                                          .confirmDelete(model.name)),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  ElevatedButton(
                                    style: kRaisedGreyButtonStyle,
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!.cancel,
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: kRaisedRedButtonStyle,
                                    onPressed: () async {
                                      await sl
                                          .get<RecipeManager>()
                                          .deleteRecipe(model.recipe);

                                      Navigator.popUntil(context,
                                          ModalRoute.withName(HomeScreen.id));
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!.delete,
                                    ),
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
                  indicatorColor: color,
                  labelColor: color,
                  unselectedLabelColor: color,
                  tabs: [
                    Tab(
                      icon: FaIcon(kInfoIconData),
                    ),
                    Tab(
                      icon: FaIcon(kIngredientsIconData),
                    ),
                    Tab(
                      icon: FaIcon(kInstructionsIconData),
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
          title: Text(AppLocalizations.of(context)!.shareAs),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () async {
                var doc = await sl.get<PDFGenerator>().generatePDF([model]);
                sl.get<PDFExporter>().export(doc);
                Navigator.pop(context);
              },
              child: Text(
                AppLocalizations.of(context)!.pdf,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                sl
                    .get<RecipeFileExport>()
                    .exportRecipesFromEntity([model.recipe]);
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.json),
            ),
            ElevatedButton(
              onPressed: () {
                sl
                    .get<RecipeTextExporter>()
                    .exportRecipesAsText([model.recipe]);
                Navigator.pop(context);
              },
              child: Text(
                AppLocalizations.of(context)!.text,
              ),
            ),
          ],
        );
      },
    );
  }
}

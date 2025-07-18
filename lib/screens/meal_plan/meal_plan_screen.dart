import 'package:cookza/components/meal_plan_groups_drawer.dart';
import 'package:cookza/components/open_drawer_button.dart';
import 'package:cookza/constants.dart';
import 'package:cookza/model/entities/abstract/meal_plan_collection_entity.dart';
import 'package:cookza/model/entities/abstract/meal_plan_entity.dart';
import 'package:cookza/model/entities/abstract/recipe_entity.dart';
import 'package:cookza/model/entities/mutable/mutable_meal_plan.dart';
import 'package:cookza/screens/meal_plan/item_dialog.dart';
import 'package:cookza/screens/recipe_view/recipe_screen.dart';
import 'package:cookza/screens/shopping_list/shopping_list_dialog.dart';
import 'package:cookza/services/meal_plan_manager.dart';
import 'package:cookza/services/recipe/recipe_manager.dart';
import 'package:cookza/services/util/week_calculation.dart';
import 'package:cookza/viewmodel/meal_plan/meal_plan_item_dialog_model.dart';
import 'package:cookza/viewmodel/meal_plan/recipe_meal_plan_model.dart';
import 'package:cookza/viewmodel/recipe_selection_model.dart';
import 'package:cookza/screens/recipe_selection_screen.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/viewmodel/recipe_view/recipe_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cookza/l10n/app_localizations.dart';

class MealPlanScreen extends StatelessWidget {
  static const String id = 'mealPlan';

  const MealPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var recipe = ModalRoute.of(context)!.settings.arguments as RecipeEntity?;
    var currentGroup = sl.get<MealPlanManager>().currentCollection;

    return FutureBuilder<MealPlanCollectionEntity?>(
      future: currentGroup == null
          ? Future.value(null)
          : sl.get<MealPlanManager>().getCollectionByID(currentGroup),
      builder: (context, snapshot) {
        return Scaffold(
          drawer: const MealPlanGroupsDrawer(),
          appBar: AppBar(
            title: snapshot.data == null
                ? Text(AppLocalizations.of(context).functionsMealPlanner)
                : Text(snapshot.data!.name),
            actions: [
              IconButton(
                icon: const Icon(kShoppingListIconData),
                onPressed: () {
                  openShoppingListDialog(context);
                },
              ),
            ],
          ),
          body: Builder(
            builder: (context) {
              if (snapshot.data == null &&
                  snapshot.connectionState == ConnectionState.done) {
                return OpenDrawerButton(
                    AppLocalizations.of(context).mealPlanSelect);
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return FutureBuilder<MealPlanEntity?>(
                future: sl.get<MealPlanManager>().mealPlan,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasData) {
                    MealPlanViewModel mealPlanViewModel =
                        MealPlanViewModel.of(snapshot.data!);

                    if (recipe != null && recipe.id!.isNotEmpty) {
                      mealPlanViewModel.setRecipeForAddition(recipe);
                    }

                    final firstVisibleEntry = GlobalKey();

                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      Scrollable.ensureVisible(
                          firstVisibleEntry.currentContext!);
                    });

                    return SingleChildScrollView(
                      child: ChangeNotifierProvider<MealPlanViewModel>.value(
                        value: mealPlanViewModel,
                        child: Consumer<MealPlanViewModel>(
                          builder: (context, model, widget) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: _buildMainLayout(
                                  context, model, firstVisibleEntry),
                            );
                          },
                        ),
                      ),
                    );
                  }
                  return Container();
                },
              );
            },
          ),
        );
      },
    );
  }

  List<Widget> _buildMainLayout(BuildContext context, MealPlanViewModel model,
      GlobalKey firstVisibleWidget) {
    var tileColor = Theme.of(context).colorScheme.primary;

    List<Widget> tiles = [];
    int? previousWeek;
    final todaysWeek = weekNumberOf(DateTime.now());
    for (var i = 0; i < model.entries.length; i++) {
      var currentWeek = model.entries[i].week;
      if (currentWeek != previousWeek) {
        if (currentWeek == todaysWeek) {
          tiles.add(WeekNumber(currentWeek, tileColor));
        } else {
          tiles.add(WeekNumber(
            currentWeek,
            tileColor,
          ));
        }
        previousWeek = currentWeek;
      }

      final now = DateUtils.dateOnly(DateTime.now());
      var isEnabled = !DateUtils.dateOnly(model.entries[i].date).isBefore(now);
      var isToday = DateUtils.isSameDay(now, model.entries[i].date);
      var tile = _createTileForWeekDay(
          model, i, context, tileColor, isEnabled, isToday, firstVisibleWidget);
      tiles.add(tile);
    }
    return tiles;
  }

  Widget _createTileForWeekDay(
      MealPlanViewModel model,
      int i,
      BuildContext context,
      Color accentColor,
      bool isEnabled,
      bool isToday,
      GlobalKey firstVisibleWidget) {
    var body = DragTarget<MealDragModel>(
      builder: (context, accepted, rejected) {
        // set different color to highlight where a drop would take place
        var color = accepted.isNotEmpty ? accentColor : null;
        return Card(
          color: color,
          key: isToday ? firstVisibleWidget : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    WeekdayHeaderTitle(
                      entry: model.entries[i],
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: isEnabled
                          ? () async {
                              // if moved here by navigaton
                              if (model.addByNavigationRequired) {
                                model.addByNavigation(i);
                                return;
                              }

                              // else open selection screen or add a note
                              _showSelectAddModeDialog(context, model, i);
                            }
                          : null,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _createRecipeTiles(
                    model, i, context, accentColor, isEnabled),
              ),
            ],
          ),
        );
      },
      onWillAcceptWithDetails: (target) {
        return isEnabled;
      },
      onAcceptWithDetails: (drop) {
        model.moveRecipe(drop.data, i);
      },
      onLeave: (data) {},
    );

    return body;
  }

  List<Widget> _createRecipeTiles(MealPlanViewModel model, int i,
      BuildContext context, Color accentColor, bool isEnabled) {
    List<Widget> tiles = [];

    for (var entry in model.entries[i].recipes) {
      var tile = ChangeNotifierProvider.value(
        value: entry,
        builder: (context, _) {
          return Consumer<MealPlanRecipeModel>(
            builder: (context, recipeModel, _) {
              return ListTile(
                dense: true,
                title: Text(
                  recipeModel.name,
                  style: const TextStyle(fontSize: 14),
                ),
                onTap: () async {
                  if (recipeModel.id != null) {
                    final navigator = Navigator.of(context);
                    var recipeEntity = await sl
                        .get<RecipeManager>()
                        .getRecipeById([recipeModel.id!]);
                    if (recipeEntity.length == 1) {
                      await navigator.pushNamed(RecipeScreen.id,
                          arguments: recipeEntity.first);
                    }
                  }
                },
                subtitle: !recipeModel.isNote
                    ? Text(
                        '${recipeModel.servings.toString()} ${AppLocalizations.of(context).servings(recipeModel.servings!)}')
                    : null,
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: isEnabled
                      ? () async {
                          var mealPlanViewModel =
                              Provider.of<MealPlanViewModel>(context,
                                  listen: false);

                          var dialogResult = await showDialog(
                            context: context,
                            builder: (context) {
                              return MealPlanItemDialog(
                                  MealPlanItemDialogModel.forItem(recipeModel));
                            },
                          ) as MealPlanItemDialogModel?;

                          if (dialogResult != null) {
                            if (dialogResult.isDeleted) {
                              model.removeRecipe(
                                  recipeModel.entity
                                      as MutableMealPlanRecipeEntity,
                                  i);
                            } else if (dialogResult.hasChanged) {
                              mealPlanViewModel.recipeModelChanged(recipeModel);
                            }
                          }
                        }
                      : null,
                ),
              );
            },
          );
        },
      );

      var feedback = Transform.scale(
        scale: 2,
        child: Opacity(
          opacity: 0.9,
          child: ConstrainedBox(
            constraints: BoxConstraints.loose(
              const Size.fromWidth(200),
            ),
            child: Container(
              padding: const EdgeInsets.only(bottom: 100),
              child: Material(
                color: Colors.transparent,
                child: Transform.scale(
                  scale: 0.5,
                  child:
                      DragFeedbackTile(accentColor: accentColor, model: entry),
                ),
              ),
            ),
          ),
        ),
      );

      if (isEnabled) {
        var draggable = LongPressDraggable<MealDragModel>(
          dragAnchorStrategy: childDragAnchorStrategy,
          maxSimultaneousDrags: 1,
          feedback: feedback,
          childWhenDragging: Container(),
          data: MealDragModel(entry, i),
          child: tile,
        );
        tiles.add(draggable);
      } else {
        tiles.add(tile);
      }
    }

    return tiles;
  }

  void _showSelectAddModeDialog(
      BuildContext context, MealPlanViewModel model, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Builder(
          // builder is needed to get a new context for the Provider
          builder: (context) {
            return SimpleDialog(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () {
                          // close dialog
                          Navigator.pop(context);

                          // open note dialog
                          _showAddNoteDialog(context, model, index);
                        },
                        child:
                            Text(AppLocalizations.of(context).mealPlanAddNote),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () async {
                          final navigator = Navigator.of(context);
                          // fetch all recipes the app currently stores
                          var recipes =
                              await sl.get<RecipeManager>().getAllRecipes();

                          // create the view model with type reference ingredient
                          var selModel = RecipeSelectionModel.forAddMealPlan(
                              recipes
                                  .map((e) => RecipeViewModel.of(e))
                                  .toList());
                          // navigate to the selection screen
                          var result = await navigator.pushNamed(
                              RecipeSelectionScreen.id,
                              arguments: selModel) as RecipeEntity?;
                          if (result != null && result.id!.isNotEmpty) {
                            model.addRecipeFromEntity(index, result);
                          }

                          navigator.pop();
                        },
                        child: Text(
                            AppLocalizations.of(context).mealPlanAddRecipe),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddNoteDialog(
      BuildContext context, MealPlanViewModel model, int index) async {
    var dialogResult = await showDialog(
      context: context,
      builder: (context) {
        return MealPlanItemDialog(MealPlanItemDialogModel.createNote());
      },
    ) as MealPlanItemDialogModel?;

    if (dialogResult != null && !dialogResult.isDeleted) {
      model.addNote(index, dialogResult.name);
    }
  }
}

class WeekNumber extends StatelessWidget {
  final int week;
  final Color backgroundColor;
  const WeekNumber(this.week, this.backgroundColor, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Center(
        child: CircleAvatar(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.white,
          child: Text(
            week.toString(),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary),
          ),
        ),
      ),
    );
  }
}

class WeekdayHeaderTitle extends StatelessWidget {
  final MealPlanDateEntry entry;

  const WeekdayHeaderTitle({required this.entry, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      _getWeekDayHeaderText(context, entry),
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
  }

  String _getWeekDayHeaderText(BuildContext context, MealPlanDateEntry entry) {
    var locale = Localizations.localeOf(context);
    var day = DateFormat.EEEE(locale.toString()).format(entry.date);
    var date = DateFormat('d.MM.yyyy').format(entry.date);
    return '$day, $date';
  }
}

class DragFeedbackTile extends StatelessWidget {
  final Color accentColor;
  final MealPlanRecipeModel model;

  const DragFeedbackTile(
      {required this.accentColor, required this.model, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: accentColor,
      child: ListTile(
        title: Text(model.name),
        subtitle: model.isNote || model.servings == null
            ? null
            : Text(
                '${model.servings} ${AppLocalizations.of(context).servings(model.servings!)}'),
      ),
    );
  }
}

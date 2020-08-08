import 'package:cookly/components/meal_plan_groups_drawer.dart';
import 'package:cookly/components/round_icon_button.dart';
import 'package:cookly/constants.dart';
import 'package:cookly/localization/keys.dart';
import 'package:cookly/model/entities/abstract/meal_plan_entity.dart';
import 'package:cookly/model/entities/abstract/recipe_entity.dart';
import 'package:cookly/screens/recipe_view/recipe_screen.dart';
import 'package:cookly/screens/shopping_list/shopping_list_dialog.dart';
import 'package:cookly/services/meal_plan_manager.dart';
import 'package:cookly/services/recipe_manager.dart';
import 'package:cookly/viewmodel/meal_plan/recipe_meal_plan_model.dart';
import 'package:cookly/viewmodel/recipe_selection_model.dart';
import 'package:cookly/screens/recipe_selection_screen.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:cookly/viewmodel/recipe_view/recipe_view_model.dart';
import 'package:cookly/viewmodel/settings/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MealPlanScreen extends StatelessWidget {
  static final String id = 'mealPlan';

  @override
  Widget build(BuildContext context) {
    var _recipe = ModalRoute.of(context).settings.arguments as RecipeEntity;
    var currentGroup = sl.get<MealPlanManager>().currentCollection;

    return FutureBuilder(
      future: currentGroup == null
          ? Future.value(null)
          : sl.get<MealPlanManager>().getCollectionByID(currentGroup),
      builder: (context, snapshot) {
        return Scaffold(
          drawer: MealPlanGroupsDrawer(),
          appBar: AppBar(
            title: snapshot.data == null
                ? Text(translate(Keys.Functions_Mealplanner))
                : Text(snapshot.data.name),
            actions: [
              IconButton(
                icon: Icon(kShoppingListIconData),
                onPressed: () {
                  openShoppingListDialog(context);
                },
              ),
            ],
          ),
          body: Builder(
            builder: (context) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RaisedButton(
                            child: Text(translate(Keys.Ui_Mealplan_Select)),
                            onPressed: () => Scaffold.of(context).openDrawer(),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }

              return FutureBuilder(
                future: sl.get<MealPlanManager>().mealPlan,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    MealPlanEntity data = snapshot.data;
                    if (data.id == null || data.id.isEmpty) {
                      //
                    } else {}

                    MealPlanViewModel _model =
                        MealPlanViewModel.of(snapshot.data);

                    if (_recipe != null && _recipe.id.isNotEmpty) {
                      _model.setRecipeForAddition(_recipe);
                    }

                    return SingleChildScrollView(
                      child: ChangeNotifierProvider<MealPlanViewModel>.value(
                        value: _model,
                        child: Consumer<MealPlanViewModel>(
                          builder: (context, model, widget) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: _buildMainLayout(context, model),
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

  List<Widget> _buildMainLayout(BuildContext context, MealPlanViewModel model) {
    var tileColor = Provider.of<ThemeModel>(context).tileAccentColor;

    List<Widget> tiles = [];
    int previousWeek;
    for (var i = 0; i < model.entries.length; i++) {
      var currentWeek = model.entries[i].week;
      if (currentWeek != previousWeek) {
        var weekTile = _createWeekTile(currentWeek, tileColor);
        tiles.add(weekTile);
        previousWeek = currentWeek;
      }

      var tile = _createTileForWeekDay(model, i, context, tileColor);
      tiles.add(tile);
    }
    return tiles;
  }

  Widget _createTileForWeekDay(
      MealPlanViewModel model, int i, BuildContext context, Color accentColor) {
    var body = DragTarget<MealDragModel>(
      builder: (context, accepted, rejected) {
        // set different color to highlight where a drop would take place
        var color = accepted.isNotEmpty ? accentColor : null;
        return Card(
          color: color,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _getWeekDayHeaderText(context, model.entries[i]),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () async {
                        // if moved here by navigaton
                        if (model.addByNavigationRequired) {
                          model.addByNavigation(i);
                          return;
                        }

                        // else open selection screen or add a note
                        _showSelectAddModeDialog(context, model, i);
                      },
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _createRecipeTiles(model, i, context, accentColor),
              ),
            ],
          ),
        );
      },
      onWillAccept: (data) {
        // TODO: change color while dragging, drag over and leave
        return data is MealDragModel;
      },
      onAccept: (data) {
        model.moveRecipe(data, i);
      },
      onLeave: (data) {},
    );

    return body;
  }

  List<Widget> _createRecipeTiles(
      MealPlanViewModel model, int i, BuildContext context, Color accentColor) {
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
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () async {
                  if (recipeModel.id != null) {
                    var recipeEntity = await sl
                        .get<RecipeManager>()
                        .getRecipeById([recipeModel.id]);
                    if (recipeEntity.length == 1) {
                      Navigator.pushNamed(context, RecipeScreen.id,
                          arguments: recipeEntity.first);
                    }
                  }
                },
                subtitle: recipeModel.servings != null
                    ? Text(
                        '${recipeModel.servings.toString()} ${translate(Keys.Recipe_Servings)}')
                    : null,
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    var mealPlanViewModel =
                        Provider.of<MealPlanViewModel>(context, listen: false);

                    showDialog(
                      context: context,
                      builder: (context) {
                        var _count = recipeModel.servings;
                        return StatefulBuilder(builder: (context, setState) {
                          return SimpleDialog(
                            children: <Widget>[
                              SingleChildScrollView(
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      recipeModel.name,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Builder(
                                      builder: (context) {
                                        // if it's only a note, don't show the servings
                                        if (_count == null) {
                                          return Container();
                                        }

                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Text(translate(
                                                Keys.Recipe_Servings)),
                                            RoundIconButton(
                                              icon: FontAwesomeIcons.minus,
                                              onPress: () {
                                                if (_count > 1) {
                                                  setState(() {
                                                    _count--;
                                                  });
                                                }
                                              },
                                            ),
                                            Text(_count.toString()),
                                            RoundIconButton(
                                              icon: FontAwesomeIcons.plus,
                                              onPress: () {
                                                setState(() {
                                                  _count++;
                                                });
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        RaisedButton(
                                            child: Icon(Icons.check),
                                            color: Colors.green,
                                            onPressed: () {
                                              recipeModel.setServings(
                                                  context, _count);
                                              mealPlanViewModel
                                                  .recipeModelChanged(
                                                      recipeModel);
                                              Navigator.pop(context);
                                            }),
                                        RaisedButton(
                                            child: Icon(Icons.delete),
                                            color: Colors.red,
                                            onPressed: () {
                                              model.removeRecipe(
                                                  recipeModel.entity, i);

                                              Navigator.pop(context);
                                            }),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          );
                        });
                      },
                    );
                  },
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
              Size.fromWidth(200),
            ),
            child: Container(
              padding: EdgeInsets.only(bottom: 100),
              child: Material(
                color: Colors.transparent,
                child: Transform.scale(
                  scale: 0.5,
                  child: Card(
                    color: accentColor,
                    child: ListTile(
                      title: Text(entry.name),
                      subtitle: entry.isNote
                          ? null
                          : Text(
                              '${entry.servings.toString()} ${translate(Keys.Recipe_Servings)}'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      var draggable = LongPressDraggable<MealDragModel>(
          dragAnchor: DragAnchor.child,
          maxSimultaneousDrags: 1,
          // axis: Axis.vertical,
          child: tile,
          feedback: feedback,
          childWhenDragging: Container(),
          data: MealDragModel(entry, i));
      tiles.add(draggable);
    }

    return tiles;
  }

  _createWeekTile(int i, Color backgroundColor) {
    return ListTile(
      title: Center(
        child: CircleAvatar(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.white,
          child: Text(
            i.toString(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  String _getWeekDayHeaderText(BuildContext context, MealPlanDateEntry entry) {
    var locale = Localizations.localeOf(context);
    var day = DateFormat.EEEE(locale.toString()).format(entry.date);
    var date = DateFormat('d.MM.yyyy').format(entry.date);
    return '$day, $date';
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
              title: Text(translate(Keys.Ui_Mealplan_Choosemode)),
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Flexible(
                        flex: 1,
                        child: RaisedButton(
                          child: Text(translate(Keys.Ui_Mealplan_Addnote)),
                          onPressed: () {
                            // close dialog
                            Navigator.pop(context);

                            // open note dialog
                            _showAddNoteDialog(context, model, index);
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Flexible(
                        flex: 1,
                        child: RaisedButton(
                          child: Text(translate(Keys.Ui_Mealplan_Addrecipe)),
                          onPressed: () async {
                            // fetch all recipes the app currently stores
                            var recipes =
                                await sl.get<RecipeManager>().getAllRecipes();

                            // create the view model with type reference ingredient
                            var selModel = RecipeSelectionModel.forAddMealPlan(
                                recipes
                                    .map((e) => RecipeViewModel.of(e))
                                    .toList());
                            // navigate to the selection screen
                            var result = await Navigator.pushNamed(
                                context, RecipeSelectionScreen.id,
                                arguments: selModel) as RecipeEntity;
                            if (result != null && result.id.isNotEmpty) {
                              model.addRecipeFromEntity(index, result);
                            }

                            Navigator.pop(context);
                          },
                        ),
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
      BuildContext context, MealPlanViewModel model, int index) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        var controller = TextEditingController(text: '');

        return Builder(
          // builder is needed to get a new context for the Provider
          builder: (context) {
            return SimpleDialog(
              title: Text(translate(Keys.Ui_Mealplan_Addnote)),
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: controller,
                                maxLines: 1,
                                autofocus: true,
                                decoration: InputDecoration(hintText: 'Note'),
                              ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          RaisedButton(
                              child: Icon(Icons.save),
                              color: Colors.green,
                              onPressed: () async {
                                model.addNote(index, controller.text);
                                Navigator.pop(context);
                              }),
                          RaisedButton(
                              child: Icon(Icons.cancel),
                              color: Colors.red,
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

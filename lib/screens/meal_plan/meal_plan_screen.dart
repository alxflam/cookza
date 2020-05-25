import 'package:cookly/components/round_icon_button.dart';
import 'package:cookly/constants.dart';
import 'package:cookly/localization/keys.dart';
import 'package:cookly/model/view/recipe_meal_plan_model.dart';
import 'package:cookly/model/view/recipe_selection_model.dart';
import 'package:cookly/screens/recipe_selection_screen.dart';
import 'package:cookly/services/abstract/data_store.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class MealPlanScreen extends StatelessWidget {
  static final String id = 'mealPlan';

  @override
  Widget build(BuildContext context) {
    MealPlanViewModel _model =
        sl.get<DataStore>().appProfile.mealPlanModel(context);
    var _recipeId = ModalRoute.of(context).settings.arguments as String;
    if (_recipeId != null && _recipeId.isNotEmpty) {
      _model.setRecipeForAddition(_recipeId);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          translate(Keys.Functions_Mealplanner),
        ),
        actions: [
          IconButton(
            icon: Icon(kShoppingListIconData),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
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
      ),
    );
  }

  List<Widget> _buildMainLayout(BuildContext context, MealPlanViewModel model) {
    List<Widget> tiles = [];
    int previousWeek;
    for (var i = 0; i < model.entries.length; i++) {
      var currentWeek = model.entries[i].week;
      if (currentWeek != previousWeek) {
        var weekTile = _createWeekTile(currentWeek);
        tiles.add(weekTile);
        previousWeek = currentWeek;
      }

      var tile = _createTileForWeekDay(model, i, context);
      tiles.add(tile);
    }
    return tiles;
  }

  Widget _createTileForWeekDay(
      MealPlanViewModel model, int i, BuildContext context) {
    var body = DragTarget<MealDragModel>(
      builder: (context, accepted, rejected) {
        return Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      model.entries[i].header,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () async {
                        // if moved here by navigaton
                        if (model.addByNavigationRequired) {
                          model.addByNavigation(i);
                          return;
                        }
                        // else open selection screen
                        // fetch all recipes the app currently stores
                        var recipes = sl.get<DataStore>().appProfile.recipes;
                        // create the view model with type reference ingredient
                        var selModel = RecipeSelectionModel.forAddMealPlan(
                            recipes.toList());
                        // navigate to the selection screen
                        var result = await Navigator.pushNamed(
                            context, RecipeSelectionScreen.id,
                            arguments: selModel) as String;
                        if (result != null && result.isNotEmpty) {
                          model.addRecipe(i, result);
                        }
                      },
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _createRecipeTiles(model, i, context),
              ),
            ],
          ),
        );
      },
      onWillAccept: (data) {
        // TODO: change color
        return data is MealDragModel;
      },
      onAccept: (data) {
        // TODO: change color back
        model.moveRecipe(data, i);
      },
      onLeave: (data) {
        // TODO: change color back
      },
    );

    return body;
  }

  List<Widget> _createRecipeTiles(
      MealPlanViewModel model, int i, BuildContext context) {
    List<Widget> tiles = [];

    for (var entry in model.entries[i].recipes) {
      var tile = ChangeNotifierProvider.value(
        value: entry,
        builder: (context, _) {
          return Consumer<MealPlanRecipeModel>(
            builder: (context, recipeModel, _) {
              return ListTile(
                dense: true,
                title: Text(recipeModel.name),
                subtitle: Text(
                    '${recipeModel.servings.toString()} ${translate(Keys.Recipe_Servings)}'),
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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Text(translate(Keys.Recipe_Servings)),
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
                                                  recipeModel.id, i);

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
                    color: Colors.teal.shade300,
                    child: ListTile(
                      title: Text(entry.name),
                      subtitle: Text(
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

  _createWeekTile(int i) {
    return ListTile(
      title: Center(
        child: CircleAvatar(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          child: Text(
            i.toString(),
          ),
        ),
      ),
    );
  }
}

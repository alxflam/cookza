import 'package:cookly/constants.dart';
import 'package:cookly/localization/keys.dart';
import 'package:cookly/model/view/recipe_meal_plan_model.dart';
import 'package:cookly/model/view/recipe_selection_model.dart';
import 'package:cookly/screens/recipe_selection_screen.dart';
import 'package:cookly/services/abstract/data_store.dart';
import 'package:cookly/services/app_profile.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:cookly/services/util/week_calculation.dart';
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
    // Provider.of<AppProfile>(context, listen: false).mealPlanModel(context);
    var _recipeId = ModalRoute.of(context).settings.arguments as String;
    if (_recipeId != null && _recipeId.isNotEmpty) {
      _model.setRecipeForAddition(_recipeId);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(translate(Keys.Functions_Mealplanner)),
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
    var countRecipes = model.entries[i].recipes.length;

    for (var entry in model.entries[i].recipes) {
      var tile = ListTile(
        title: Text(entry.name),
        subtitle: Text(
            '${entry.servings.toString()} ${translate(Keys.Recipe_Servings)}'),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            model.removeRecipe(entry.id, i);
          },
        ),
      );

      var draggable = LongPressDraggable<MealDragModel>(
          maxSimultaneousDrags: 1,
          // axis: Axis.vertical,
          child: tile,
          feedback: Material(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 200),
              child: Expanded(child: tile),
            ),
          ),

          // Material(
          //   child: ClipRRect(
          //     borderRadius: BorderRadius.circular(25),
          //     child: ConstrainedBox(
          //       constraints: BoxConstraints.expand(),
          //       // child: ClipRRect(
          //       //   borderRadius: BorderRadius.circular(25),
          //       child: Container(
          //         decoration: BoxDecoration(
          //           color: Colors.cyan.withAlpha(55),
          //         ),
          //         child: Center(
          //           child: Padding(
          //             padding: EdgeInsets.all(10),
          //             child: Text(
          //               entry.name,
          //               style: TextStyle(fontWeight: FontWeight.bold),
          //             ),
          //           ),
          //         ),
          //         // ),
          //       ),
          //     ),
          //   ),
          // ),

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
    // return Row(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: <Widget>[
    //     Text(
    //       i.toString(),
    //     ),
    //   ],
    // );
  }
}

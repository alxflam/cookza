import 'package:cookly/localization/keys.dart';
import 'package:cookly/model/view/recipe_meal_plan_model.dart';
import 'package:cookly/model/view/recipe_selection_model.dart';
import 'package:cookly/screens/recipe_selection_screen.dart';
import 'package:cookly/services/abstract/data_store.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

class MealPlanScreen extends StatelessWidget {
  static final String id = 'mealPlan';

  @override
  Widget build(BuildContext context) {
    var _model = MealPlanViewModel(Localizations.localeOf(context));
    var _recipeId = ModalRoute.of(context).settings.arguments as String;
    if (_recipeId != null && _recipeId.isNotEmpty) {
      _model.setRecipeForAddition(_recipeId);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(translate(Keys.Functions_Mealplanner)),
      ),
      body: SingleChildScrollView(
        child: ChangeNotifierProvider.value(
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
    for (var i = 0; i < model.entries.length; i++) {
      var tile = _createTileForWeekDay(model, i, context);
      tiles.add(tile);
    }
    return tiles;
  }

  Widget _createTileForWeekDay(
      MealPlanViewModel model, int i, BuildContext context) {
    var body =
        DragTarget<MealDragModel>(builder: (context, accepted, rejected) {
      return Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Card(
              child: Text(
                model.entries[i].header,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _createRecipeTiles(model, i, context),
            ),
          ],
        ),
      );
    }, onWillAccept: (data) {
      return data is MealDragModel;
    }, onAccept: (data) {
      model.moveRecipe(data, i);
    });

    return body;
  }

  List<Widget> _createRecipeTiles(
      MealPlanViewModel model, int i, BuildContext context) {
    List<Widget> tiles = [];
    var countRecipes = model.entries[i].recipes.length;

    for (var entry in model.entries[i].recipes.entries) {
      var tile = ListTile(
        title: Text(entry.value),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            model.removeRecipe(entry.key, i);
          },
        ),
      );

      var draggable = Draggable<MealDragModel>(
          maxSimultaneousDrags: 1,
          axis: Axis.vertical,
          child: tile,
          feedback: Center(
            child: Material(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 200),
                child: Center(child: tile),
              ),
            ),
          ),
          childWhenDragging: Container(),
          data: MealDragModel(entry.key, i));
      tiles.add(draggable);
    }

    tiles.add(
      Center(
        child: IconButton(
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
            var selModel =
                RecipeSelectionModel.forAddMealPlan(recipes.toList());
            // navigate to the selection screen
            var result = await Navigator.pushNamed(
                    context, RecipeSelectionScreen.id, arguments: selModel)
                as String;
            if (result != null && result.isNotEmpty) {
              model.addRecipe(i, result);
            }
          },
        ),
      ),
    );

    return tiles;
  }
}

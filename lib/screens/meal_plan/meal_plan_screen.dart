import 'package:cookly/components/round_icon_button.dart';
import 'package:cookly/constants.dart';
import 'package:cookly/localization/keys.dart';
import 'package:cookly/model/entities/abstract/recipe_entity.dart';
import 'package:cookly/screens/shopping_list/shopping_list_overview_screen.dart';
import 'package:cookly/services/meal_plan_manager.dart';
import 'package:cookly/services/mobile/qr_scanner.dart';
import 'package:cookly/services/recipe_manager.dart';
import 'package:cookly/viewmodel/meal_plan/recipe_meal_plan_model.dart';
import 'package:cookly/viewmodel/recipe_selection_model.dart';
import 'package:cookly/screens/recipe_selection_screen.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:cookly/viewmodel/recipe_view/recipe_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PopupMenuButtonChoices {
  final _key;
  final _icon;
  const PopupMenuButtonChoices._internal(this._key, this._icon);
  toString() => translate(_key);
  IconData get icon => this._icon;

  static const SHOPPING_LIST = const PopupMenuButtonChoices._internal(
      Keys.Functions_Shoppinglist, kShoppingListIconData);
  static const ADD_USER =
      const PopupMenuButtonChoices._internal(Keys.Ui_Adduser, Icons.add);
}

class MealPlanScreen extends StatelessWidget {
  static final String id = 'mealPlan';

  @override
  Widget build(BuildContext context) {
    var _recipe = ModalRoute.of(context).settings.arguments as RecipeEntity;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          translate(Keys.Functions_Mealplanner),
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(PopupMenuButtonChoices.ADD_USER.icon),
                      Text(PopupMenuButtonChoices.ADD_USER.toString())
                    ],
                  ),
                  value: PopupMenuButtonChoices.ADD_USER,
                ),
                PopupMenuItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(PopupMenuButtonChoices.SHOPPING_LIST.icon),
                      Text(PopupMenuButtonChoices.SHOPPING_LIST.toString())
                    ],
                  ),
                  value: PopupMenuButtonChoices.SHOPPING_LIST,
                ),
              ];
            },
            onSelected: (value) {
              switch (value) {
                case PopupMenuButtonChoices.SHOPPING_LIST:
                  Navigator.pushReplacementNamed(
                      context, ShoppingListOverviewScreen.id);
                  break;
                case PopupMenuButtonChoices.ADD_USER:
                  _addUser(context);
                  break;
                default:
                  break;
              }
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: sl.get<MealPlanManager>().mealPlan,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            MealPlanViewModel _model = MealPlanViewModel.of(snapshot.data);

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
                        // else open selection screen
                        // fetch all recipes the app currently stores
                        var recipes =
                            await sl.get<RecipeManager>().getAllRecipes();

                        // create the view model with type reference ingredient
                        var selModel = RecipeSelectionModel.forAddMealPlan(
                            recipes.map((e) => RecipeViewModel.of(e)).toList());
                        // navigate to the selection screen
                        var result = await Navigator.pushNamed(
                            context, RecipeSelectionScreen.id,
                            arguments: selModel) as RecipeEntity;
                        if (result != null && result.id.isNotEmpty) {
                          model.addRecipeFromEntity(i, result);
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

  String _getWeekDayHeaderText(BuildContext context, MealPlanDateEntry entry) {
    var locale = Localizations.localeOf(context);
    var day = DateFormat.EEEE(locale.toString()).format(entry.date);
    var date = DateFormat('d.MM.yyyy').format(entry.date);
    return '$day, $date';
  }

  void _addUser(BuildContext context) async {
    // scan a qr code
    var scanResult = await sl.get<QRScanner>().scanQRCode();
    // TODO: add some alidation that the given string is a user id => check if the user exists?
    if (scanResult != null && scanResult.isNotEmpty) {
      // then add the user
      await sl.get<MealPlanManager>().addUser(scanResult, 'some User');
    }
  }
}

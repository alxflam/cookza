import 'package:cookly/localization/keys.dart';
import 'package:cookly/model/entities/abstract/meal_plan_collection_entity.dart';
import 'package:cookly/screens/shopping_list/shopping_list_detail_screen.dart';
import 'package:cookly/services/meal_plan_manager.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:cookly/viewmodel/meal_plan/recipe_meal_plan_model.dart';
import 'package:cookly/viewmodel/shopping_list/shopping_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ShoppingListOverviewScreen extends StatelessWidget {
  static final String id = 'shoppingLists';

  @override
  Widget build(BuildContext context) {
    // TODO: create shopping list view model
    // shopping list per: meal plan group and date range - any user of the meal group may access the shopping list
    // does not make sense to have different access rules
    ShoppingListOverviewModel _model = ShoppingListOverviewModel.of([]);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          translate(Keys.Functions_Shoppinglist),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              var _model = ShoppingListModel.empty();

              showDialog(
                context: context,
                builder: (context) {
                  return ChangeNotifierProvider.value(
                    value: _model,
                    child: Consumer<ShoppingListModel>(
                      builder: (context, model, _) {
                        return SimpleDialog(
                          children: <Widget>[
                            SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: [
                                      _getMealPlanGroupDropDown(context, model),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Text('Von: '),
                                      Text(model.getDateFrom()),
                                      IconButton(
                                        icon: FaIcon(FontAwesomeIcons.minus),
                                        onPressed: () {
                                          model.decrementDateFrom();
                                          // todo
                                        },
                                      ),
                                      IconButton(
                                        icon: FaIcon(FontAwesomeIcons.plus),
                                        onPressed: () {
                                          model.incrementDateFrom();
                                        },
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Text('Bis: '),
                                      Text(model.getDateEnd()),
                                      IconButton(
                                        icon: FaIcon(FontAwesomeIcons.minus),
                                        onPressed: () {
                                          model.decrementDateEnd();
                                        },
                                      ),
                                      IconButton(
                                        icon: FaIcon(FontAwesomeIcons.plus),
                                        onPressed: () {
                                          model.incrementDateEnd();
                                        },
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.all(10),
                                        child: RaisedButton(
                                          child: Icon(Icons.check),
                                          color: Colors.green,
                                          onPressed: () async {
                                            var entity = await sl
                                                .get<MealPlanManager>()
                                                .getMealPlanByCollectionID(
                                                    model.collection.id);
                                            MealPlanViewModel _mealPlan =
                                                MealPlanViewModel.of(entity);

                                            var recipes =
                                                _mealPlan.getRecipesForInterval(
                                                    model.dateFrom,
                                                    model.dateEnd);

                                            var newModel =
                                                ShoppingListModel.from(
                                                    model.dateFrom,
                                                    model.dateEnd,
                                                    model.collection,
                                                    recipes);

                                            Navigator.pushReplacementNamed(
                                                context,
                                                ShoppingListDetailScreen.id,
                                                arguments: newModel);
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: ChangeNotifierProvider<ShoppingListOverviewModel>.value(
        value: _model,
        child: _getBody(),
      ),
    );
  }

  Widget _getBody() {
    return Consumer<ShoppingListOverviewModel>(builder: (context, model, _) {
      if (model.getLists().isEmpty) {
        return Center(
          child: Card(
            child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Use the add button to create a new shopping list',
                  textAlign: TextAlign.center,
                )),
          ),
        );
      }
      return ListView.builder(
        itemCount: model.getLists().length,
        itemBuilder: (context, index) {
          var entry = model.getLists()[index];
          return ListTile(
            title: Text('${entry.getDateFrom()} - ${entry.getDateEnd()}'),
            onTap: () {
              Navigator.pushNamed(context, ShoppingListDetailScreen.id,
                  arguments: entry);
            },
          );
        },
      );
    });
  }

// TODO: dropdown for the meal plan collection - if there is only one, then set it fixed
// add possibility to manually add items
// sync with changes from meal plan by only storing the recipes and their servings
// and only store checked off ingredients, calculate everything else on the fly
  Widget _getMealPlanGroupDropDown(
      BuildContext context, ShoppingListModel model) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: FutureBuilder(
          future: sl.get<MealPlanManager>().collections,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data.isNotEmpty) {
              var collections = snapshot.data as List<MealPlanCollectionEntity>;
              List<DropdownMenuItem<MealPlanCollectionEntity>> items =
                  collections
                      .map((item) => DropdownMenuItem<MealPlanCollectionEntity>(
                          child: Text(item.name), value: item))
                      .toList();

              model.collection = collections.first;

              return DropdownButtonFormField<MealPlanCollectionEntity>(
                value: collections.first,
                items: items,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: '§Collection',
                ),
                onChanged: (MealPlanCollectionEntity value) {
                  model.collection = value;
                },
              );
            }

            return Container();
          },
        ),
      ),
    );
  }
}

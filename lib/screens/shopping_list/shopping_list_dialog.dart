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

openShoppingListDialog(BuildContext context) {
  var _model = ShoppingListModel.empty();

  showDialog(
      context: context,
      builder: (context) {
        return ChangeNotifierProvider.value(
          value: _model,
          child: Consumer<ShoppingListModel>(builder: (context, model, _) {
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text('${translate(Keys.Ui_Shoppinglist_From)}:'),
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text('${translate(Keys.Ui_Shoppinglist_Until)}:'),
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
                        crossAxisAlignment: CrossAxisAlignment.stretch,
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

                                var recipes = _mealPlan.getRecipesForInterval(
                                    model.dateFrom, model.dateEnd);

                                var newModel = ShoppingListModel.from(
                                    model.dateFrom,
                                    model.dateEnd,
                                    model.collection,
                                    recipes);

                                Navigator.pushReplacementNamed(
                                    context, ShoppingListDetailScreen.id,
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
          }),
        );
      });
}

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
            List<DropdownMenuItem<MealPlanCollectionEntity>> items = collections
                .map((item) => DropdownMenuItem<MealPlanCollectionEntity>(
                    child: Text(item.name), value: item))
                .toList();

            model.collection = collections.first;

            return DropdownButtonFormField<MealPlanCollectionEntity>(
              value: collections.first,
              items: items,
              decoration: InputDecoration(
                isDense: true,
                labelText: translate(Keys.Functions_Mealplanner),
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

import 'package:cookly/constants.dart';
import 'package:cookly/localization/keys.dart';
import 'package:cookly/model/entities/abstract/meal_plan_collection_entity.dart';
import 'package:cookly/screens/shopping_list/shopping_list_detail_screen.dart';
import 'package:cookly/services/meal_plan_manager.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:cookly/services/shopping_list_manager.dart';
import 'package:cookly/services/util/week_calculation.dart';
import 'package:cookly/viewmodel/meal_plan/recipe_meal_plan_model.dart';
import 'package:cookly/viewmodel/shopping_list/shopping_list_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

Future<void> openShoppingListDialog(BuildContext context) async {
  var model = ShoppingListModel.empty();
  var collections = await sl.get<MealPlanManager>().collections;
  DateTimeRange dateRange;

  if (collections.isEmpty) {
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('No meal plan available')));
    return;
  }

  if (collections.length == 1) {
    dateRange = await showDateRangePicker(
        context: context,
        firstDate: model.dateFrom,
        lastDate: model.lastDate,
        initialEntryMode: DatePickerEntryMode.calendar,
        initialDateRange:
            DateTimeRange(start: model.dateFrom, end: model.dateEnd));
    if (dateRange == null) {
      return;
    }
    model.dateEnd = dateRange.end;
    model.dateFrom = dateRange.start;
    model.collection = collections.first;
  } else {
    model = await _showMultipleGroupsDialog(context, collections, model);
  }

  // model is null if user cancelled multiple groups dialog
  if (model == null || model.collection == null) {
    return;
  }

  var existingPlans = await sl.get<ShoppingListManager>().shoppingListsAsList;
  var matchedPlan = existingPlans.firstWhere(
      (e) =>
          e.groupID == model.collection.id &&
          (e.dateFrom == model.dateFrom ||
              (e.dateFrom.isBefore(DateTime.now()) &&
                  isSameDay(model.dateFrom, DateTime.now()))) &&
          e.dateUntil == model.dateEnd,
      orElse: null);

  var entity = await sl
      .get<MealPlanManager>()
      .getMealPlanByCollectionID(model.collection.id);
  MealPlanViewModel _mealPlan = MealPlanViewModel.of(entity);

  var recipes = _mealPlan.getRecipesForInterval(model.dateFrom, model.dateEnd);

  var newModel = ShoppingListModel.from(
      model.dateFrom, model.dateEnd, model.collection, recipes);

  Navigator.pushReplacementNamed(context, ShoppingListDetailScreen.id,
      arguments: newModel);
}

Future<ShoppingListModel> _showMultipleGroupsDialog(BuildContext context,
    List<MealPlanCollectionEntity> collections, ShoppingListModel model) async {
  return await showDialog(
      context: context,
      builder: (context) {
        return ChangeNotifierProvider.value(
          value: model,
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
                          Padding(
                            padding: EdgeInsets.all(18),
                            child: Column(
                              children: [
                                Text(formatDate(model.dateFrom)),
                                Text(' - '),
                                Text(formatDate(model.dateEnd)),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: FaIcon(FontAwesomeIcons.edit),
                            onPressed: () async {
                              var dateRange = await showDateRangePicker(
                                  context: context,
                                  firstDate: model.dateFrom,
                                  lastDate: model.lastDate,
                                  initialEntryMode:
                                      DatePickerEntryMode.calendar,
                                  initialDateRange: DateTimeRange(
                                      start: model.dateFrom,
                                      end: model.dateEnd));

                              model.dateEnd = dateRange.end;
                              model.dateFrom = dateRange.start;
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
                                Navigator.pop(context, model);
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

String formatDate(DateTime dateFrom) {
  var day = DateFormat.E('de').format(dateFrom);
  var date = kDateFormatter.format(dateFrom);
  return day + ', ' + date;
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

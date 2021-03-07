import 'package:cookza/constants.dart';
import 'package:cookza/model/entities/abstract/meal_plan_collection_entity.dart';
import 'package:cookza/model/entities/mutable/mutable_shopping_list.dart';
import 'package:cookza/screens/shopping_list/shopping_list_detail_screen.dart';
import 'package:cookza/services/meal_plan_manager.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/services/shopping_list/shopping_list_manager.dart';
import 'package:cookza/services/util/week_calculation.dart';
import 'package:cookza/viewmodel/shopping_list/shopping_list_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

Future<void> openShoppingListDialog(BuildContext context) async {
  ShoppingListModel model;

  var collections = await sl.get<MealPlanManager>().collections;

  if (collections.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).noMealPlan)));
    return;
  }

  if (collections.length == 1) {
    model = ShoppingListModel.empty(groupID: collections.first.id);
    var dateRange = await showDateRangePicker(
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
    model.groupID = collections.first.id;
  } else {
    model = ShoppingListModel.empty();
    model = await _showMultipleGroupsDialog(context, collections, model);
  }

  // model is null if user cancelled multiple groups dialog
  if (model == null || model.groupID == null) {
    return;
  }

  var existingPlans = await sl.get<ShoppingListManager>().shoppingListsAsList;
  // TODO: refactor logic and provide tests
  var matchedList = existingPlans.isEmpty
      ? null
      : existingPlans.firstWhere(
          (e) =>
              e.groupID == model.groupID &&
              (isSameDay(model.dateFrom, e.dateFrom) ||
                  (e.dateFrom.isBefore(DateTime.now()) &&
                      isSameDay(model.dateFrom, DateTime.now()))) &&
              e.dateUntil == model.dateEnd,
          orElse: () => null);

  var listEntity = matchedList ??
      MutableShoppingList.ofValues(
          model.dateFrom, model.dateEnd, model.groupID, []);

  var newModel = ShoppingListModel.from(listEntity);

  await Navigator.pushReplacementNamed(context, ShoppingListDetailScreen.id,
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
                                Text(formatDate(model.dateFrom, context)),
                                Text(' - '),
                                Text(formatDate(model.dateEnd, context)),
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
                            child: ElevatedButton(
                              style: kRaisedGreenButtonStyle,
                              child: Icon(Icons.check),
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

String formatDate(DateTime dateFrom, BuildContext context) {
  var locale = Localizations.localeOf(context);
  var day = DateFormat.E(locale.toLanguageTag()).format(dateFrom);
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

            model.groupID = collections.first.id;

            return DropdownButtonFormField<MealPlanCollectionEntity>(
              value: collections.first,
              items: items,
              decoration: InputDecoration(
                isDense: true,
                labelText: AppLocalizations.of(context).functionsMealPlanner,
              ),
              onChanged: (MealPlanCollectionEntity value) {
                model.groupID = value.id;
              },
            );
          }

          return Container();
        },
      ),
    ),
  );
}

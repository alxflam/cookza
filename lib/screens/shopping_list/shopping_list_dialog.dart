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
import 'package:collection/collection.dart';

Future<void> openShoppingListDialog(BuildContext context) async {
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  final localizations = AppLocalizations.of(context);
  final navigator = Navigator.of(context);

  var collections = await sl.get<MealPlanManager>().collections;

  if (collections.isEmpty) {
    scaffoldMessenger
        .showSnackBar(SnackBar(content: Text(localizations.noMealPlan)));
    return;
  }

  ShoppingListModel? model;
  if (collections.length == 1) {
    model = ShoppingListModel.empty(groupID: collections.first.id!);
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
    model.updateDateRange(dateRange.start, dateRange.end);
    model.groupID = collections.first.id!;
  } else {
    model = ShoppingListModel.empty();
    model = await _showMultipleGroupsDialog(context, collections, model);
  }

  // model is null if user cancelled multiple groups dialog
  if (model == null || model.groupID.isEmpty) {
    return;
  }

  var existingPlans = await sl.get<ShoppingListManager>().shoppingListsAsList;
  var matchedList = existingPlans.firstWhereOrNull((e) =>
      e.groupID == model!.groupID &&
      (isSameDay(model.dateFrom, e.dateFrom) ||
          (e.dateFrom.isBefore(DateTime.now()) &&
              isSameDay(model.dateFrom, DateTime.now()))) &&
      isSameDay(e.dateUntil, model.dateEnd));

  var listEntity = matchedList ??
      MutableShoppingList.ofValues(
          model.dateFrom, model.dateEnd, model.groupID, []);

  var newModel = ShoppingListModel.from(listEntity);

  await navigator.pushReplacementNamed(ShoppingListDetailScreen.id,
      arguments: newModel);
}

Future<ShoppingListModel>? _showMultipleGroupsDialog(BuildContext context,
    List<MealPlanCollectionEntity> collections, ShoppingListModel model) async {
  return await showDialog(
      context: context,
      builder: (context) {
        return ChangeNotifierProvider.value(
          value: model,
          child: Consumer<ShoppingListModel>(builder: (context, model, _) {
            return MultipeGroupSelectionDialog(model);
          }),
        );
      });
}

class MultipeGroupSelectionDialog extends StatelessWidget {
  final ShoppingListModel model;

  const MultipeGroupSelectionDialog(this.model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      children: [
                        Text(formatDate(model.dateFrom, context)),
                        const Text(' - '),
                        Text(formatDate(model.dateEnd, context)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.penToSquare),
                    onPressed: () async {
                      var dateRange = await showDateRangePicker(
                          context: context,
                          firstDate: model.dateFrom,
                          lastDate: model.lastDate,
                          initialEntryMode: DatePickerEntryMode.calendar,
                          initialDateRange: DateTimeRange(
                              start: model.dateFrom, end: model.dateEnd));
                      if (dateRange != null) {
                        model.updateDateRange(dateRange.start, dateRange.end);
                      }
                    },
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      style: kRaisedGreenButtonStyle,
                      onPressed: () async {
                        Navigator.pop(context, model);
                      },
                      child: const Icon(Icons.check),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}

String formatDate(DateTime dateFrom, BuildContext context) {
  var locale = Localizations.localeOf(context);
  var day = DateFormat.E(locale.toLanguageTag()).format(dateFrom);
  var date = kDateFormatter.format(dateFrom);
  return '$day , $date';
}

Widget _getMealPlanGroupDropDown(
    BuildContext context, ShoppingListModel model) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: FutureBuilder<List<MealPlanCollectionEntity>>(
        future: sl.get<MealPlanManager>().collections,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            var collections = snapshot.data as List<MealPlanCollectionEntity>;
            List<DropdownMenuItem<MealPlanCollectionEntity>> items = collections
                .map((item) => DropdownMenuItem<MealPlanCollectionEntity>(
                    value: item, child: Text(item.name)))
                .toList();

            model.groupID = collections.first.id!;

            return DropdownButtonFormField<MealPlanCollectionEntity>(
              value: collections.first,
              items: items,
              decoration: InputDecoration(
                isDense: true,
                labelText: AppLocalizations.of(context).functionsMealPlanner,
              ),
              onChanged: (MealPlanCollectionEntity? value) {
                model.groupID = value!.id!;
              },
            );
          }

          return Container();
        },
      ),
    ),
  );
}

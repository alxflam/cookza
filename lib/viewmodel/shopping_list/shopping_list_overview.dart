import 'package:cookza/model/entities/abstract/meal_plan_collection_entity.dart';
import 'package:cookza/model/entities/abstract/shopping_list_entity.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/services/meal_plan_manager.dart';
import 'package:cookza/services/shopping_list/shopping_list_manager.dart';
import 'package:flutter/material.dart';

class ShoppingListOverviewModel extends ChangeNotifier {
  List<MealPlanCollectionEntity> _mealPlans;

  void navigatedBack() {
    // update view just in case some data changed
    // TODO: let the details view return a flag whether something changed and only then update the view
    notifyListeners();
  }

  Future<List<ShoppingListEntity>> getLists() async {
    var lists = await sl.get<ShoppingListManager>().shoppingListsAsList;
    this._mealPlans = await sl.get<MealPlanManager>().collections;

    return lists
        .where(
            (e) => e.dateUntil.isAfter(DateTime.now().add(Duration(days: 1))))
        .toList();
  }

  String getMealPlanName(String id) {
    var entry =
        this._mealPlans.firstWhere((e) => e.id == id, orElse: () => null);
    return entry != null ? entry.name : 'unknown';
  }
}

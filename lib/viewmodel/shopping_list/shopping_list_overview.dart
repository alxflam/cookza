import 'package:cookza/model/entities/abstract/meal_plan_collection_entity.dart';
import 'package:cookza/model/entities/abstract/shopping_list_entity.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/services/meal_plan_manager.dart';
import 'package:cookza/services/shopping_list/shopping_list_manager.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class ShoppingListOverviewModel extends ChangeNotifier {
  late List<MealPlanCollectionEntity> _mealPlans;

  void navigatedBack() {
    // update view just in case some data changed
    notifyListeners();
  }

  Future<List<ShoppingListEntity>> getLists() async {
    var lists = await sl.get<ShoppingListManager>().shoppingListsAsList;
    this._mealPlans = await sl.get<MealPlanManager>().collections;

    final yesterday =
        DateUtils.dateOnly(DateTime.now()).subtract(const Duration(days: 1));
    return lists.where((e) => e.dateUntil.isAfter(yesterday)).toList();
  }

  String getMealPlanName(String id) {
    var entry = this._mealPlans.firstWhereOrNull((e) => e.id == id);
    return entry != null ? entry.name : 'unknown';
  }

  Future<void> deleteList(ShoppingListEntity entry) async {
    var result = await sl.get<ShoppingListManager>().delete(entry);
    notifyListeners();
    return result;
  }
}

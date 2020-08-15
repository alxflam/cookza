import 'package:cookly/model/entities/abstract/shopping_list_entity.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:cookly/services/shopping_list_manager.dart';
import 'package:flutter/material.dart';

class ShoppingListOverviewModel extends ChangeNotifier {
  Future<List<ShoppingListEntity>> getLists() {
    return sl.get<ShoppingListManager>().shoppingListsAsList;
  }
}

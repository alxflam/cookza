import 'package:cookza/model/entities/abstract/shopping_list_entity.dart';
import 'package:cookza/services/firebase_provider.dart';
import 'package:cookza/services/flutter/service_locator.dart';

abstract class ShoppingListManager {
  Future<List<ShoppingListEntity>> get shoppingListsAsList;
  Stream<List<ShoppingListEntity>> get shoppingLists;

  Future<void> createOrUpdate(ShoppingListEntity entity);
}

class ShoppingListManagerImpl implements ShoppingListManager {
  @override
  Future<void> createOrUpdate(ShoppingListEntity entity) {
    return sl.get<FirebaseProvider>().createOrUpdateShoppingList(entity);
  }

  @override
  Future<List<ShoppingListEntity>> get shoppingListsAsList {
    return sl.get<FirebaseProvider>().shoppingListsAsList;
  }

  @override
  Stream<List<ShoppingListEntity>> get shoppingLists {
    return sl.get<FirebaseProvider>().shoppingListsAsStream;
  }
}

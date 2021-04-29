import 'package:cookza/model/entities/abstract/shopping_list_entity.dart';
import 'package:cookza/services/firebase_provider.dart';
import 'package:cookza/services/flutter/service_locator.dart';

abstract class ShoppingListManager {
  Future<List<ShoppingListEntity>> get shoppingListsAsList;
  Future<ShoppingListEntity> createOrUpdate(ShoppingListEntity entity);
  Future<void> delete(ShoppingListEntity entity);
}

class ShoppingListManagerImpl implements ShoppingListManager {
  @override
  Future<ShoppingListEntity> createOrUpdate(ShoppingListEntity entity) {
    return sl.get<FirebaseProvider>().createOrUpdateShoppingList(entity);
  }

  @override
  Future<List<ShoppingListEntity>> get shoppingListsAsList {
    return sl.get<FirebaseProvider>().shoppingListsAsList;
  }

  @override
  Future<void> delete(ShoppingListEntity entity) {
    return sl.get<FirebaseProvider>().deleteShoppingList(entity);
  }
}

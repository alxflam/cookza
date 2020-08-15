import 'package:cookly/model/entities/abstract/shopping_list_entity.dart';
import 'package:cookly/services/firebase_provider.dart';
import 'package:cookly/services/service_locator.dart';

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

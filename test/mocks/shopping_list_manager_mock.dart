import 'package:cookly/model/entities/abstract/shopping_list_entity.dart';
import 'package:cookly/services/shopping_list/shopping_list_manager.dart';
import 'package:mockito/mockito.dart';

class ShoppingListManagerMock extends Mock implements ShoppingListManager {
  Map<String, ShoppingListEntity> _entities = {};

  void reset() {
    this._entities.clear();
  }

  @override
  Future<List<ShoppingListEntity>> get shoppingListsAsList {
    return Future.value(this._entities.values.toList());
  }

  @override
  Stream<List<ShoppingListEntity>> get shoppingLists {
    Stream.fromFuture(Future.value(this._entities.values.toList()));
  }

  @override
  Future<void> createOrUpdate(ShoppingListEntity entity) {
    if (this._entities.containsKey(entity.id)) {
      this._entities.update(entity.id, (value) => entity);
    } else {
      this._entities.putIfAbsent(entity.id, () => entity);
    }
  }
}

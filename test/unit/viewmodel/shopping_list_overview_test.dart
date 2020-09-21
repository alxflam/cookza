import 'package:cookly/model/entities/mutable/mutable_shopping_list.dart';
import 'package:cookly/services/shopping_list_manager.dart';
import 'package:cookly/viewmodel/shopping_list/shopping_list_overview.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';

class ShoppingListManagerMock extends Mock implements ShoppingListManager {}

void main() {
  var mock = ShoppingListManagerMock();

  setUpAll(() {
    GetIt.I.registerSingleton<ShoppingListManager>(mock);
  });

  test('Get persisted lists - do not show data from the past', () async {
    var cut = ShoppingListOverviewModel();
    var now = DateTime.now();
    var entity = MutableShoppingList.newList('1234',
        now.subtract(Duration(days: 10)), now.subtract(Duration(days: 1)));
    when(mock.shoppingListsAsList)
        .thenAnswer((realInvocation) => Future.value([entity]));
    var lists = await cut.getLists();
    expect(lists.isEmpty, true);
  });

  test('Get persisted lists - show current data', () async {
    var cut = ShoppingListOverviewModel();
    var now = DateTime.now();
    var entity =
        MutableShoppingList.newList('1234', now, now.add(Duration(days: 6)));
    when(mock.shoppingListsAsList)
        .thenAnswer((realInvocation) => Future.value([entity]));
    var lists = await cut.getLists();
    expect(lists.length, 1);
  });
}

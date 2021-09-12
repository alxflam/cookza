import 'package:cookza/model/entities/mutable/mutable_shopping_list.dart';
import 'package:cookza/services/meal_plan_manager.dart';
import 'package:cookza/services/shopping_list/shopping_list_manager.dart';
import 'package:cookza/viewmodel/shopping_list/shopping_list_overview.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/meal_plan_manager_mock.dart';
import '../../mocks/shared_mocks.mocks.dart';

void main() {
  var mock = MockShoppingListManager();

  setUpAll(() {
    GetIt.I.registerSingleton<ShoppingListManager>(mock);
    GetIt.I.registerSingleton<MealPlanManager>(MealPlanManagerMock());
  });

  test('Get persisted lists - do not show data from the past', () async {
    var cut = ShoppingListOverviewModel();
    var now = DateTime.now();
    var entity = MutableShoppingList.newList(
        '1234',
        now.subtract(const Duration(days: 10)),
        now.subtract(const Duration(days: 1)));
    when(mock.shoppingListsAsList)
        .thenAnswer((realInvocation) => Future.value([entity]));
    var lists = await cut.getLists();
    expect(lists.isEmpty, true);
  });

  test('Get persisted lists - show current data', () async {
    var cut = ShoppingListOverviewModel();
    var now = DateTime.now();
    var entity = MutableShoppingList.newList(
        '1234', now, now.add(const Duration(days: 6)));
    when(mock.shoppingListsAsList)
        .thenAnswer((realInvocation) => Future.value([entity]));
    var lists = await cut.getLists();
    expect(lists.length, 1);
  });
}

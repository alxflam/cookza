import 'package:cookza/model/entities/mutable/mutable_ingredient_note.dart';
import 'package:cookza/model/entities/mutable/mutable_shopping_list.dart';
import 'package:cookza/model/entities/mutable/mutable_shopping_list_item.dart';
import 'package:cookza/services/meal_plan_manager.dart';
import 'package:cookza/services/shopping_list/shopping_list_manager.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils/firebase.dart';

void main() {
  setUp(() async {
    await mockFirestore();
  });

  test('Save shopping list', () async {
    var cut = ShoppingListManagerImpl();
    var mealPlanManager = MealPlanManagerFirebase();

    var group = await mealPlanManager.createCollection('Test');

    var retrievedLists = await cut.shoppingListsAsList;
    expect(retrievedLists, isEmpty);

    var item = MutableShoppingListItem.ofIngredientNote(
        MutableIngredientNote.empty()..name = 'Test', false, true);
    var list = MutableShoppingList.ofValues(DateTime.now(),
        DateTime.now().add(const Duration(days: 2)), group.id!, [item]);
    var createdList = await cut.createOrUpdate(list);
    expect(createdList, isNotNull);

    retrievedLists = await cut.shoppingListsAsList;
    expect(retrievedLists, isNotEmpty);
  });

  test('Update shopping list', () async {
    var cut = ShoppingListManagerImpl();
    var mealPlanManager = MealPlanManagerFirebase();

    var group = await mealPlanManager.createCollection('Test');

    var retrievedLists = await cut.shoppingListsAsList;
    expect(retrievedLists, isEmpty);

    var cheese = MutableShoppingListItem.ofIngredientNote(
        MutableIngredientNote.empty()..name = 'Cheese', false, true);

    var list = MutableShoppingList.ofValues(DateTime.now(),
        DateTime.now().add(const Duration(days: 2)), group.id!, [cheese]);
    var createdList = await cut.createOrUpdate(list);
    expect(createdList, isNotNull);
    expect(createdList.items.length, 1);

    retrievedLists = await cut.shoppingListsAsList;
    expect(retrievedLists, isNotEmpty);
    expect(retrievedLists.first.items.length, 1);

    var onion = MutableShoppingListItem.ofIngredientNote(
        MutableIngredientNote.empty()..name = 'Onion', false, true);

    list.addItem(onion);
    list.id = createdList.id!;

    createdList = await cut.createOrUpdate(list);
    expect(createdList.items.length, 2);
    retrievedLists = await cut.shoppingListsAsList;
    expect(retrievedLists.first.items.length, 2);
  });

  test('Get lists', () async {
    var cut = ShoppingListManagerImpl();
    var mealPlanManager = MealPlanManagerFirebase();

    var group = await mealPlanManager.createCollection('Test');
    var cheese = MutableShoppingListItem.ofIngredientNote(
        MutableIngredientNote.empty()..name = 'Cheese', false, true);

    var list = MutableShoppingList.ofValues(DateTime.now(),
        DateTime.now().add(const Duration(days: 2)), group.id!, [cheese]);
    var createdList = await cut.createOrUpdate(list);
    expect(createdList, isNotNull);
    expect(createdList.items.length, 1);

    var lists = await cut.shoppingListsAsList;
    expect(lists.length, 1);
  });

  test('Delete shopping list', () async {
    var cut = ShoppingListManagerImpl();
    var mealPlanManager = MealPlanManagerFirebase();

    var group = await mealPlanManager.createCollection('Test');

    var retrievedLists = await cut.shoppingListsAsList;
    expect(retrievedLists, isEmpty);

    var cheese = MutableShoppingListItem.ofIngredientNote(
        MutableIngredientNote.empty()..name = 'Cheese', false, true);

    var list = MutableShoppingList.ofValues(DateTime.now(),
        DateTime.now().add(const Duration(days: 2)), group.id!, [cheese]);
    var createdList = await cut.createOrUpdate(list);
    expect(createdList, isNotNull);
    expect(createdList.items.length, 1);

    await cut.delete(createdList);
    expect(await cut.shoppingListsAsList, isEmpty);
  });
}

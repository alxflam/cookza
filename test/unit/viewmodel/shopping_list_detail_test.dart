import 'package:cookly/model/entities/mutable/mutable_ingredient_note.dart';
import 'package:cookly/model/entities/mutable/mutable_shopping_list_item.dart';
import 'package:cookly/services/meal_plan_manager.dart';
import 'package:cookly/services/shared_preferences_provider.dart';
import 'package:cookly/services/shopping_list/shopping_list_items_generator.dart';
import 'package:cookly/services/shopping_list/shopping_list_manager.dart';
import 'package:cookly/services/unit_of_measure.dart';
import 'package:cookly/viewmodel/recipe_edit/recipe_ingredient_model.dart';
import 'package:cookly/viewmodel/shopping_list/shopping_list_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../mocks/meal_plan_manager_mock.dart';
import '../../mocks/shopping_list_manager_mock.dart';

class ShoppingListItemsGeneratorMock extends Mock
    implements ShoppingListItemsGenerator {}

void main() {
  var mock = ShoppingListManagerMock();
  var itemsGenMock = ShoppingListItemsGeneratorMock();

  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
    GetIt.I.registerSingletonAsync<SharedPreferencesProvider>(
        () => SharedPreferencesProviderImpl().init());
    GetIt.I.registerSingleton<ShoppingListManager>(mock);
    GetIt.I.registerSingleton<UnitOfMeasureProvider>(StaticUnitOfMeasure());
    GetIt.I.registerSingleton<ShoppingListItemsGenerator>(itemsGenMock);
    GetIt.I.registerSingleton<MealPlanManager>(MealPlanManagerMock());
  });

  test('Add custom item and set bought', () async {
    var cut = ShoppingListModel.empty();
    var item = MutableIngredientNote.empty();
    item.name = 'Something important';
    cut.addCustomItem(item);
    var items = await cut.getItems();
    expect(items.length, 1);
    expect(items.first.isCustomItem, true);
    expect(items.first.isNoLongerNeeded, false);

    items.first.noLongerNeeded = true;
    expect(items.first.isNoLongerNeeded, true);
  });

  test('Item to ingredient note', () async {
    var cut = ShoppingListModel.empty();
    var item = MutableIngredientNote.empty();
    item.name = 'Something important';
    cut.addCustomItem(item);
    var items = await cut.getItems();
    expect(items.length, 1);

    var actual = items.first.toIngredientNoteEntity();
    expect(actual.ingredient.name, 'Something important');
  });

  test('Update item from ingredient note', () async {
    var cut = ShoppingListModel.empty();
    var item = MutableIngredientNote.empty();
    item.name = 'Something important';
    cut.addCustomItem(item);
    var items = await cut.getItems();
    expect(items.length, 1);

    var updateItem = RecipeIngredientModel.empty(false);
    updateItem.name = 'Whatever';
    items.first.updateFrom(updateItem);
    expect(items.first.name, 'Whatever');
  });

  test('Remove custom item', () async {
    List<MutableShoppingListItem> mockedValue = [];
    when(itemsGenMock.generateItems(any))
        .thenAnswer((_) async => Future.value(mockedValue));

    var cut = ShoppingListModel.empty();
    var item = MutableIngredientNote.empty();
    item.name = 'Something important';
    cut.addCustomItem(item);

    var items = await cut.getItems();
    expect(items.length, 1);

    cut.removeItem(0, items.first);
    items = await cut.getItems();
    expect(items.length, 0);
  });

  test('Reorder items - swap two items', () async {
    var cut = ShoppingListModel.empty();
    var item = MutableIngredientNote.empty();
    item.name = 'Something important';
    cut.addCustomItem(item);

    var boughtItem = MutableIngredientNote.empty();
    boughtItem.name = 'Something else';
    cut.addCustomItem(boughtItem);

    var items = await cut.getItems();
    expect(items.first.name, 'Something important');
    expect(items.last.name, 'Something else');

    cut.reorder(1, 0);

    items = await cut.getItems();
    expect(items.first.name, 'Something else');
    expect(items.last.name, 'Something important');
  });

  test('Reorder items - middle to the top', () async {
    var cut = ShoppingListModel.empty();
    var first = MutableIngredientNote.empty();
    first.name = 'First';
    cut.addCustomItem(first);

    var second = MutableIngredientNote.empty();
    second.name = 'Second';
    cut.addCustomItem(second);

    var third = MutableIngredientNote.empty();
    third.name = 'Third';
    cut.addCustomItem(third);

    var fourth = MutableIngredientNote.empty();
    fourth.name = 'Fourth';
    cut.addCustomItem(fourth);

    var items = await cut.getItems();
    expect(items.first.name, 'First');
    expect(items.last.name, 'Fourth');

    cut.reorder(0, 2);

    items = await cut.getItems();
    expect(items.first.name, 'Third');
    expect(items.last.name, 'Fourth');
  });

  test('Reorder items - first to last', () async {
    var cut = ShoppingListModel.empty();
    var first = MutableIngredientNote.empty();
    first.name = 'First';
    cut.addCustomItem(first);

    var second = MutableIngredientNote.empty();
    second.name = 'Second';
    cut.addCustomItem(second);

    var third = MutableIngredientNote.empty();
    third.name = 'Third';
    cut.addCustomItem(third);

    var fourth = MutableIngredientNote.empty();
    fourth.name = 'Fourth';
    cut.addCustomItem(fourth);

    var items = await cut.getItems();
    expect(items.first.name, 'First');
    expect(items.last.name, 'Fourth');

    cut.reorder(3, 0);

    items = await cut.getItems();
    expect(items.first.name, 'Second');
    expect(items.last.name, 'First');
  });

  test('Sort items - bought items appear at the end', () async {
    var cut = ShoppingListModel.empty();
    var item = MutableIngredientNote.empty();
    item.name = 'Something important';
    cut.addCustomItem(item);

    var boughtItem = MutableIngredientNote.empty();
    boughtItem.name = 'Already bought';
    cut.addCustomItem(boughtItem);

    var items = await cut.getItems();
    items.first.noLongerNeeded = true;

    items = await cut.getItems();
    expect(items.first.isNoLongerNeeded, false);
    expect(items.last.isNoLongerNeeded, true);
  });
}
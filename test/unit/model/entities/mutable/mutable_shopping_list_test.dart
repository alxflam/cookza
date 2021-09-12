import 'package:cookza/model/entities/mutable/mutable_shopping_list.dart';
import 'package:cookza/model/entities/mutable/mutable_shopping_list_item.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../utils/recipe_creator.dart';

void main() {
  test('Add item', () async {
    var startDate = DateTime.now();
    var endDate = startDate.add(const Duration(days: 7));
    var cut = MutableShoppingList.ofValues(startDate, endDate, 'id', []);

    var onion = RecipeCreator.createIngredient('Onion', amount: 2, uom: 'PCS');

    var item = MutableShoppingListItem.ofIngredientNote(onion, false, false);

    cut.addItem(item);
    expect(cut.items.length, 1);
    expect(cut.items.first, item);
  });

  test('Clear items', () async {
    var startDate = DateTime.now();
    var endDate = startDate.add(const Duration(days: 7));
    var cut = MutableShoppingList.ofValues(startDate, endDate, 'id', []);

    var onion = RecipeCreator.createIngredient('Onion', amount: 2, uom: 'PCS');

    var item = MutableShoppingListItem.ofIngredientNote(onion, false, false);

    cut.addItem(item);
    expect(cut.items.length, 1);
    expect(cut.items.first, item);

    cut.clearItems();
    expect(cut.items.length, 0);
  });

  test('Remove bought item', () async {
    var startDate = DateTime.now();
    var endDate = startDate.add(const Duration(days: 7));
    var cut = MutableShoppingList.ofValues(startDate, endDate, 'id', []);

    var onion = RecipeCreator.createIngredient('Onion', amount: 2, uom: 'PCS');
    var item = MutableShoppingListItem.ofIngredientNote(onion, false, false);
    var bought = MutableShoppingListItem.ofIngredientNote(onion, true, false);

    cut.addItem(item);
    cut.addItem(bought);
    expect(cut.items.length, 2);

    cut.removeBought();
    expect(cut.items.length, 1);
    expect(cut.items.first, item);
  });

  test('Remove item', () async {
    var startDate = DateTime.now();
    var endDate = startDate.add(const Duration(days: 7));
    var cut = MutableShoppingList.ofValues(startDate, endDate, 'id', []);

    var onion = RecipeCreator.createIngredient('Onion', amount: 2, uom: 'PCS');
    var item = MutableShoppingListItem.ofIngredientNote(onion, false, false);
    var bought = MutableShoppingListItem.ofIngredientNote(onion, true, false);

    cut.addItem(item);
    cut.addItem(bought);
    expect(cut.items.length, 2);

    cut.removeItem(item);
    expect(cut.items.length, 1);
    expect(cut.items.first, bought);
  });
}

import 'package:cookza/model/entities/mutable/mutable_shopping_list_item.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../utils/recipe_creator.dart';

void main() {
  test('Create from IngredientNote', () async {
    var onion = RecipeCreator.createIngredient('Onion', amount: 2, uom: 'PCS');

    var cut = MutableShoppingListItem.ofIngredientNote(onion, false, false);

    expect(cut.ingredientNote.ingredient.name, onion.ingredient.name);
    expect(cut.isBought, false);
    expect(cut.isCustom, false);
  });

  test('Create from IngredientNote - custom and bought', () async {
    var onion = RecipeCreator.createIngredient('Onion', amount: 2, uom: 'PCS');

    var cut = MutableShoppingListItem.ofIngredientNote(onion, true, true);

    expect(cut.ingredientNote.ingredient.name, onion.ingredient.name);
    expect(cut.isBought, true);
    expect(cut.isCustom, true);
  });

  test('Create from ShoppingListItemEntity', () async {
    var onion = RecipeCreator.createIngredient('Onion', amount: 2, uom: 'PCS');
    var entity = MutableShoppingListItem.ofIngredientNote(onion, false, false);
    var cut = MutableShoppingListItem.ofEntity(entity);

    expect(cut.ingredientNote.ingredient.name, onion.ingredient.name);
    expect(cut.isBought, false);
    expect(cut.isCustom, false);
  });

  test('Create from ShoppingListItemEntity - custom and bought', () async {
    var onion = RecipeCreator.createIngredient('Onion', amount: 2, uom: 'PCS');
    var entity = MutableShoppingListItem.ofIngredientNote(onion, true, true);
    var cut = MutableShoppingListItem.ofEntity(entity);

    expect(cut.ingredientNote.ingredient.name, onion.ingredient.name);
    expect(cut.isBought, true);
    expect(cut.isCustom, true);
  });

  test('Set bought and custom', () async {
    var onion = RecipeCreator.createIngredient('Onion', amount: 2, uom: 'PCS');
    var entity = MutableShoppingListItem.ofIngredientNote(onion, false, false);
    var cut = MutableShoppingListItem.ofEntity(entity);

    expect(cut.ingredientNote.ingredient.name, onion.ingredient.name);
    expect(cut.isBought, false);
    expect(cut.isCustom, false);

    cut.isBought = true;
    expect(cut.isBought, true);

    cut.isCustom = true;
    expect(cut.isCustom, true);
  });

  test('Index', () async {
    var onion = RecipeCreator.createIngredient('Onion', amount: 2, uom: 'PCS');
    var entity = MutableShoppingListItem.ofIngredientNote(onion, false, false);
    var cut = MutableShoppingListItem.ofEntity(entity);

    /// not yet implemented
    expect(cut.index, null);
  });
}

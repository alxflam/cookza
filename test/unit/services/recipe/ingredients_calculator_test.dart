import 'package:cookza/model/entities/mutable/mutable_ingredient_group.dart';
import 'package:cookza/services/recipe/ingredients_calculator.dart';
import 'package:cookza/services/recipe/recipe_manager.dart';
import 'package:cookza/services/unit_of_measure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import '../../../mocks/recipe_manager_mock.dart';
import '../../../utils/recipe_creator.dart';

var rm = RecipeManagerStub();

void main() {
  setUpAll(() {
    GetIt.I.registerSingleton<RecipeManager>(rm);
    GetIt.I.registerSingleton<UnitOfMeasureProvider>(StaticUnitOfMeasure());
  });

  test('Calculate ingredients', () async {
    var recipe = RecipeCreator.createRecipe('First Recipe');
    recipe.servings = 2;
    var pepper =
        RecipeCreator.createIngredient('Pepper', amount: 100, uom: 'H87');
    var flour =
        RecipeCreator.createIngredient('Flour', amount: 750, uom: 'GRM');

    recipe.ingredientGroupList = [
      MutableIngredientGroup.forValues(1, 'Test', [flour, pepper])
    ];

    await rm.createOrUpdate(recipe);

    var recipe2 = RecipeCreator.createRecipe('Second Recipe');
    recipe2.servings = 1;
    var onion = RecipeCreator.createIngredient('Onion', amount: 25, uom: 'GRM');
    var flour2 =
        RecipeCreator.createIngredient('Flour', amount: 1.2, uom: 'KGM');
    var pepper2 =
        RecipeCreator.createIngredient('Pepper', amount: 300, uom: 'H87');

    recipe2.ingredientGroupList = [
      MutableIngredientGroup.forValues(1, 'Test', [flour2, pepper2, onion])
    ];

    await rm.createOrUpdate(recipe2);

    var cut = IngredientsCalculatorImpl();

    var result = await cut.getIngredients({recipe.id!: 4, recipe2.id!: 3});

    expect(result.length, 3);
    expect(result[0].amount, 5.1);
    expect(result[1].amount, 1100);
    expect(result[2].amount, 75);
  });

  test('Calculate amount for same ingredient with different metric unit',
      () async {
    var recipe = RecipeCreator.createRecipe('First Recipe');
    recipe.servings = 2;
    var flour =
        RecipeCreator.createIngredient('Flour', amount: 750, uom: 'GRM');
    recipe.ingredientGroupList = [
      MutableIngredientGroup.forValues(1, 'Test', [flour])
    ];

    await rm.createOrUpdate(recipe);

    var recipe2 = RecipeCreator.createRecipe('Second Recipe');
    recipe2.servings = 1;
    var flour2 =
        RecipeCreator.createIngredient('Flour', amount: 1.2, uom: 'KGM');
    recipe2.ingredientGroupList = [
      MutableIngredientGroup.forValues(1, 'Test', [flour2])
    ];

    await rm.createOrUpdate(recipe2);

    var cut = IngredientsCalculatorImpl();

    var result = await cut.getIngredients({recipe.id!: 4, recipe2.id!: 3});

    expect(result.length, 1);
    expect(result.first.amount, 5.1);
    expect(result.first.unitOfMeasure, 'KGM');
  });

  test('Calculate amount for same ingredient with non-compatible units',
      () async {
    var recipe = RecipeCreator.createRecipe('First Recipe');
    recipe.servings = 2;
    var flour =
        RecipeCreator.createIngredient('Flour', amount: 750, uom: 'H87');
    recipe.ingredientGroupList = [
      MutableIngredientGroup.forValues(1, 'Test', [flour])
    ];

    await rm.createOrUpdate(recipe);

    var recipe2 = RecipeCreator.createRecipe('Second Recipe');
    recipe2.servings = 1;
    var flour2 =
        RecipeCreator.createIngredient('Flour', amount: 1.2, uom: 'KGM');
    recipe2.ingredientGroupList = [
      MutableIngredientGroup.forValues(1, 'Test', [flour2])
    ];

    await rm.createOrUpdate(recipe2);

    var cut = IngredientsCalculatorImpl();

    var result = await cut.getIngredients({recipe.id!: 4, recipe2.id!: 3});

    expect(result.length, 2);
    expect(result.first.amount, 1500);
    expect(result.last.amount!.toStringAsPrecision(3), '3.60');
  });

  test(
      'Calculate amount for same ingredient with different metric unit with multiple units difference',
      () async {
    var recipe = RecipeCreator.createRecipe('First Recipe');
    recipe.servings = 2;
    var milk = RecipeCreator.createIngredient('Milk', amount: 150, uom: 'MLT');
    recipe.ingredientGroupList = [
      MutableIngredientGroup.forValues(1, 'Test', [milk])
    ];

    await rm.createOrUpdate(recipe);

    var recipe2 = RecipeCreator.createRecipe('Second Recipe');
    recipe2.servings = 1;
    var milk2 = RecipeCreator.createIngredient('Milk', amount: 1.2, uom: 'LTR');
    recipe2.ingredientGroupList = [
      MutableIngredientGroup.forValues(1, 'Test', [milk2])
    ];

    await rm.createOrUpdate(recipe2);

    var cut = IngredientsCalculatorImpl();

    var result = await cut.getIngredients({recipe.id!: 4, recipe2.id!: 3});

    expect(result.length, 1);
    // 4 / 2 * 150 + 3 / 1 * 1.2 = 400 + 3.6 => 3.9
    expect(result.first.amount!.toStringAsFixed(1), '3.9');
    expect(result.first.unitOfMeasure, 'LTR');
  });
}

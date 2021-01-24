import 'package:cookza/model/entities/mutable/mutable_meal_plan.dart';
import 'package:cookza/model/entities/mutable/mutable_shopping_list.dart';
import 'package:cookza/services/recipe/ingredients_calculator.dart';
import 'package:cookza/services/meal_plan_manager.dart';
import 'package:cookza/services/recipe/recipe_manager.dart';
import 'package:cookza/services/shared_preferences_provider.dart';
import 'package:cookza/services/shopping_list/shopping_list_items_generator.dart';
import 'package:cookza/services/unit_of_measure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../mocks/meal_plan_manager_mock.dart';
import '../../mocks/recipe_manager_mock.dart';
import '../../utils/recipe_creator.dart';

void main() {
  var mealPlanManager = MealPlanManagerMock();
  var recipeManager = RecipeManagerStub();

  var cut = ShoppingListItemsGeneratorImpl();

  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
    GetIt.I
        .registerSingleton<IngredientsCalculator>(IngredientsCalculatorImpl());
    GetIt.I.registerSingleton<MealPlanManager>(mealPlanManager);
    GetIt.I.registerSingleton<RecipeManager>(recipeManager);
    GetIt.I.registerSingleton<UnitOfMeasureProvider>(StaticUnitOfMeasure());
    GetIt.I.registerSingleton<SharedPreferencesProvider>(
        SharedPreferencesProviderImpl());
  });

  setUp(() {
    mealPlanManager.reset();
    recipeManager.reset();
  });

  test(
    'Include items in date range - including start and end date',
    () async {
      var startDate = DateTime.now();
      var endDate = startDate.add(Duration(days: 7));
      var shoppingList =
          MutableShoppingList.ofValues(startDate, endDate, 'id', []);

      var recipe = RecipeCreator.createRecipe('First Recipe');
      recipe.servings = 2;
      var onion =
          RecipeCreator.createIngredient('Onion', amount: 2, uom: 'PCS');
      var pepper =
          RecipeCreator.createIngredient('Pepper', amount: 100, uom: 'GRM');
      recipe.ingredientList = [onion, pepper];

      await recipeManager.createOrUpdate(recipe);

      var firstDateItem = MutableMealPlanDateEntity.empty(startDate);
      firstDateItem.addRecipe(
          MutableMealPlanRecipeEntity.fromValues(recipe.id, recipe.name, 2));

      var midDateItem =
          MutableMealPlanDateEntity.empty(startDate.add(Duration(days: 2)));
      midDateItem.addRecipe(
          MutableMealPlanRecipeEntity.fromValues(recipe.id, recipe.name, 2));

      var endDateItem = MutableMealPlanDateEntity.empty(endDate);
      endDateItem.addRecipe(
          MutableMealPlanRecipeEntity.fromValues(recipe.id, recipe.name, 2));

      mealPlanManager.addMealPlan(
          'id',
          MutableMealPlan.of(
              'id', 'id', [firstDateItem, midDateItem, endDateItem], 2));

      var result = await cut.generateItems(shoppingList);

      expect(result.length, 2);
      expect(result.first.ingredientNote.ingredient.name, 'Onion');
      expect(result.first.ingredientNote.amount, 6);
      expect(result.last.ingredientNote.ingredient.name, 'Pepper');
      expect(result.last.ingredientNote.amount, 300);
    },
  );

  test(
    'Skip items before list start date',
    () async {
      var startDate = DateTime.now();
      var endDate = startDate.add(Duration(days: 7));
      var shoppingList =
          MutableShoppingList.ofValues(startDate, endDate, 'id', []);

      var recipe = RecipeCreator.createRecipe('First Recipe');
      recipe.servings = 2;
      var onion =
          RecipeCreator.createIngredient('Onion', amount: 2, uom: 'PCS');
      var pepper =
          RecipeCreator.createIngredient('Pepper', amount: 100, uom: 'GRM');
      recipe.ingredientList = [onion, pepper];

      await recipeManager.createOrUpdate(recipe);

      var firstDate = MutableMealPlanDateEntity.empty(
          startDate.subtract(Duration(days: 1)));
      firstDate.addRecipe(
          MutableMealPlanRecipeEntity.fromValues(recipe.id, recipe.name, 2));

      mealPlanManager.addMealPlan(
          'id', MutableMealPlan.of('id', 'id', [firstDate], 2));

      var result = await cut.generateItems(shoppingList);

      expect(result.length, 0);
    },
  );

  test(
    'Skip items after list end date',
    () async {
      var startDate = DateTime.now();
      var endDate = startDate.add(Duration(days: 7));
      var shoppingList =
          MutableShoppingList.ofValues(startDate, endDate, 'id', []);

      var recipe = RecipeCreator.createRecipe('First Recipe');
      recipe.servings = 2;
      var onion =
          RecipeCreator.createIngredient('Onion', amount: 2, uom: 'PCS');
      var pepper =
          RecipeCreator.createIngredient('Pepper', amount: 100, uom: 'GRM');
      recipe.ingredientList = [onion, pepper];

      await recipeManager.createOrUpdate(recipe);

      var firstDate =
          MutableMealPlanDateEntity.empty(endDate.add(Duration(days: 1)));
      firstDate.addRecipe(
          MutableMealPlanRecipeEntity.fromValues(recipe.id, recipe.name, 2));

      mealPlanManager.addMealPlan(
          'id', MutableMealPlan.of('id', 'id', [firstDate], 2));

      var result = await cut.generateItems(shoppingList);

      expect(result.length, 0);
    },
  );

  test(
    'Resolve inner recipes',
    () async {
      var startDate = DateTime.now();
      var endDate = startDate.add(Duration(days: 7));
      var shoppingList =
          MutableShoppingList.ofValues(startDate, endDate, 'id', []);

      var onion =
          RecipeCreator.createIngredient('Onion', amount: 2, uom: 'PCS');
      var pepper =
          RecipeCreator.createIngredient('Pepper', amount: 100, uom: 'GRM');
      var oil = RecipeCreator.createIngredient('Oil', amount: 200, uom: 'MLT');

      var dressing = RecipeCreator.createRecipe('Dressing');
      dressing.servings = 2;
      dressing.ingredientList = [oil, pepper];

      await recipeManager.createOrUpdate(dressing);

      var dressingIngredient = RecipeCreator.createIngredientFromRecipe(
          dressing,
          uom: 'PCS',
          amount: 2);

      var salad = RecipeCreator.createRecipe('Salad');
      salad.servings = 2;
      salad.ingredientList = [onion, pepper, dressingIngredient];

      await recipeManager.createOrUpdate(salad);

      var midDateItem =
          MutableMealPlanDateEntity.empty(startDate.add(Duration(days: 2)));
      midDateItem.addRecipe(
          MutableMealPlanRecipeEntity.fromValues(salad.id, salad.name, 2));

      mealPlanManager.addMealPlan(
          'id', MutableMealPlan.of('id', 'id', [midDateItem], 2));

      var result = await cut.generateItems(shoppingList);

      var resultIngredients =
          result.map((e) => e.ingredientNote.ingredient.name).toList();
      print(resultIngredients);

      expect(result.length, 3);
      expect(result[0].ingredientNote.ingredient.name, 'Onion');
      expect(result[0].ingredientNote.amount, 2);
      expect(result[1].ingredientNote.ingredient.name, 'Pepper');
      expect(result[1].ingredientNote.amount, 200);
      expect(result[2].ingredientNote.ingredient.name, 'Oil');
      expect(result[2].ingredientNote.amount, 200);
    },
  );
}

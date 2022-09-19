import 'package:cookza/model/entities/abstract/meal_plan_entity.dart';
import 'package:cookza/model/entities/mutable/mutable_meal_plan.dart';
import 'package:cookza/services/meal_plan_manager.dart';
import 'package:cookza/services/shared_preferences_provider.dart';
import 'package:cookza/services/util/week_calculation.dart';
import 'package:cookza/viewmodel/meal_plan/recipe_meal_plan_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/meal_plan_manager_mock.dart';
import '../../utils/recipe_creator.dart';

class MealPlanEntityMock extends Mock implements MealPlanEntity {
  List<MealPlanDateEntity> _items = [];

  @override
  String get id => 'id';

  @override
  String get groupID => 'id';

  @override
  List<MealPlanDateEntity> get items => this._items;

  set items(List<MealPlanDateEntity> value) => this._items = value;
}

void main() {
  const int weeks = 2;
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({'mealPlanWeeks': weeks});

  GetIt.I.registerSingletonAsync<SharedPreferencesProvider>(
      () async => SharedPreferencesProviderImpl().init());
  GetIt.I.registerSingleton<MealPlanManager>(MealPlanManagerMock());

  test(
    'Compute timeline if no persistent data is present on a monday',
    () async {
      var today = DateTime(2020, 8, 31); // monday

      var model = MealPlanViewModel.of(MealPlanEntityMock(), startDate: today);

      var startDate = DateTime(today.year, today.month, today.day);
      var endDate = DateTime(2020, 9, 13); // exactly two weeks coverage

      expect(model.entries.length, 21); // 21 days with one week in the past
      expect(model.entries.first.date.isBefore(startDate), true);
      expect(model.entries[7].date.isAtSameMomentAs(startDate), true);
      expect(model.entries.last.date.isAtSameMomentAs(endDate), true);
      expect(model.entries.last.date.weekday, DateTime.sunday);
    },
  );

  test(
    'Compute timeline if no persistent data is present on a wednesday',
    () async {
      var today = DateTime(2020, 9, 2); // wednesday

      var model = MealPlanViewModel.of(MealPlanEntityMock(), startDate: today);

      var startDate = DateTime(today.year, today.month, today.day);
      var endDate = DateTime(2020, 9, 20);

      expect(model.entries.length, 28);
      expect(model.entries.first.date.isBefore(startDate), true);
      expect(model.entries[9].date.isAtSameMomentAs(startDate), true);
      expect(model.entries.last.date.isAtSameMomentAs(endDate), true);
      expect(model.entries.last.date.weekday, DateTime.sunday);
    },
  );

  test(
    'start with past data',
    () async {
      var today = DateTime.now();

      var mock = MealPlanEntityMock();
      var item = MutableMealPlanDateEntity.empty(
          today.subtract(const Duration(days: 1)));
      item.addRecipe(MutableMealPlanRecipeEntity.fromValues('', 'test', 2));
      mock.items = [item];

      var model = MealPlanViewModel.of(mock);

      var startDate = DateTime(today.year, today.month, today.day);

      expect(model.entries.first.date.isBefore(startDate), true);
    },
  );

  test(
    'End on last day of persistent data if this exceeds the configured timeline',
    () async {
      var today = DateTime.now();
      var endDate = today.add(const Duration(days: 20));

      var mock = MealPlanEntityMock();
      var item = MutableMealPlanDateEntity.empty(endDate);
      item.addRecipe(MutableMealPlanRecipeEntity.fromValues('', 'test', 2));
      mock.items = [item];

      var model = MealPlanViewModel.of(mock);

      expect(model.entries.last.date.isAtSameMomentAs(endDate), true);
    },
  );

  test(
    'Use values from persisted data',
    () async {
      var today = DateTime(2022, 9, 19); // monday
      var firstPersistedDate = today.add(const Duration(days: 3));
      var secondPersistedDate = today.add(const Duration(days: 6));

      var mock = MealPlanEntityMock();
      var item = MutableMealPlanDateEntity.empty(firstPersistedDate);
      item.addRecipe(MutableMealPlanRecipeEntity.fromValues('', 'test', 2));
      var secondItem = MutableMealPlanDateEntity.empty(secondPersistedDate);
      secondItem
          .addRecipe(MutableMealPlanRecipeEntity.fromValues('', 'test', 2));

      mock.items = [item, secondItem];

      var model = MealPlanViewModel.of(mock);

      expect(
          isSameDay(model.entries[9].date,
              firstPersistedDate.subtract(const Duration(days: 1))),
          true);
      expect(isSameDay(model.entries[10].date, firstPersistedDate), true);

      expect(model.entries[10].recipes.length, 1);
      expect(
          isSameDay(model.entries[11].date,
              firstPersistedDate.add(const Duration(days: 1))),
          true);
      expect(
          isSameDay(model.entries[12].date,
              firstPersistedDate.add(const Duration(days: 2))),
          true);
      expect(isSameDay(model.entries[13].date, secondPersistedDate), true);
      expect(
          isSameDay(model.entries[14].date,
              secondPersistedDate.add(const Duration(days: 1))),
          true);
    },
  );

  test(
    'Fill gaps between persisted data',
    () async {
      var today = DateTime.now();

      var mock = MealPlanEntityMock();
      var firstMealPlanEntry = today.add(const Duration(days: 3));
      var item = MutableMealPlanDateEntity.empty(firstMealPlanEntry);
      item.addRecipe(MutableMealPlanRecipeEntity.fromValues('', 'test', 2));
      var secondMealPlanEntry = today.add(const Duration(days: 6));
      var secondItem =
          MutableMealPlanDateEntity.empty(today.add(const Duration(days: 6)));
      secondItem
          .addRecipe(MutableMealPlanRecipeEntity.fromValues('', 'test', 2));

      mock.items = [item, secondItem];

      var model = MealPlanViewModel.of(mock);

      expect(
          model.entries
              .firstWhere(
                  (e) => DateUtils.isSameDay(e.date, firstMealPlanEntry))
              .recipes
              .length,
          1);
      expect(
          model.entries
              .firstWhere(
                  (e) => DateUtils.isSameDay(e.date, secondMealPlanEntry))
              .recipes
              .length,
          1);
    },
  );

  test(
    'Add recipe by navigation',
    () async {
      var mock = MealPlanEntityMock();
      var model = MealPlanViewModel.of(mock);

      var recipe = RecipeCreator.createRecipe('TestRecipe');
      model.setRecipeForAddition(recipe);
      model.addByNavigation(1);

      expect(model.entries[1].recipes.length, 1);
      expect(model.entries[1].recipes.first.name, 'TestRecipe');

      /// add by navigation only works once
      model.addByNavigation(0);
      expect(model.entries[0].recipes.length, 0);
    },
  );

  test(
    'Move recipe',
    () async {
      var today = DateTime.now();

      var mock = MealPlanEntityMock();
      var itemDate = today.add(const Duration(days: 3));
      var item = MutableMealPlanDateEntity.empty(itemDate);
      item.addRecipe(
          MutableMealPlanRecipeEntity.fromValues('', 'TestRecipe', 2));
      mock.items = [item];

      var model = MealPlanViewModel.of(mock);
      var entryWithRecipe = model.entries
          .firstWhere((e) => DateUtils.isSameDay(e.date, itemDate));
      expect(entryWithRecipe.recipes.length, 1);
      expect(entryWithRecipe.recipes.first.name, 'TestRecipe');

      var originIndex = model.entries
          .indexWhere((e) => DateUtils.isSameDay(e.date, entryWithRecipe.date));
      var dragModel = MealDragModel(entryWithRecipe.recipes.first, originIndex);
      expect(dragModel.model.name, 'TestRecipe');

      model.moveRecipe(dragModel, 0);
      expect(model.entries[0].recipes.length, 1);
      expect(model.entries[0].recipes.first.name, 'TestRecipe');
      expect(entryWithRecipe.recipes.length, 0);
    },
  );

  test(
    'Add and remove recipe',
    () async {
      var today = DateTime(2022, 9, 19); // monday

      var mock = MealPlanEntityMock();
      var item =
          MutableMealPlanDateEntity.empty(today.add(const Duration(days: 3)));
      item.addRecipe(
          MutableMealPlanRecipeEntity.fromValues('A', 'TestRecipe', 2));
      mock.items = [item];

      var model = MealPlanViewModel.of(mock);
      var recipeModel = model.entries[10].recipes.first;

      expect(model.entries[10].recipes.length, 1);
      expect(model.entries[10].recipes.first.name, 'TestRecipe');
      model.entries[10].removeRecipe('A');
      expect(model.entries[10].recipes.length, 0);

      model.entries[10].addRecipe(recipeModel);
      expect(model.entries[10].recipes.length, 1);
      expect(model.entries[10].recipes.first.name, 'TestRecipe');
    },
  );
}

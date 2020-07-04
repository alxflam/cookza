import 'package:cookly/model/entities/abstract/meal_plan_entity.dart';
import 'package:cookly/model/entities/mutable/mutable_meal_plan.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:cookly/services/shared_preferences_provider.dart';
import 'package:cookly/services/util/week_calculation.dart';
import 'package:cookly/viewmodel/meal_plan/recipe_meal_plan_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mockito/mockito.dart';

class MealPlanEntityMock extends Mock implements MealPlanEntity {
  var _items = [];

  @override
  String get id => 'id';

  @override
  String get groupID => 'id';

  @override
  List<MealPlanDateEntity> get items => this._items;

  set items(List<MealPlanDateEntity> value) => this._items = value;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({"mealPlanWeeks": 2});

  sl.registerSingletonAsync<SharedPreferencesProvider>(
      () async => SharedPreferencesProviderImpl().init());

  test(
    'Compute timeline if no persistent data is present',
    () async {
      var model = MealPlanViewModel.of(MealPlanEntityMock());

      var today = DateTime.now();
      var offset = 0;
      if (DateTime.monday != today.weekday) {
        offset = 7 - today.weekday;
      }
      var startDate = DateTime(today.year, today.month, today.day);
      var endDate = startDate.add(Duration(days: 14 + offset));

      expect(model.entries.length, 14 + offset + 1);
      expect(model.entries.first.date.isAtSameMomentAs(startDate), true);
      expect(model.entries.last.date.isAtSameMomentAs(endDate), true);
      expect(model.entries.last.date.weekday, DateTime.sunday);
    },
  );

  test(
    'Start today if past data is present',
    () async {
      var today = DateTime.now();

      var mock = MealPlanEntityMock();
      var item =
          MutableMealPlanDateEntity.empty(today.subtract(Duration(days: 1)));
      item.addRecipe(MutableMealPlanRecipeEntity.fromValues('', 'test', 2));
      mock.items = [item];

      var model = MealPlanViewModel.of(mock);

      var startDate = DateTime(today.year, today.month, today.day);

      expect(model.entries.first.date.isAtSameMomentAs(startDate), true);
    },
  );

  test(
    'End on last day of persistent data if this exceeds the configured timeline',
    () async {
      var today = DateTime.now();
      var endDate = today.add(Duration(days: 20));

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
      var today = DateTime.now();
      var firstPersistedDate = today.add(Duration(days: 3));
      var secondPersistedDate = today.add(Duration(days: 6));

      var mock = MealPlanEntityMock();
      var item = MutableMealPlanDateEntity.empty(firstPersistedDate);
      item.addRecipe(MutableMealPlanRecipeEntity.fromValues('', 'test', 2));
      var secondItem = MutableMealPlanDateEntity.empty(secondPersistedDate);
      secondItem
          .addRecipe(MutableMealPlanRecipeEntity.fromValues('', 'test', 2));

      mock.items = [item, secondItem];

      var model = MealPlanViewModel.of(mock);

      expect(
          isSameDay(model.entries[2].date,
              firstPersistedDate.subtract(Duration(days: 1))),
          true);
      expect(isSameDay(model.entries[3].date, firstPersistedDate), true);

      expect(model.entries[3].recipes.length, 1);
      expect(
          isSameDay(
              model.entries[4].date, firstPersistedDate.add(Duration(days: 1))),
          true);
      expect(
          isSameDay(
              model.entries[5].date, firstPersistedDate.add(Duration(days: 2))),
          true);
      expect(isSameDay(model.entries[6].date, secondPersistedDate), true);
      expect(
          isSameDay(model.entries[7].date,
              secondPersistedDate.add(Duration(days: 1))),
          true);
    },
  );

  test(
    'Fill gaps between persisted data',
    () async {
      var today = DateTime.now();

      var mock = MealPlanEntityMock();
      var item = MutableMealPlanDateEntity.empty(today.add(Duration(days: 3)));
      item.addRecipe(MutableMealPlanRecipeEntity.fromValues('', 'test', 2));
      var secondItem =
          MutableMealPlanDateEntity.empty(today.add(Duration(days: 6)));
      secondItem
          .addRecipe(MutableMealPlanRecipeEntity.fromValues('', 'test', 2));

      mock.items = [item, secondItem];

      var model = MealPlanViewModel.of(mock);

      expect(model.entries[3].recipes.length, 1);
      expect(model.entries[6].recipes.length, 1);
    },
  );
}

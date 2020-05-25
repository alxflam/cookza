import 'dart:ui';

import 'package:cookly/model/json/meal_plan.dart';
import 'package:cookly/model/json/meal_plan_item.dart';
import 'package:cookly/model/view/recipe_meal_plan_model.dart';
import 'package:cookly/services/abstract/data_store.dart';
import 'package:cookly/services/app_profile.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:cookly/services/shared_preferences_provider.dart';
import 'package:cookly/services/util/week_calculation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataStoreMock extends Mock implements DataStore {}

class AppProfileMock extends Mock implements AppProfile {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({"mealPlanWeeks": 2});

  sl.registerSingletonAsync<SharedPreferencesProvider>(
      () async => SharedPreferencesProviderImpl().init());
  var dataStoreMock = DataStoreMock();
  sl.registerSingleton<DataStore>(dataStoreMock);

  when(dataStoreMock.appProfile).thenReturn(AppProfileMock());

  test(
    'Compute timeline if no persistent data is present',
    () async {
      var model = MealPlanViewModel.of(Locale('en', 'EN'), MealPlan());

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

      var model = MealPlanViewModel.of(
          Locale('en', 'EN'),
          MealPlan(items: [
            MealPlanItem(
                date: today.subtract(Duration(days: 1)),
                recipeReferences: {"test": 2})
          ]));

      var startDate = DateTime(today.year, today.month, today.day);

      expect(model.entries.first.date.isAtSameMomentAs(startDate), true);
    },
  );

  test(
    'End on last day of persistent data if this exceeds the configured timeline',
    () async {
      var today = DateTime.now();
      var endDate = today.add(Duration(days: 20));

      var model = MealPlanViewModel.of(
        Locale('en', 'EN'),
        MealPlan(
          items: [
            MealPlanItem(date: endDate, recipeReferences: {"test": 2}),
          ],
        ),
      );

      expect(model.entries.last.date.isAtSameMomentAs(endDate), true);
    },
  );

  test(
    'Use values from persisted data',
    () async {
      var today = DateTime.now();
      var firstPersistedDate = today.add(Duration(days: 3));
      var secondPersistedDate = today.add(Duration(days: 6));

      var model = MealPlanViewModel.of(
        Locale('en', 'EN'),
        MealPlan(
          items: [
            MealPlanItem(
                date: firstPersistedDate, recipeReferences: {"test": 2}),
            MealPlanItem(
                date: secondPersistedDate, recipeReferences: {"test": 2})
          ],
        ),
      );

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

      var model = MealPlanViewModel.of(
        Locale('en', 'EN'),
        MealPlan(
          items: [
            MealPlanItem(
                date: today.add(Duration(days: 3)),
                recipeReferences: {"test": 2}),
            MealPlanItem(
                date: today.add(Duration(days: 6)),
                recipeReferences: {"test": 2})
          ],
        ),
      );

      expect(model.entries[3].recipes.length, 1);
      expect(model.entries[6].recipes.length, 1);
    },
  );
}

import 'package:cookza/model/entities/mutable/mutable_meal_plan.dart';
import 'package:cookza/services/util/week_calculation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'add items in the past',
    () async {
      var yesterday = DateTime.now().subtract(const Duration(days: 1));

      var mealPlanDate = MutableMealPlanDateEntity.empty(yesterday);
      mealPlanDate.addRecipe(
          MutableMealPlanRecipeEntity.fromValues('1234', 'A Recipe', 3));

      var cut = MutableMealPlan.of('id1', 'group1', [mealPlanDate], 1);

      expect(cut.items.first.date.isBefore(DateTime.now()), true);
      expect(cut.items.first.recipes.isEmpty, true);
    },
  );

  test(
    'items too far in the future should not be skipped',
    () async {
      var twoWeeksAhead = DateTime.now().add(const Duration(days: 14));

      var mealPlanDate = MutableMealPlanDateEntity.empty(twoWeeksAhead);
      mealPlanDate.addRecipe(
          MutableMealPlanRecipeEntity.fromValues('1234', 'A Recipe', 3));

      var cut = MutableMealPlan.of('id1', 'group1', [mealPlanDate], 1);

      expect(isSameDay(cut.items.last.date, twoWeeksAhead), true);
      expect(cut.items.last.recipes.first.name, 'A Recipe');
    },
  );

  test(
    'item gaps are filled and prefixed wit one week history',
    () async {
      final startDate = DateTime(2022, 08, 15);
      var threeDaysAhead = startDate.add(const Duration(days: 3));

      var mealPlanDate = MutableMealPlanDateEntity.empty(threeDaysAhead);
      mealPlanDate.addRecipe(
          MutableMealPlanRecipeEntity.fromValues('1234', 'A Recipe', 3));

      var cut = MutableMealPlan.of('id1', 'group1', [mealPlanDate], 1,
          startDate: startDate);

      var calculatedStartDate = startDate.subtract(const Duration(days: 7));
      for (var i = 0; i < cut.items.length; i++) {
        var item = cut.items[i];
        expect(isSameDay(item.date, calculatedStartDate.add(Duration(days: i))),
            true);
        if (i == 10) {
          expect(item.recipes.length, 1);
          expect(item.recipes.first.name, 'A Recipe');
        }
      }
    },
  );

  test(
    'items are sorted',
    () async {
      var threeDaysAhead = DateTime.now().add(const Duration(days: 3));
      var twoDaysAhead = DateTime.now().add(const Duration(days: 2));

      var mealPlanDate = MutableMealPlanDateEntity.empty(threeDaysAhead);
      mealPlanDate.addRecipe(
          MutableMealPlanRecipeEntity.fromValues('1234', 'A Recipe', 3));

      var mealPlanDate2 = MutableMealPlanDateEntity.empty(twoDaysAhead);
      mealPlanDate2.addRecipe(
          MutableMealPlanRecipeEntity.fromValues('1234', 'A Recipe', 3));

      var cut =
          MutableMealPlan.of('id1', 'group1', [mealPlanDate, mealPlanDate2], 1);

      var daysWithRecipes = cut.items.where((e) => e.recipes.isNotEmpty).length;
      expect(daysWithRecipes, 2);

      for (var i = 0; i < cut.items.length; i++) {
        if (i < (cut.items.length - 1)) {
          expect(cut.items[i].date.isBefore(cut.items[i + 1].date), true);
        }
      }
    },
  );

  group('End date calculation tests', () {
    var testData = {
      DateTime(2023, 05, 15): DateTime(2023, 05, 28), // monday
      DateTime(2023, 05, 16): DateTime(2023, 06, 04), // truesday
      DateTime(2023, 05, 17): DateTime(2023, 06, 04), // wednesday
      DateTime(2023, 05, 18): DateTime(2023, 06, 04), // thursday
      DateTime(2023, 05, 19): DateTime(2023, 06, 04), // friday
      DateTime(2023, 05, 20): DateTime(2023, 06, 04), // saturday
      DateTime(2023, 05, 21): DateTime(2023, 06, 04) // sunday
    };

    for (var entry in testData.entries) {
      test(
        'Calculate meal plan end day',
        () async {
          var startDate = entry.key;

          var mealPlanDate = MutableMealPlanDateEntity.empty(startDate);
          var cut = MutableMealPlan.of('id1', 'group1', [mealPlanDate], 2,
              startDate: startDate);

          expect(cut.items.first.date.isBefore(startDate), true);
          expect(cut.items.last.date, entry.value);
        },
      );
    }
  });
}

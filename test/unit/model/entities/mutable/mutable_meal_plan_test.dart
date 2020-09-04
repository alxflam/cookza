import 'package:cookly/model/entities/mutable/mutable_meal_plan.dart';
import 'package:cookly/services/util/week_calculation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'skip items in the past',
    () async {
      var yesterday = DateTime.now().subtract(Duration(days: 1));

      var mealPlanDate = MutableMealPlanDateEntity.empty(yesterday);
      mealPlanDate.addRecipe(
          MutableMealPlanRecipeEntity.fromValues('1234', 'A Recipe', 3));

      var cut = MutableMealPlan.of('id1', 'group1', [mealPlanDate], 1);

      expect(cut.items.first.date.isAfter(yesterday), true);
      expect(cut.items.first.recipes.isEmpty, true);
    },
  );

  test(
    'items too far in the future should not be skipped',
    () async {
      var twoWeeksAhead = DateTime.now().add(Duration(days: 14));

      var mealPlanDate = MutableMealPlanDateEntity.empty(twoWeeksAhead);
      mealPlanDate.addRecipe(
          MutableMealPlanRecipeEntity.fromValues('1234', 'A Recipe', 3));

      var cut = MutableMealPlan.of('id1', 'group1', [mealPlanDate], 1);

      expect(isSameDay(cut.items.last.date, twoWeeksAhead), true);
      expect(cut.items.last.recipes.first.name, 'A Recipe');
    },
  );

  test(
    'item gaps are filled',
    () async {
      var threeDaysAhead = DateTime.now().add(Duration(days: 3));

      var mealPlanDate = MutableMealPlanDateEntity.empty(threeDaysAhead);
      mealPlanDate.addRecipe(
          MutableMealPlanRecipeEntity.fromValues('1234', 'A Recipe', 3));

      var cut = MutableMealPlan.of('id1', 'group1', [mealPlanDate], 1);

      for (var i = 0; i < cut.items.length; i++) {
        var item = cut.items[i];
        expect(
            isSameDay(item.date, DateTime.now().add(Duration(days: i))), true);
        if (i == 3) {
          expect(item.recipes.length, 1);
          expect(item.recipes.first.name, 'A Recipe');
        }
      }
    },
  );

  test(
    'items are sorted',
    () async {
      var threeDaysAhead = DateTime.now().add(Duration(days: 3));
      var twoDaysAhead = DateTime.now().add(Duration(days: 2));

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
}

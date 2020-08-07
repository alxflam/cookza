import 'package:cookly/model/entities/firebase/meal_plan_entity.dart';
import 'package:cookly/model/entities/mutable/mutable_meal_plan.dart';
import 'package:cookly/model/firebase/meal_plan/firebase_meal_plan.dart';
import 'package:cookly/services/util/week_calculation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'skip items in the past',
    () async {
      var yesterday = DateTime.now().subtract(Duration(days: 1));
      var document = FirebaseMealPlanDocument.empty('id1', 'group1');
      document.items = [
        FirebaseMealPlanDate(
            date: yesterday,
            recipes: [FirebaseMealPlanRecipe(name: 'A Recipe')])
      ];
      var model = MealPlanEntityFirebase.of(document);

      var cut = MutableMealPlan.of(model, 1);

      expect(cut.items.first.date.isAfter(yesterday), true);
      expect(cut.items.first.recipes.isEmpty, true);
    },
  );

  test(
    'items too far in the future should not be skipped',
    () async {
      var twoWeeksAhead = DateTime.now().add(Duration(days: 14));
      var document = FirebaseMealPlanDocument.empty('id1', 'group1');
      document.items = [
        FirebaseMealPlanDate(
            date: twoWeeksAhead,
            recipes: [FirebaseMealPlanRecipe(name: 'A Recipe')])
      ];
      var model = MealPlanEntityFirebase.of(document);

      var cut = MutableMealPlan.of(model, 1);

      expect(isSameDay(cut.items.last.date, twoWeeksAhead), true);
      expect(cut.items.last.recipes.first.name, 'A Recipe');
    },
  );

  test(
    'item gaps are filled',
    () async {
      var threeDaysAhead = DateTime.now().add(Duration(days: 3));
      var document = FirebaseMealPlanDocument.empty('id1', 'group1');
      document.items = [
        FirebaseMealPlanDate(
            date: threeDaysAhead,
            recipes: [FirebaseMealPlanRecipe(name: 'A Recipe')])
      ];
      var model = MealPlanEntityFirebase.of(document);

      var cut = MutableMealPlan.of(model, 1);

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
      var document = FirebaseMealPlanDocument.empty('id1', 'group1');
      var model = MealPlanEntityFirebase.of(document);

      var cut = MutableMealPlan.of(model, 1);

      for (var i = 0; i < cut.items.length; i++) {
        if (i < (cut.items.length - 1)) {
          expect(cut.items[i].date.isBefore(cut.items[i + 1].date), true);
        }
      }
    },
  );
}

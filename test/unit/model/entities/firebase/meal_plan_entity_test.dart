import 'package:cookly/model/entities/firebase/meal_plan_entity.dart';
import 'package:cookly/model/firebase/meal_plan/firebase_meal_plan.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'RecipeEntity as recipe',
    () async {
      var recipe =
          FirebaseMealPlanRecipe(name: 'dummy', id: '1234', servings: 2);

      var cut = MealPlanRecipeEntityFirebase.of(recipe);

      expect(cut.name, 'dummy');
      expect(cut.servings, 2);
      expect(cut.id, '1234');
      expect(cut.isNote, false);
    },
  );

  test(
    'RecipeEntity as note',
    () async {
      var recipe =
          FirebaseMealPlanRecipe(name: 'dummy', id: null, servings: null);

      var cut = MealPlanRecipeEntityFirebase.of(recipe);

      expect(cut.name, 'dummy');
      expect(cut.servings, null);
      expect(cut.id, null);
      expect(cut.isNote, true);
    },
  );

  test(
    'DateEntity with recipes',
    () async {
      var date = DateTime.now();
      List<FirebaseMealPlanRecipe> recipes = [];
      recipes
          .add(FirebaseMealPlanRecipe(name: 'dummy', id: '1234', servings: 2));

      var item = FirebaseMealPlanDate(date: date, recipes: recipes);
      var cut = MealPlanDateEntityFirebase.of(item);

      expect(cut.date, date);
      expect(cut.recipes.length, 1);
      expect(cut.recipes.first.name, 'dummy');
      expect(cut.recipes.first.servings, 2);
      expect(cut.recipes.first.id, '1234');
    },
  );
}

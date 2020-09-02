import 'package:cookly/model/entities/mutable/mutable_meal_plan.dart';
import 'package:cookly/model/firebase/meal_plan/firebase_meal_plan.dart';
import 'package:cookly/services/util/week_calculation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'Parse meal plan recipe JSON',
    () async {
      var json = {
        'name': 'Some Recipe',
        'id': '1234',
        'servings': 4,
      } as Map<String, dynamic>;

      var cut = FirebaseMealPlanRecipe.fromJson(json);
      var generatedJson = cut.toJson();

      expect(cut.name, 'Some Recipe');
      expect(cut.id, '1234');
      expect(cut.servings, 4);
      expect(generatedJson, json);
    },
  );

  test(
    'Parse meal plan recipe from Entity',
    () async {
      var item =
          MutableMealPlanRecipeEntity.fromValues('1234', 'Some Recipe', 4);
      var cut = FirebaseMealPlanRecipe.from(item);

      expect(cut.name, 'Some Recipe');
      expect(cut.id, '1234');
      expect(cut.servings, 4);
    },
  );

  test(
    'Parse meal plan date from Json',
    () async {
      var json = {
        'date': '01.01.2020',
        'recipes': [
          FirebaseMealPlanRecipe(id: '1234', name: 'Recipe', servings: 4)
              .toJson()
        ]
      };

      var cut = FirebaseMealPlanDate.fromJson(json);
      var generatedJson = cut.toJson();

      expect(isSameDay(cut.date, DateTime(2020, 01, 01)), true);
      expect(cut.recipes.length, 1);
      expect(cut.recipes.first.name, 'Recipe');
      expect(cut.recipes.first.servings, 4);
      expect(cut.recipes.first.id, '1234');
      expect(generatedJson, json);
    },
  );

  test(
    'Parse meal plan date from entity',
    () async {
      var date = DateTime(2020, 01, 01);
      var entity = MutableMealPlanDateEntity.empty(date);
      entity.addRecipe(
          MutableMealPlanRecipeEntity.fromValues('1234', 'Recipe', 4));

      var cut = FirebaseMealPlanDate.from(entity);

      expect(isSameDay(cut.date, date), true);
      expect(cut.recipes.length, 1);
      expect(cut.recipes.first.name, 'Recipe');
      expect(cut.recipes.first.servings, 4);
      expect(cut.recipes.first.id, '1234');
    },
  );
  test(
    'Parse meal plan document from Json',
    () async {
      var date = DateTime(2020, 01, 01);
      var dateEntity = MutableMealPlanDateEntity.empty(date);
      dateEntity.addRecipe(
          MutableMealPlanRecipeEntity.fromValues('1234', 'Recipe', 4));

      var json = {
        'groupID': '4567',
        'items': [FirebaseMealPlanDate.from(dateEntity).toJson()]
      };

      var cut = FirebaseMealPlanDocument.fromJson(json, '1234');
      var generatedJson = cut.toJson();

      expect(isSameDay(cut.items.first.date, date), true);
      expect(cut.items.length, 1);
      expect(cut.groupID, '4567');
      expect(cut.items.first.recipes.length, 1);
      expect(cut.items.first.recipes.first.name, 'Recipe');
      expect(cut.items.first.recipes.first.servings, 4);
      expect(cut.items.first.recipes.first.id, '1234');
      expect(generatedJson, json);
    },
  );
}

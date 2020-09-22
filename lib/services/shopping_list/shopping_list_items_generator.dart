import 'package:cookly/model/entities/abstract/meal_plan_entity.dart';
import 'package:cookly/model/entities/abstract/shopping_list_entity.dart';
import 'package:cookly/model/entities/mutable/mutable_shopping_list_item.dart';
import 'package:cookly/services/recipe/ingredients_calculator.dart';
import 'package:cookly/services/meal_plan_manager.dart';
import 'package:cookly/services/flutter/service_locator.dart';

abstract class ShoppingListItemsGenerator {
  /// generate the transient items of the shopping list based on the planned recipes
  Future<List<MutableShoppingListItem>> generateItems(
      ShoppingListEntity entity);
}

class ShoppingListItemsGeneratorImpl implements ShoppingListItemsGenerator {
  @override
  Future<List<MutableShoppingListItem>> generateItems(
      ShoppingListEntity entity) async {
    List<MutableShoppingListItem> items = [];
    Map<String, int> recipeReferences = {};

    // retrieve the meal plan
    var mealPlanEntity = await sl
        .get<MealPlanManager>()
        .getMealPlanByCollectionID(entity.groupID);

    // collect all recipes planned for the given duration
    for (var item in mealPlanEntity.items) {
      if (item.recipes.isNotEmpty && _dateIsMatching(item, entity)) {
        for (var recipe in item.recipes) {
          if (!recipe.isNote) {
            recipeReferences.update(
                recipe.id, (value) => value + recipe.servings,
                ifAbsent: () => recipe.servings);
          }
        }
      }
    }

    // next create a set of the required ingredients
    var ingredients =
        await sl.get<IngredientsCalculator>().getIngredients(recipeReferences);

    // at last create the view model representation of the list of ingredients
    for (var item in ingredients) {
      var itemModel =
          MutableShoppingListItem.ofIngredientNote(item, false, false);
      items.add(itemModel);
    }

    return items;
  }

  bool _dateIsMatching(MealPlanDateEntity item, ShoppingListEntity entity) {
    return item.date.isBefore(entity.dateUntil.add(Duration(days: 1))) &&
        item.date.isAfter(entity.dateFrom.subtract(Duration(days: 1)));
  }
}

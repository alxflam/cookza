import 'package:cookly/model/json/meal_plan.dart';
import 'package:cookly/model/json/recipe_list.dart';
import 'package:cookly/model/json/shopping_lists.dart';
import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

dynamic _recipeListToJson(RecipeList recipes) {
  if (recipes != null) {
    return recipes.toJson();
  }
  return RecipeList();
}

RecipeList _recipeListFromJson(Map<String, dynamic> json) {
  if (json != null && json.isNotEmpty) {
    return RecipeList.fromJson(json);
  }
  return RecipeList();
}

dynamic _mealPlanToJson(MealPlan plan) {
  if (plan != null) {
    return plan.toJson();
  }
  return MealPlan().toJson();
}

MealPlan _mealPlanFromJson(Map<String, dynamic> json) {
  if (json != null && json.isNotEmpty) {
    return MealPlan.fromJson(json);
  }
  return MealPlan();
}

dynamic _shoppingListsToJson(ShoppingLists list) {
  if (list != null) {
    return list.toJson();
  }
  return ShoppingLists().toJson();
}

ShoppingLists _shoppingListsFromJson(Map<String, dynamic> json) {
  if (json != null && json.isNotEmpty) {
    return ShoppingLists.fromJson(json);
  }
  return ShoppingLists();
}

@JsonSerializable()
class Profile {
  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileToJson(this);

  @JsonKey(toJson: _recipeListToJson, fromJson: _recipeListFromJson)
  RecipeList recipeList;

  @JsonKey(toJson: _mealPlanToJson, fromJson: _mealPlanFromJson)
  MealPlan mealPlan;

  @JsonKey(toJson: _shoppingListsToJson, fromJson: _shoppingListsFromJson)
  ShoppingLists shoppingLists;

  Profile({this.recipeList, this.mealPlan}) {
    if (this.recipeList == null) {
      this.recipeList = RecipeList();
    }
    if (this.mealPlan == null) {
      this.mealPlan = MealPlan();
    }
  }
}

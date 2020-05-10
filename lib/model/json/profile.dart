import 'package:cookly/model/json/meal_plan.dart';
import 'package:cookly/model/json/recipe_list.dart';
import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

dynamic _recipeListToJson(RecipeList recipes) {
  return recipes.toJson();
}

dynamic _mealPlanToJson(MealPlan plan) {
  return plan.toJson();
}

@JsonSerializable()
class Profile {
  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileToJson(this);

  @JsonKey(nullable: false, toJson: _recipeListToJson)
  RecipeList recipeList;

  @JsonKey(nullable: false, toJson: _mealPlanToJson)
  MealPlan mealPlan;

  Profile({this.recipeList, this.mealPlan}) {
    if (this.recipeList == null) {
      this.recipeList = RecipeList();
    }
    if (this.mealPlan == null) {
      this.mealPlan = MealPlan();
    }
  }
}

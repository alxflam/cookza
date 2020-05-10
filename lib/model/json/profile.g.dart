// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) {
  return Profile(
    recipeList: RecipeList.fromJson(json['recipeList'] as Map<String, dynamic>),
    mealPlan: MealPlan.fromJson(json['mealPlan'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'recipeList': _recipeListToJson(instance.recipeList),
      'mealPlan': _mealPlanToJson(instance.mealPlan),
    };

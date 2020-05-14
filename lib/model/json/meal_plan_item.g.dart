// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_plan_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MealPlanItem _$MealPlanItemFromJson(Map<String, dynamic> json) {
  return MealPlanItem(
    date: kDateFromJson(json['date'] as String),
    recipeReferences: Map<String, int>.from(json['recipeReferences'] as Map),
  );
}

Map<String, dynamic> _$MealPlanItemToJson(MealPlanItem instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('date', kDateToJson(instance.date));
  val['recipeReferences'] = instance.recipeReferences;
  return val;
}

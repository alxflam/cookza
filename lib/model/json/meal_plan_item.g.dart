// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_plan_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MealPlanItem _$MealPlanItemFromJson(Map<String, dynamic> json) {
  return MealPlanItem(
    creationDate: kDateFromJson(json['creationDate'] as String),
    recipeReference: json['recipeReference'] as String,
  );
}

Map<String, dynamic> _$MealPlanItemToJson(MealPlanItem instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('creationDate', kDateToJson(instance.creationDate));
  val['recipeReference'] = instance.recipeReference;
  return val;
}

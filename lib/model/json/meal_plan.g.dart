// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MealPlan _$MealPlanFromJson(Map<String, dynamic> json) {
  return MealPlan(
    modelVersion: json['modelVersion'] as int,
    items: (json['items'] as List)
        ?.map((e) =>
            e == null ? null : MealPlanItem.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$MealPlanToJson(MealPlan instance) {
  final val = <String, dynamic>{
    'modelVersion': instance.modelVersion,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('items', kListToJson(instance.items));
  return val;
}

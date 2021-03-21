// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_meal_plan_collection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirebaseMealPlanCollection _$FirebaseMealPlanCollectionFromJson(
    Map<String, dynamic> json) {
  return FirebaseMealPlanCollection(
    name: json['name'] as String,
    users: Map<String, String>.from(json['users'] as Map),
  )..creationTimestamp = kTimestampFromJson(json['creationTimestamp']);
}

Map<String, dynamic> _$FirebaseMealPlanCollectionToJson(
    FirebaseMealPlanCollection instance) {
  final val = <String, dynamic>{
    'name': instance.name,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(
      'creationTimestamp', kTimestampToJson(instance.creationTimestamp));
  val['users'] = instance.users;
  return val;
}

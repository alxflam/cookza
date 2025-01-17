// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_meal_plan_collection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirebaseMealPlanCollection _$FirebaseMealPlanCollectionFromJson(
        Map<String, dynamic> json) =>
    FirebaseMealPlanCollection(
      name: json['name'] as String,
      users: Map<String, String>.from(json['users'] as Map),
    )..creationTimestamp = kTimestampFromJson(json['creationTimestamp']);

Map<String, dynamic> _$FirebaseMealPlanCollectionToJson(
        FirebaseMealPlanCollection instance) =>
    <String, dynamic>{
      'name': instance.name,
      if (kTimestampToJson(instance.creationTimestamp) case final value?)
        'creationTimestamp': value,
      'users': instance.users,
    };

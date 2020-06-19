// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_meal_plan_collection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirebaseMealPlanCollection _$FirebaseMealPlanCollectionFromJson(
    Map<String, dynamic> json) {
  return FirebaseMealPlanCollection(
    creationTimestamp: kTimestampFromJson(json['creationTimestamp']),
    users: (json['users'] as List)
        ?.map((e) => e == null
            ? null
            : FirebaseRecipeUser.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$FirebaseMealPlanCollectionToJson(
    FirebaseMealPlanCollection instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(
      'creationTimestamp', kTimestampToJson(instance.creationTimestamp));
  writeNotNull('users', kListToJson(instance.users));
  return val;
}

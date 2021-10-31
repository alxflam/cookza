// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_recipe_collection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirebaseRecipeCollection _$FirebaseRecipeCollectionFromJson(
        Map<String, dynamic> json) =>
    FirebaseRecipeCollection(
      name: json['name'] as String,
      creationTimestamp: kTimestampFromJson(json['creationTimestamp']),
      users: Map<String, String>.from(json['users'] as Map),
    );

Map<String, dynamic> _$FirebaseRecipeCollectionToJson(
    FirebaseRecipeCollection instance) {
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

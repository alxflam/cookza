// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_collection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecipeCollection _$RecipeCollectionFromJson(Map<String, dynamic> json) {
  return RecipeCollection(
    id: json['id'] as String,
    name: json['name'] as String,
  )..creationTimestamp = kTimestampFromJson(json['creationTimestamp']);
}

Map<String, dynamic> _$RecipeCollectionToJson(RecipeCollection instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'name': instance.name,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(
      'creationTimestamp', kTimestampToJson(instance.creationTimestamp));
  return val;
}

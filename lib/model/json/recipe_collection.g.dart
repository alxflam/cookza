// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_collection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecipeCollection _$RecipeCollectionFromJson(Map<String, dynamic> json) =>
    RecipeCollection(
      id: json['id'] as String,
      name: json['name'] as String,
    )..creationTimestamp = kTimestampFromJson(json['creationTimestamp']);

Map<String, dynamic> _$RecipeCollectionToJson(RecipeCollection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      if (kTimestampToJson(instance.creationTimestamp) case final value?)
        'creationTimestamp': value,
    };

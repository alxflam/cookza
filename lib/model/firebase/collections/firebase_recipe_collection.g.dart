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
        FirebaseRecipeCollection instance) =>
    <String, dynamic>{
      'name': instance.name,
      if (kTimestampToJson(instance.creationTimestamp) case final value?)
        'creationTimestamp': value,
      'users': instance.users,
    };

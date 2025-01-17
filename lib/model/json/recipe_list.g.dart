// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecipeList _$RecipeListFromJson(Map<String, dynamic> json) => RecipeList(
      recipes: (json['recipes'] as List<dynamic>)
          .map((e) => Recipe.fromJson(e as Map<String, dynamic>))
          .toList(),
    )..modelVersion = (json['modelVersion'] as num).toInt();

Map<String, dynamic> _$RecipeListToJson(RecipeList instance) =>
    <String, dynamic>{
      'modelVersion': instance.modelVersion,
      if (kListToJson(instance.recipes) case final value?) 'recipes': value,
    };

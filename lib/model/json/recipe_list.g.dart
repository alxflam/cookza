// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecipeList _$RecipeListFromJson(Map<String, dynamic> json) => RecipeList(
      recipes: (json['recipes'] as List<dynamic>)
          .map((e) => Recipe.fromJson(e as Map<String, dynamic>))
          .toList(),
    )..modelVersion = json['modelVersion'] as int;

Map<String, dynamic> _$RecipeListToJson(RecipeList instance) {
  final val = <String, dynamic>{
    'modelVersion': instance.modelVersion,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('recipes', kListToJson(instance.recipes));
  return val;
}

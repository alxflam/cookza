// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recipe _$RecipeFromJson(Map<String, dynamic> json) => Recipe(
      id: json['id'] as String,
      recipeCollection: json['recipeCollection'] as String,
      name: json['name'] as String,
      shortDescription: json['shortDescription'] as String? ?? '',
      creationDate: kDateFromJson(json['creationDate'] as String),
      modificationDate: kDateFromJson(json['modificationDate'] as String),
      duration: (json['duration'] as num).toInt(),
      diff: $enumDecodeNullable(_$DIFFICULTYEnumMap, json['diff']) ??
          DIFFICULTY.MEDIUM,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      ingredientGroups: (json['ingredientGroups'] as List<dynamic>)
          .map((e) => IngredientGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
      instructions: (json['instructions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      servings: (json['servings'] as num?)?.toInt() ?? 1,
      serializedImage: json['serializedImage'] as String?,
    );

Map<String, dynamic> _$RecipeToJson(Recipe instance) => <String, dynamic>{
      'id': instance.id,
      'recipeCollection': instance.recipeCollection,
      'creationDate': kDateToJson(instance.creationDate),
      'modificationDate': kDateToJson(instance.modificationDate),
      'name': instance.name,
      if (instance.shortDescription case final value?)
        'shortDescription': value,
      'duration': instance.duration,
      'servings': instance.servings,
      if (instance.serializedImage case final value?) 'serializedImage': value,
      'diff': _$DIFFICULTYEnumMap[instance.diff]!,
      'tags': instance.tags,
      if (kListToJson(instance.ingredientGroups) case final value?)
        'ingredientGroups': value,
      'instructions': instance.instructions,
    };

const _$DIFFICULTYEnumMap = {
  DIFFICULTY.EASY: 'EASY',
  DIFFICULTY.MEDIUM: 'MEDIUM',
  DIFFICULTY.HARD: 'HARD',
};

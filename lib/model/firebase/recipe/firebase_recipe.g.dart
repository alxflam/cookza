// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirebaseRecipe _$FirebaseRecipeFromJson(Map<String, dynamic> json) =>
    FirebaseRecipe(
      ingredientsID: json['ingredientsID'] as String?,
      instructionsID: json['instructionsID'] as String?,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      creationDate: kTimestampFromJson(json['creationDate']),
      modificationDate: kTimestampFromJson(json['modificationDate']),
      duration: (json['duration'] as num).toInt(),
      difficulty:
          $enumDecodeNullable(_$DIFFICULTYEnumMap, json['difficulty']) ??
              DIFFICULTY.MEDIUM,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      servings: (json['servings'] as num?)?.toInt() ?? 1,
      image: json['image'] as String?,
      recipeGroupID: json['recipeGroupID'] as String,
    );

Map<String, dynamic> _$FirebaseRecipeToJson(FirebaseRecipe instance) =>
    <String, dynamic>{
      if (kTimestampToJson(instance.creationDate) case final value?)
        'creationDate': value,
      if (kTimestampToJson(instance.modificationDate) case final value?)
        'modificationDate': value,
      if (instance.ingredientsID case final value?) 'ingredientsID': value,
      if (instance.instructionsID case final value?) 'instructionsID': value,
      'name': instance.name,
      if (instance.description case final value?) 'description': value,
      'duration': instance.duration,
      'servings': instance.servings,
      if (instance.image case final value?) 'image': value,
      'recipeGroupID': instance.recipeGroupID,
      'difficulty': _$DIFFICULTYEnumMap[instance.difficulty]!,
      'tags': instance.tags,
    };

const _$DIFFICULTYEnumMap = {
  DIFFICULTY.EASY: 'EASY',
  DIFFICULTY.MEDIUM: 'MEDIUM',
  DIFFICULTY.HARD: 'HARD',
};

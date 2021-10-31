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
      duration: json['duration'] as int,
      diff: $enumDecodeNullable(_$DIFFICULTYEnumMap, json['diff']) ??
          DIFFICULTY.MEDIUM,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      ingredientGroups: (json['ingredientGroups'] as List<dynamic>)
          .map((e) => IngredientGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
      instructions: (json['instructions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      servings: json['servings'] as int? ?? 1,
      serializedImage: json['serializedImage'] as String?,
    );

Map<String, dynamic> _$RecipeToJson(Recipe instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'recipeCollection': instance.recipeCollection,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('creationDate', kDateToJson(instance.creationDate));
  writeNotNull('modificationDate', kDateToJson(instance.modificationDate));
  val['name'] = instance.name;
  writeNotNull('shortDescription', instance.shortDescription);
  val['duration'] = instance.duration;
  val['servings'] = instance.servings;
  writeNotNull('serializedImage', instance.serializedImage);
  val['diff'] = _$DIFFICULTYEnumMap[instance.diff];
  val['tags'] = instance.tags;
  writeNotNull('ingredientGroups', kListToJson(instance.ingredientGroups));
  val['instructions'] = instance.instructions;
  return val;
}

const _$DIFFICULTYEnumMap = {
  DIFFICULTY.EASY: 'EASY',
  DIFFICULTY.MEDIUM: 'MEDIUM',
  DIFFICULTY.HARD: 'HARD',
};

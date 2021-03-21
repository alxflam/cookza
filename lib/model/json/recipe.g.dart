// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recipe _$RecipeFromJson(Map<String, dynamic> json) {
  return Recipe(
    id: json['id'] as String,
    recipeCollection: json['recipeCollection'] as String,
    name: json['name'] as String,
    shortDescription: json['shortDescription'] as String? ?? '',
    creationDate: kDateFromJson(json['creationDate'] as String),
    modificationDate: kDateFromJson(json['modificationDate'] as String),
    duration: json['duration'] as int,
    diff: _$enumDecodeNullable(_$DIFFICULTYEnumMap, json['diff']) ??
        DIFFICULTY.MEDIUM,
    tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
    ingredients: (json['ingredients'] as List<dynamic>)
        .map((e) => IngredientNote.fromJson(e as Map<String, dynamic>))
        .toList(),
    instructions: (json['instructions'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
    rating: json['rating'] as int? ?? 0,
    servings: json['servings'] as int? ?? 1,
    serializedImage: json['serializedImage'] as String?,
  );
}

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
  val['shortDescription'] = instance.shortDescription;
  val['duration'] = instance.duration;
  val['rating'] = instance.rating;
  val['servings'] = instance.servings;
  writeNotNull('serializedImage', instance.serializedImage);
  val['diff'] = _$DIFFICULTYEnumMap[instance.diff];
  val['tags'] = instance.tags;
  writeNotNull('ingredients', kListToJson(instance.ingredients));
  val['instructions'] = instance.instructions;
  return val;
}

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$DIFFICULTYEnumMap = {
  DIFFICULTY.EASY: 'EASY',
  DIFFICULTY.MEDIUM: 'MEDIUM',
  DIFFICULTY.HARD: 'HARD',
};

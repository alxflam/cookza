// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirebaseRecipe _$FirebaseRecipeFromJson(Map<String, dynamic> json) {
  return FirebaseRecipe(
    ingredientsID: json['ingredientsID'] as String,
    instructionsID: json['instructionsID'] as String,
    name: json['name'] as String,
    description: json['description'] as String ?? '',
    creationDate: kTimestampFromJson(json['creationDate']),
    modificationDate: kTimestampFromJson(json['modificationDate']),
    duration: json['duration'] as int,
    difficulty: _$enumDecodeNullable(_$DIFFICULTYEnumMap, json['difficulty']) ??
        DIFFICULTY.MEDIUM,
    tags: (json['tags'] as List).map((e) => e as String).toList(),
    rating: json['rating'] as int ?? 0,
    servings: json['servings'] as int ?? 1,
    image: json['image'] as String,
    recipeGroupId: json['recipeGroupId'] as String,
  );
}

Map<String, dynamic> _$FirebaseRecipeToJson(FirebaseRecipe instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('creationDate', kTimestampToJson(instance.creationDate));
  writeNotNull('modificationDate', kTimestampToJson(instance.modificationDate));
  val['ingredientsID'] = instance.ingredientsID;
  val['instructionsID'] = instance.instructionsID;
  val['name'] = instance.name;
  writeNotNull('description', instance.description);
  val['duration'] = instance.duration;
  writeNotNull('rating', instance.rating);
  writeNotNull('servings', instance.servings);
  writeNotNull('image', instance.image);
  val['recipeGroupId'] = instance.recipeGroupId;
  writeNotNull('difficulty', _$DIFFICULTYEnumMap[instance.difficulty]);
  val['tags'] = instance.tags;
  return val;
}

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$DIFFICULTYEnumMap = {
  DIFFICULTY.EASY: 'EASY',
  DIFFICULTY.MEDIUM: 'MEDIUM',
  DIFFICULTY.HARD: 'HARD',
};

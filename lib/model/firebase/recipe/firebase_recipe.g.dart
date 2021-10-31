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
      duration: json['duration'] as int,
      difficulty:
          $enumDecodeNullable(_$DIFFICULTYEnumMap, json['difficulty']) ??
              DIFFICULTY.MEDIUM,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      servings: json['servings'] as int? ?? 1,
      image: json['image'] as String?,
      recipeGroupID: json['recipeGroupID'] as String,
    );

Map<String, dynamic> _$FirebaseRecipeToJson(FirebaseRecipe instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('creationDate', kTimestampToJson(instance.creationDate));
  writeNotNull('modificationDate', kTimestampToJson(instance.modificationDate));
  writeNotNull('ingredientsID', instance.ingredientsID);
  writeNotNull('instructionsID', instance.instructionsID);
  val['name'] = instance.name;
  writeNotNull('description', instance.description);
  val['duration'] = instance.duration;
  val['servings'] = instance.servings;
  writeNotNull('image', instance.image);
  val['recipeGroupID'] = instance.recipeGroupID;
  val['difficulty'] = _$DIFFICULTYEnumMap[instance.difficulty];
  val['tags'] = instance.tags;
  return val;
}

const _$DIFFICULTYEnumMap = {
  DIFFICULTY.EASY: 'EASY',
  DIFFICULTY.MEDIUM: 'MEDIUM',
  DIFFICULTY.HARD: 'HARD',
};

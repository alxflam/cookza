// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IngredientGroup _$IngredientGroupFromJson(Map<String, dynamic> json) =>
    IngredientGroup(
      name: json['name'] as String,
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((e) => IngredientNote.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$IngredientGroupToJson(IngredientGroup instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('ingredients', kListToJson(instance.ingredients));
  val['name'] = instance.name;
  return val;
}

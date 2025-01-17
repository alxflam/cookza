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

Map<String, dynamic> _$IngredientGroupToJson(IngredientGroup instance) =>
    <String, dynamic>{
      if (kListToJson(instance.ingredients) case final value?)
        'ingredients': value,
      'name': instance.name,
    };

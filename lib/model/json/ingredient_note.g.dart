// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient_note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IngredientNote _$IngredientNoteFromJson(Map<String, dynamic> json) =>
    IngredientNote(
      ingredient:
          Ingredient.fromJson(json['ingredient'] as Map<String, dynamic>),
      unitOfMeasure: json['unitOfMeasure'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$IngredientNoteToJson(IngredientNote instance) =>
    <String, dynamic>{
      if (_toJson(instance.ingredient) case final value?) 'ingredient': value,
      if (instance.unitOfMeasure case final value?) 'unitOfMeasure': value,
      if (instance.amount case final value?) 'amount': value,
    };

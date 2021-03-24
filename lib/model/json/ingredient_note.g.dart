// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient_note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IngredientNote _$IngredientNoteFromJson(Map<String, dynamic> json) {
  return IngredientNote(
    ingredient: Ingredient.fromJson(json['ingredient'] as Map<String, dynamic>),
    unitOfMeasure: json['unitOfMeasure'] as String? ?? '',
    amount: (json['amount'] as num?)?.toDouble(),
  );
}

Map<String, dynamic> _$IngredientNoteToJson(IngredientNote instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('ingredient', _toJson(instance.ingredient));
  writeNotNull('unitOfMeasure', instance.unitOfMeasure);
  writeNotNull('amount', instance.amount);
  return val;
}

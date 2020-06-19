// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_ingredient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirebaseIngredient _$FirebaseIngredientFromJson(Map<String, dynamic> json) {
  return FirebaseIngredient(
    ingredient: json['ingredient'] == null
        ? null
        : Ingredient.fromJson(json['ingredient'] as Map<String, dynamic>),
    unitOfMeasure: json['unitOfMeasure'] as String ?? '',
    amount: (json['amount'] as num).toDouble(),
  );
}

Map<String, dynamic> _$FirebaseIngredientToJson(FirebaseIngredient instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('ingredient', _toJson(instance.ingredient));
  writeNotNull('unitOfMeasure', instance.unitOfMeasure);
  val['amount'] = instance.amount;
  return val;
}

FirebaseIngredientDocument _$FirebaseIngredientDocumentFromJson(
    Map<String, dynamic> json) {
  return FirebaseIngredientDocument(
    recipeID: json['recipeID'] as String,
    ingredients: (json['ingredients'] as List)
        ?.map((e) => e == null
            ? null
            : FirebaseIngredient.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$FirebaseIngredientDocumentToJson(
    FirebaseIngredientDocument instance) {
  final val = <String, dynamic>{
    'recipeID': instance.recipeID,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('ingredients', kListToJson(instance.ingredients));
  return val;
}

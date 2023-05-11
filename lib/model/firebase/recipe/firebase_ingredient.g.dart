// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_ingredient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirebaseIngredient _$FirebaseIngredientFromJson(Map<String, dynamic> json) =>
    FirebaseIngredient(
      ingredient:
          Ingredient.fromJson(json['ingredient'] as Map<String, dynamic>),
      amount: (json['amount'] as num?)?.toDouble(),
      unitOfMeasure: json['unitOfMeasure'] as String? ?? '',
    );

Map<String, dynamic> _$FirebaseIngredientToJson(FirebaseIngredient instance) {
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

FirebaseIngredientGroup _$FirebaseIngredientGroupFromJson(
        Map<String, dynamic> json) =>
    FirebaseIngredientGroup(
      name: json['name'] as String,
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((e) => FirebaseIngredient.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FirebaseIngredientGroupToJson(
    FirebaseIngredientGroup instance) {
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

FirebaseIngredientDocument _$FirebaseIngredientDocumentFromJson(
        Map<String, dynamic> json) =>
    FirebaseIngredientDocument(
      recipeID: json['recipeID'] as String,
      ingredients: (json['ingredients'] as List<dynamic>?)
          ?.map((e) => FirebaseIngredient.fromJson(e as Map<String, dynamic>))
          .toList(),
      groups: (json['groups'] as List<dynamic>?)
          ?.map((e) =>
              FirebaseIngredientGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

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
  writeNotNull('groups', kListToJson(instance.groups));
  return val;
}

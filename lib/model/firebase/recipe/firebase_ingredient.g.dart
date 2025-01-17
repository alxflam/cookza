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

Map<String, dynamic> _$FirebaseIngredientToJson(FirebaseIngredient instance) =>
    <String, dynamic>{
      if (_toJson(instance.ingredient) case final value?) 'ingredient': value,
      if (instance.unitOfMeasure case final value?) 'unitOfMeasure': value,
      if (instance.amount case final value?) 'amount': value,
    };

FirebaseIngredientGroup _$FirebaseIngredientGroupFromJson(
        Map<String, dynamic> json) =>
    FirebaseIngredientGroup(
      name: json['name'] as String,
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((e) => FirebaseIngredient.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FirebaseIngredientGroupToJson(
        FirebaseIngredientGroup instance) =>
    <String, dynamic>{
      if (kListToJson(instance.ingredients) case final value?)
        'ingredients': value,
      'name': instance.name,
    };

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
        FirebaseIngredientDocument instance) =>
    <String, dynamic>{
      'recipeID': instance.recipeID,
      if (kListToJson(instance.ingredients) case final value?)
        'ingredients': value,
      if (kListToJson(instance.groups) case final value?) 'groups': value,
    };

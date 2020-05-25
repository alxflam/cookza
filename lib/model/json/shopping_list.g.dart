// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShoppingList _$ShoppingListFromJson(Map<String, dynamic> json) {
  return ShoppingList(
    dateFrom: kDateFromJson(json['dateFrom'] as String),
    dateEnd: kDateFromJson(json['dateEnd'] as String),
  )
    ..recipeReferences = Map<String, int>.from(json['recipeReferences'] as Map)
    ..availableIngredients = (json['availableIngredients'] as List)
        ?.map((e) => e == null
            ? null
            : IngredientNote.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$ShoppingListToJson(ShoppingList instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('dateFrom', kDateToJson(instance.dateFrom));
  writeNotNull('dateEnd', kDateToJson(instance.dateEnd));
  val['recipeReferences'] = instance.recipeReferences;
  writeNotNull(
      'availableIngredients', kListToJson(instance.availableIngredients));
  return val;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_lists.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShoppingLists _$ShoppingListsFromJson(Map<String, dynamic> json) {
  return ShoppingLists(
    modelVersion: json['modelVersion'] as int,
    items: (json['items'] as List)
        ?.map((e) =>
            e == null ? null : ShoppingList.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ShoppingListsToJson(ShoppingLists instance) {
  final val = <String, dynamic>{
    'modelVersion': instance.modelVersion,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('items', kListToJson(instance.items));
  return val;
}

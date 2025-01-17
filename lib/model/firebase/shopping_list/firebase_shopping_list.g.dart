// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_shopping_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirebaseShoppingListItem _$FirebaseShoppingListItemFromJson(
        Map<String, dynamic> json) =>
    FirebaseShoppingListItem(
      ingredient: FirebaseIngredient.fromJson(
          json['ingredient'] as Map<String, dynamic>),
      bought: json['bought'] as bool? ?? false,
      customItem: json['customItem'] as bool? ?? false,
      index: (json['index'] as num?)?.toInt(),
    );

Map<String, dynamic> _$FirebaseShoppingListItemToJson(
        FirebaseShoppingListItem instance) =>
    <String, dynamic>{
      if (_toJson(instance.ingredient) case final value?) 'ingredient': value,
      'bought': instance.bought,
      'customItem': instance.customItem,
      if (instance.index case final value?) 'index': value,
    };

FirebaseShoppingListDocument _$FirebaseShoppingListDocumentFromJson(
        Map<String, dynamic> json) =>
    FirebaseShoppingListDocument(
      items: (json['items'] as List<dynamic>)
          .map((e) =>
              FirebaseShoppingListItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      groupID: json['groupID'] as String,
      dateFrom: kDateFromJson(json['dateFrom'] as String),
      dateUntil: kDateFromJson(json['dateUntil'] as String),
    );

Map<String, dynamic> _$FirebaseShoppingListDocumentToJson(
        FirebaseShoppingListDocument instance) =>
    <String, dynamic>{
      if (kListToJson(instance.items) case final value?) 'items': value,
      'dateFrom': kDateToJson(instance.dateFrom),
      'dateUntil': kDateToJson(instance.dateUntil),
      'groupID': instance.groupID,
    };

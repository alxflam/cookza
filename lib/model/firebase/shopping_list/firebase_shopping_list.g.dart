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
      index: json['index'] as int?,
    );

Map<String, dynamic> _$FirebaseShoppingListItemToJson(
    FirebaseShoppingListItem instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('ingredient', _toJson(instance.ingredient));
  val['bought'] = instance.bought;
  val['customItem'] = instance.customItem;
  writeNotNull('index', instance.index);
  return val;
}

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
    FirebaseShoppingListDocument instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('items', kListToJson(instance.items));
  writeNotNull('dateFrom', kDateToJson(instance.dateFrom));
  writeNotNull('dateUntil', kDateToJson(instance.dateUntil));
  val['groupID'] = instance.groupID;
  return val;
}

import 'dart:collection';

import 'package:cookly/model/entities/abstract/shopping_list_entity.dart';

class MutableShoppingList implements ShoppingListEntity {
  DateTime _from;
  DateTime _until;
  String _groupID;
  String _documentID;
  List<ShoppingListItemEntity> _items = [];

  MutableShoppingList.newList(String groupID, DateTime from, DateTime until) {
    this._groupID = groupID;
    this._from = from;
    this._until = until;
  }

  MutableShoppingList.ofValues(DateTime from, DateTime until, String groupID,
      List<ShoppingListItemEntity> items) {
    this._from = from;
    this._until = until;
    this._groupID = groupID;
    this._items = items;
  }

  MutableShoppingList.of(ShoppingListEntity entity) {
    this._from = entity.dateFrom;
    this._until = entity.dateUntil;
    this._documentID = entity.id;
    this._groupID = entity.groupID;
    this._items.addAll(entity.items);
  }

  @override
  DateTime get dateFrom => this._from;

  @override
  DateTime get dateUntil => this._until;

  @override
  String get groupID => this._groupID;

  set groupID(String value) => this._groupID = value;

  @override
  String get id => this._documentID;

  @override
  List<ShoppingListItemEntity> get items => UnmodifiableListView(_items);

  void addItem(ShoppingListItemEntity item) {
    this._items.add(item);
  }

  set dateFrom(DateTime value) {
    this._from = value;
  }

  set dateUntil(DateTime value) {
    this._until = value;
  }

  void clearItems() {
    this._items.clear();
  }

  void removeBought() {
    this._items.removeWhere((e) => e.isBought);
  }

  void removeItem(ShoppingListItemEntity entity) {
    this._items.remove(entity);
  }
}

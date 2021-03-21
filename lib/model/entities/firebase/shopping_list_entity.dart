import 'package:cookza/model/entities/abstract/ingredient_note_entity.dart';
import 'package:cookza/model/entities/abstract/shopping_list_entity.dart';
import 'package:cookza/model/entities/firebase/ingredient_note_entity.dart';
import 'package:cookza/model/firebase/shopping_list/firebase_shopping_list.dart';

class ShoppingListItemEntityFirebase implements ShoppingListItemEntity {
  bool _isCustom;
  bool _isBought;
  IngredientNoteEntityFirebase _ingredient;
  int? _index;

  ShoppingListItemEntityFirebase.of(FirebaseShoppingListItem item)
      : this._index = item.index,
        this._isCustom = item.customItem,
        this._isBought = item.bought,
        this._ingredient = IngredientNoteEntityFirebase.of(item.ingredient);

  @override
  int? get index => this._index;

  @override
  IngredientNoteEntity get ingredientNote => this._ingredient;

  @override
  bool get isBought => this._isBought;

  @override
  bool get isCustom => this._isCustom;
}

class ShoppingListEntityFirebase implements ShoppingListEntity {
  List<ShoppingListItemEntityFirebase> _items;
  String? _id;
  String _groupID;
  DateTime _dateFrom;
  DateTime _dateUntil;

  ShoppingListEntityFirebase.of(FirebaseShoppingListDocument document)
      : this._id = document.documentID,
        this._groupID = document.groupID,
        this._items = document.items
            .map((e) => ShoppingListItemEntityFirebase.of(e))
            .toList(),
        this._dateFrom = document.dateFrom,
        this._dateUntil = document.dateUntil;

  @override
  List<ShoppingListItemEntityFirebase> get items => this._items;

  @override
  String? get id => this._id;

  @override
  String get groupID => this._groupID;

  @override
  DateTime get dateFrom => this._dateFrom;

  @override
  DateTime get dateUntil => this._dateUntil;
}

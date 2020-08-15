import 'package:cookly/model/entities/abstract/ingredient_note_entity.dart';

abstract class ShoppingListItemEntity {
  int get index;
  bool get isBought;
  bool get isCustom;
  IngredientNoteEntity get ingredientNote;
}

abstract class ShoppingListEntity {
  List<ShoppingListItemEntity> get items;
  DateTime get dateFrom;
  DateTime get dateUntil;
  String get groupID;
  String get id;
}

import 'package:cookly/model/entities/abstract/ingredient_note_entity.dart';
import 'package:cookly/model/entities/abstract/shopping_list_entity.dart';
import 'package:cookly/model/entities/mutable/mutable_ingredient.dart';
import 'package:cookly/model/entities/mutable/mutable_ingredient_note.dart';
import 'package:cookly/model/json/ingredient_note.dart';
import 'package:cookly/viewmodel/shopping_list/shopping_list_detail.dart';

class MutableShoppingListItem implements ShoppingListItemEntity {
  MutableIngredientNote _ingredientNote;
  bool _isBought;
  bool _isCustom;
  int _index;

  MutableShoppingListItem.ofEntity(ShoppingListItemEntity entity) {
    this._ingredientNote = MutableIngredientNote.of(entity.ingredientNote);
    this._isBought = entity.isBought;
    this._isCustom = entity.isCustom;
  }

  MutableShoppingListItem.ofIngredientNote(
      IngredientNoteEntity note, bool isBought, bool isCustom) {
    this._ingredientNote = MutableIngredientNote.of(note);
    this._isBought = isBought;
    this._isCustom = isCustom;
  }

  MutableShoppingListItem.of(ShoppingListItemModel model) {
    this._ingredientNote =
        MutableIngredientNote.of(model.toIngredientNoteEntity());
    this._isBought = model.isNoLongerNeeded;
    this._isCustom = model.isCustomItem;
  }

  @override
  int get index => this._index;

  @override
  MutableIngredientNote get ingredientNote => this._ingredientNote;

  @override
  bool get isBought => this._isBought;

  @override
  bool get isCustom => this._isCustom;

  set isCustom(bool value) => this._isCustom = value;

  set isBought(bool value) => this._isBought = value;
}
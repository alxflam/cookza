import 'package:cookza/model/entities/abstract/ingredient_note_entity.dart';
import 'package:cookza/model/entities/abstract/shopping_list_entity.dart';
import 'package:cookza/model/entities/mutable/mutable_ingredient_note.dart';

class MutableShoppingListItem implements ShoppingListItemEntity {
  MutableIngredientNote _ingredientNote;
  bool _isBought;
  bool _isCustom;
  int _index = -1;

  MutableShoppingListItem.ofEntity(ShoppingListItemEntity entity)
      : this._ingredientNote = MutableIngredientNote.of(entity.ingredientNote),
        this._isBought = entity.isBought,
        this._isCustom = entity.isCustom,
        this._index = entity.index ?? -1;

  MutableShoppingListItem.ofIngredientNote(
      IngredientNoteEntity note, bool isBought, bool isCustom)
      : this._ingredientNote = MutableIngredientNote.of(note),
        this._isBought = isBought,
        this._isCustom = isCustom;

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

  set index(int value) => this._index = value;
}

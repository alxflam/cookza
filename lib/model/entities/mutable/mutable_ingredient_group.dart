import 'package:cookza/model/entities/abstract/ingredient_group_entity.dart';
import 'package:cookza/model/entities/abstract/ingredient_note_entity.dart';

class MutableIngredientGroup implements IngredientGroupEntity {
  int _index = 0;
  String _name = '';
  List<IngredientNoteEntity> _ingredients = [];

  MutableIngredientGroup.forValues(this._index, this._name, this._ingredients);

  @override
  int get index => this._index;

  @override
  List<IngredientNoteEntity> get ingredients => this._ingredients;

  @override
  String get name => this._name;

  set name(String value) => this._name = value;

  set index(int value) => this._index = value;
}

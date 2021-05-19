import 'package:cookza/model/entities/abstract/ingredient_note_entity.dart';

abstract class IngredientGroupEntity {
  String get name;
  int get index;
  List<IngredientNoteEntity> get ingredients;
}

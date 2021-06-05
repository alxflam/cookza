import 'package:cookza/model/entities/abstract/ingredient_group_entity.dart';
import 'package:cookza/model/entities/abstract/ingredient_note_entity.dart';
import 'package:cookza/model/entities/firebase/ingredient_note_entity.dart';
import 'package:cookza/model/firebase/recipe/firebase_ingredient.dart';

class IngredientGroupEntityFirebase implements IngredientGroupEntity {
  @override
  final int index = 1;
  @override
  final String name;
  final List<FirebaseIngredient> _ingredients;

  IngredientGroupEntityFirebase(this._ingredients, {required this.name});

  @override
  List<IngredientNoteEntity> get ingredients =>
      this._ingredients.map((e) => IngredientNoteEntityFirebase.of(e)).toList();
}

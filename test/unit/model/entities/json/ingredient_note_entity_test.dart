import 'package:cookza/model/entities/json/ingredient_note_entity.dart';
import 'package:cookza/model/entities/mutable/mutable_ingredient_note.dart';
import 'package:cookza/model/json/ingredient_note.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'Empty note',
    () async {
      var cut = IngredientNoteEntityJson.empty();

      expect(cut.amount, 0);
      expect(cut.ingredient.name, '');
      expect(cut.unitOfMeasure, '');
    },
  );

  test(
    'From Ingredient',
    () async {
      var entity = MutableIngredientNote.empty();
      entity.amount = 2;
      entity.unitOfMeasure = 'GRM';
      entity.ingredient.name = 'Test';
      var note = IngredientNote.fromEntity(entity);
      var cut = IngredientNoteEntityJson.of(note);

      expect(cut.amount, 2);
      expect(cut.ingredient.name, 'Test');
      expect(cut.unitOfMeasure, 'GRM');
    },
  );
}

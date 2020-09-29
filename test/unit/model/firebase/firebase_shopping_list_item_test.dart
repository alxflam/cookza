import 'package:cookza/model/entities/mutable/mutable_ingredient_note.dart';
import 'package:cookza/model/entities/mutable/mutable_shopping_list_item.dart';
import 'package:cookza/model/firebase/shopping_list/firebase_shopping_list.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'Shopping list document from and to JSON',
    () async {
      var ingredient = MutableIngredientNote.empty();
      ingredient.name = 'Test';
      var entity =
          MutableShoppingListItem.ofIngredientNote(ingredient, true, true);
      var cut = FirebaseShoppingListItem.from(entity);

      expect(cut.bought, true);
      expect(cut.customItem, true);
      expect(cut.ingredient.ingredient.name, 'Test');
    },
  );
}

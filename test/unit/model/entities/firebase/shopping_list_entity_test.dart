import 'package:cookly/model/entities/firebase/shopping_list_entity.dart';
import 'package:cookly/model/firebase/recipe/firebase_ingredient.dart';
import 'package:cookly/model/firebase/shopping_list/firebase_shopping_list.dart';
import 'package:cookly/model/json/ingredient.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'create a list item',
    () async {
      FirebaseShoppingListItem pepper = createPepperItem();
      var cut = ShoppingListItemEntityFirebase.of(pepper);

      expect(cut.isBought, false);
      expect(cut.index, null);
      expect(cut.isCustom, false);
      expect(cut.ingredientNote.amount, 2);
      expect(cut.ingredientNote.unitOfMeasure, 'KGM');
      expect(cut.ingredientNote.ingredient.name, 'Pepper');
    },
  );

  test(
    'create a shopping list',
    () async {
      var from = DateTime.now();
      var until = from.add(Duration(days: 7));
      List<FirebaseShoppingListItem> items = [];
      FirebaseShoppingListItem pepper = createPepperItem();
      items.add(pepper);

      var doc = FirebaseShoppingListDocument(
          documentID: '1234',
          dateFrom: from,
          dateUntil: until,
          groupID: 'GROUPID',
          items: items);
      var cut = ShoppingListEntityFirebase.of(doc);

      expect(cut.dateFrom, from);
      expect(cut.dateUntil, until);
      expect(cut.groupID, 'GROUPID');
      expect(cut.id, '1234');
      expect(cut.items.length, 1);
      expect(cut.items.first.ingredientNote.ingredient.name, 'Pepper');
    },
  );
}

FirebaseShoppingListItem createPepperItem() {
  var item = FirebaseShoppingListItem(
      bought: false,
      customItem: false,
      ingredient: FirebaseIngredient(
          amount: 2,
          unitOfMeasure: 'KGM',
          ingredient: Ingredient(name: 'Pepper')));
  return item;
}

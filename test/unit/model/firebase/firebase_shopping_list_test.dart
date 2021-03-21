import 'package:cookza/model/entities/mutable/mutable_ingredient.dart';
import 'package:cookza/model/entities/mutable/mutable_shopping_list.dart';
import 'package:cookza/model/entities/mutable/mutable_shopping_list_item.dart';
import 'package:cookza/model/firebase/recipe/firebase_ingredient.dart';
import 'package:cookza/model/firebase/shopping_list/firebase_shopping_list.dart';
import 'package:cookza/model/json/ingredient.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../utils/recipe_creator.dart';

void main() {
  test(
    'Shopping list item from and to JSON',
    () async {
      var pepper = MutableIngredient.empty();
      pepper.name = 'Pepper';
      var json = {
        'customItem': true,
        'bought': false,
        'index': 2,
        'ingredient': FirebaseIngredient(
                amount: 2,
                unitOfMeasure: 'KGM',
                ingredient: Ingredient.fromEntity(pepper))
            .toJson()
      };
      var cut = FirebaseShoppingListItem.fromJson(json);
      var generatedJson = cut.toJson();

      expect(generatedJson, json);
    },
  );

  test(
    'Shopping list document from and to JSON',
    () async {
      var pepper = MutableIngredient.empty();
      pepper.name = 'Pepper';
      var json = {
        'dateFrom': '01.01.2020',
        'dateUntil': '02.02.2020',
        'groupID': '4567',
        'items': [
          {
            'customItem': true,
            'bought': false,
            'index': 2,
            'ingredient': FirebaseIngredient(
                    amount: 2,
                    unitOfMeasure: 'KGM',
                    ingredient: Ingredient.fromEntity(pepper))
                .toJson()
          }
        ]
      };
      var cut = FirebaseShoppingListDocument.fromJson(json, '1234');
      var generatedJson = cut.toJson();

      expect(generatedJson, json);
    },
  );

  test(
    'Shopping list document static factory method',
    () async {
      var startDate = DateTime.now();
      var endDate = startDate.add(Duration(days: 7));
      var entity = MutableShoppingList.ofValues(startDate, endDate, 'id', []);

      var onion =
          RecipeCreator.createIngredient('Onion', amount: 2, uom: 'PCS');

      var item = MutableShoppingListItem.ofIngredientNote(onion, false, false);

      entity.addItem(item);
      var cut = FirebaseShoppingListDocument.from(entity);

      expect(cut.dateFrom, startDate);
      expect(cut.items.length, 1);
      expect(cut.items.first.ingredient.ingredient.name, 'Onion');
    },
  );
}

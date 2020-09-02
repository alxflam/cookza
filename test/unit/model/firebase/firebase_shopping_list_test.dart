import 'package:cookly/model/entities/mutable/mutable_ingredient.dart';
import 'package:cookly/model/firebase/recipe/firebase_ingredient.dart';
import 'package:cookly/model/firebase/shopping_list/firebase_shopping_list.dart';
import 'package:cookly/model/json/ingredient.dart';
import 'package:flutter_test/flutter_test.dart';

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
}

import 'package:cookza/model/entities/mutable/mutable_ingredient_note.dart';
import 'package:cookza/model/entities/mutable/mutable_shopping_list_item.dart';
import 'package:cookza/services/shopping_list/shopping_list_text_generator.dart';
import 'package:cookza/services/unit_of_measure.dart';
import 'package:cookza/viewmodel/shopping_list/shopping_list_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/uom_provider_mock.dart';

class ShoppingListModelMock extends Mock implements ShoppingListModel {
  List<ShoppingListItemModel> _items = [];

  @override
  Future<List<ShoppingListItemModel>> getItems() {
    return Future.value(this._items);
  }

  set items(List<ShoppingListItemModel> value) => this._items = value;
}

void main() {
  var cut = ShoppingListTextGeneratorImpl();
  GetIt.I.registerSingleton<UnitOfMeasureProvider>(UoMMock());

  test('createShoppingListText', () async {
    var model = ShoppingListModelMock();
    var pepper = MutableIngredientNote.empty();
    pepper.name = 'Pepper';
    pepper.amount = 400;
    pepper.unitOfMeasure = 'GRM';

    var onion = MutableIngredientNote.empty();
    onion.name = 'Onion';
    onion.amount = 3;
    onion.unitOfMeasure = 'KGM';

    var customSalt = MutableIngredientNote.empty();
    customSalt.name = 'Salt';

    model.items = [
      ShoppingListItemModel.ofEntity(
          MutableShoppingListItem.ofIngredientNote(pepper, false, false)),
      ShoppingListItemModel.ofEntity(
          MutableShoppingListItem.ofIngredientNote(onion, true, false)),
      ShoppingListItemModel.ofEntity(
          MutableShoppingListItem.ofIngredientNote(customSalt, false, true))
    ];

    const title = 'Shopping List';
    var result = await cut.generateText(model, title);

    var expectedResult = '''*$title*
• Pepper (400 GRM)
• Salt 
''';

    expect(result, expectedResult);
  });
}

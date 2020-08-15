import 'package:cookly/services/shopping_list_text_generator.dart';
import 'package:cookly/viewmodel/shopping_list/shopping_list_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:mockito/mockito.dart';

class ShoppingListModelMock extends Mock implements ShoppingListModel {
  List<ShoppingListItemModel> _items = [];

  @override
  Future<List<ShoppingListItemModel>> getItems() {
    return Future.value(this._items);
  }

  set items(List<ShoppingListItemModel> value) => this._items = value;
}

void main() {
  Map<String, dynamic> translations = {};
  translations.putIfAbsent(
      'functions', () => {'shoppingList': 'functions.shoppingList'});
  Localization.load(translations);

  var cut = ShoppingListTextGeneratorImpl();

  test('createShoppingListText', () async {
    var model = ShoppingListModelMock();

    var result = await cut.generateText(model);

    var expectedResult = '''*functions.shoppingList*
''';

    expect(result, expectedResult);
  });
}

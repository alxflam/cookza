import 'package:cookza/model/json/ingredient.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Copy values from other Ingredient', () async {
    var item = Ingredient(name: 'Test');
    var cut = Ingredient.from(item);

    expect(cut.name, 'Test');
  });
}

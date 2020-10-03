import 'package:cookza/constants.dart';
import 'package:cookza/viewmodel/shopping_list/shopping_list_detail.dart';

abstract class ShoppingListTextGenerator {
  Future<String> generateText(ShoppingListModel model, String title);
}

class ShoppingListTextGeneratorImpl implements ShoppingListTextGenerator {
  @override
  Future<String> generateText(ShoppingListModel model, String title) async {
    assert(title != null && title.isNotEmpty);
    var buffer = StringBuffer();

    buffer.write('*');
    buffer.write(title);
    buffer.write('*');
    buffer.writeln();

    for (var item in await model.getItems()) {
      // skip already checked off items
      if (item.isNoLongerNeeded) {
        continue;
      }

      buffer.write(kBulletCharacter);
      buffer.write(' ');
      buffer.write(item.name);
      buffer.write(' ');

      if (item.amount != null && item.amount.isNotEmpty) {
        buffer.write('(');
        buffer.write(item.amount);

        if (item.uom != null && item.uom.isNotEmpty) {
          buffer.write(' '); // space between amount and unit
          buffer.write(item.uom);
        }
        buffer.write(')');
      }

      buffer.writeln();
    }

    return buffer.toString();
  }
}

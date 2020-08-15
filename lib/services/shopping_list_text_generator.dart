import 'package:cookly/constants.dart';
import 'package:cookly/localization/keys.dart';
import 'package:cookly/viewmodel/shopping_list/shopping_list_detail.dart';
import 'package:flutter_translate/flutter_translate.dart';

abstract class ShoppingListTextGenerator {
  Future<String> generateText(ShoppingListModel model);
}

class ShoppingListTextGeneratorImpl implements ShoppingListTextGenerator {
  @override
  Future<String> generateText(ShoppingListModel model) async {
    var buffer = StringBuffer();
    buffer.write('*');
    buffer.write(translate(Keys.Functions_Shoppinglist));
    buffer.write('*');
    buffer.writeln();

    for (var item in await model.getItems()) {
      // skip already checked off items
      if (item.isNoLongerNeeded) {
        continue;
      }

      buffer.write(kBulletCharacter);
      buffer.write(' ');
      buffer.write(item.getName());
      buffer.write(' ');

      if (item.getAmount() != null && item.getAmount().isNotEmpty) {
        buffer.write('(');
        buffer.write(item.getAmount());

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

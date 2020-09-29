import 'package:cookza/constants.dart';
import 'package:cookza/localization/keys.dart';
import 'package:cookza/viewmodel/shopping_list/shopping_list_detail.dart';
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

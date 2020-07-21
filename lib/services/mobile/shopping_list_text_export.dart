import 'package:cookly/services/abstract/shopping_list_text_export.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:cookly/services/shopping_list_text_generator.dart';
import 'package:cookly/viewmodel/shopping_list/shopping_list.dart';
import 'package:share_extend/share_extend.dart';

// TODO: add web implementation!
class ShoppingListTextExporterApp implements ShoppingListTextExporter {
  @override
  Future<void> exportShoppingListAsText(ShoppingListModel model) async {
    var text = await sl.get<ShoppingListTextGenerator>().generateText(model);

    ShareExtend.share(text, 'text');
  }
}

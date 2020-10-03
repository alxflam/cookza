import 'package:cookza/services/abstract/shopping_list_text_export.dart';
import 'package:cookza/services/flutter/navigator_service.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/services/shopping_list/shopping_list_text_generator.dart';
import 'package:cookza/viewmodel/shopping_list/shopping_list_detail.dart';
import 'package:share_extend/share_extend.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// TODO: add web implementation!
class ShoppingListTextExporterApp implements ShoppingListTextExporter {
  @override
  Future<void> exportShoppingListAsText(ShoppingListModel model) async {
    var context = sl.get<NavigatorService>().currentContext;
    var title = AppLocalizations.of(context).functionsShoppingList;
    var text =
        await sl.get<ShoppingListTextGenerator>().generateText(model, title);

    ShareExtend.share(text, 'text');
  }
}

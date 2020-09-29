import 'package:cookza/viewmodel/shopping_list/shopping_list_detail.dart';

abstract class ShoppingListTextExporter {
  Future<void> exportShoppingListAsText(ShoppingListModel model);
}

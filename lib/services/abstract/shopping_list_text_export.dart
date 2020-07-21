import 'package:cookly/viewmodel/shopping_list/shopping_list.dart';

abstract class ShoppingListTextExporter {
  Future<void> exportShoppingListAsText(ShoppingListModel model);
}

import 'package:cookly/services/abstract/shopping_list_text_export.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:cookly/viewmodel/shopping_list/shopping_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShoppingListDetailScreen extends StatelessWidget {
  static final String id = 'shoppingListDetail';

  @override
  Widget build(BuildContext context) {
    var _model = ModalRoute.of(context).settings.arguments as ShoppingListModel;

    return ChangeNotifierProvider.value(
      value: _model,
      child: Consumer<ShoppingListModel>(
        builder: (context, model, _) {
          return Scaffold(
            appBar: AppBar(
              title: Text(model.shortTitle),
              actions: [
                IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () {
                      sl
                          .get<ShoppingListTextExporter>()
                          .exportShoppingListAsText(model);
                    })
              ],
            ),
            body: FutureBuilder<List<ShoppingListItemModel>>(
              future: model.getItems(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done &&
                    !model.hasBeenInitialized) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.data == null || snapshot.data.isEmpty) {
                  return Container();
                }

                return ReorderableListView(
                  children: List.generate(snapshot.data.length, (index) {
                    var _item = snapshot.data[index];

                    return ChangeNotifierProvider<ShoppingListItemModel>.value(
                      value: _item,
                      key: ValueKey(_item.hashCode),
                      child: Consumer<ShoppingListItemModel>(
                        builder: (context, itemModel, _) {
                          return CheckboxListTile(
                            key: ValueKey(itemModel.getName()),
                            value: itemModel.isNoLongerNeeded,
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (value) {
                              itemModel.setNoLongerNeeded(value);
                            },
                            dense: true,
                            activeColor: Colors.grey,
                            title: Text(
                              itemModel.getName(),
                              style: TextStyle(
                                  decoration: itemModel.isNoLongerNeeded
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none),
                            ),
                            subtitle: Text(
                              '${itemModel.getAmount()} ${itemModel.uom}',
                              style: TextStyle(
                                  decoration: itemModel.isNoLongerNeeded
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none),
                            ),
                          );
                        },
                      ),
                    );
                  }),
                  onReorder: (oldIndex, newIndex) {
                    model.reorder(newIndex, oldIndex);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

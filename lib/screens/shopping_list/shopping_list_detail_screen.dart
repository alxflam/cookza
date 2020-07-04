import 'package:cookly/viewmodel/shopping_list/shopping_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_extend/share_extend.dart';

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
                      var result = model.toShareString();
                      if (result.isNotEmpty) {
                        ShareExtend.share(result, 'text');
                      }
                    })
              ],
            ),
            body: FutureBuilder(
              future: model.getItems(),
              builder: (context, snapshot) {
                if (snapshot.data == null || snapshot.data.isEmpty) {
                  return Container();
                }

                return ListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(
                    height: 1,
                  ),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    var _item = snapshot.data[index];

                    return ChangeNotifierProvider<ShoppingListItemModel>.value(
                      value: _item,
                      child: Consumer<ShoppingListItemModel>(
                        builder: (context, itemModel, _) {
                          return CheckboxListTile(
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

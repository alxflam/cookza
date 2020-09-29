import 'package:cookza/constants.dart';
import 'package:cookza/localization/keys.dart';
import 'package:cookza/screens/new_ingredient_screen.dart';
import 'package:cookza/services/abstract/shopping_list_text_export.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/viewmodel/recipe_edit/recipe_ingredient_model.dart';
import 'package:cookza/viewmodel/shopping_list/shopping_list_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class PopupMenuButtonChoices {
  final _key;
  final _icon;
  const PopupMenuButtonChoices._internal(this._key, this._icon);
  toString() => translate(_key);
  IconData get icon => this._icon;

  static const SHARE =
      const PopupMenuButtonChoices._internal(Keys.Ui_Share, Icons.share);
  static const ADD_ITEM = const PopupMenuButtonChoices._internal(
      Keys.Ui_Shoppinglist_Additem, Icons.add);
}

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
                PopupMenuButton(
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(PopupMenuButtonChoices.SHARE.icon),
                            Text(PopupMenuButtonChoices.SHARE.toString())
                          ],
                        ),
                        value: PopupMenuButtonChoices.SHARE,
                      ),
                      PopupMenuItem(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(PopupMenuButtonChoices.ADD_ITEM.icon),
                            Text(PopupMenuButtonChoices.ADD_ITEM.toString())
                          ],
                        ),
                        value: PopupMenuButtonChoices.ADD_ITEM,
                      ),
                    ];
                  },
                  onSelected: (value) async {
                    switch (value) {
                      case PopupMenuButtonChoices.SHARE:
                        sl
                            .get<ShoppingListTextExporter>()
                            .exportShoppingListAsText(model);
                        break;
                      case PopupMenuButtonChoices.ADD_ITEM:
                        // open ingredient screen
                        var result = await Navigator.pushNamed(
                            context, NewIngredientScreen.id,
                            arguments: RecipeIngredientModel.empty(false));

                        if (result != null && result is RecipeIngredientModel) {
                          model.addCustomItem(result.toIngredientNote());
                        }
                        break;
                      default:
                        break;
                    }
                  },
                ),
              ],
            ),
            body: FutureBuilder<List<ShoppingListItemModel>>(
              future: model.getItems(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done &&
                    !model.initialized) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.data == null || snapshot.data.isEmpty) {
                  return Container(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: FaIcon(
                                kShoppingListIconData,
                                size: 70,
                              ),
                            ),
                          ),
                          Center(
                              child:
                                  Text(translate(Keys.Ui_Shoppinglist_Noitems)))
                        ]),
                  );
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
                            key: ValueKey(itemModel.name),
                            value: itemModel.isNoLongerNeeded,
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (value) {
                              itemModel.noLongerNeeded = value;
                            },
                            dense: true,
                            activeColor: Colors.grey,
                            title: Text(
                              itemModel.name,
                              style: TextStyle(
                                  decoration: itemModel.isNoLongerNeeded
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none),
                            ),
                            subtitle: Text(
                              '${itemModel.amount} ${itemModel.uom}',
                              style: TextStyle(
                                  decoration: itemModel.isNoLongerNeeded
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none),
                            ),
                            secondary: itemModel.isCustomItem
                                ? IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () async {
                                      // edit the custom item
                                      var result = await Navigator.pushNamed(
                                          context, NewIngredientScreen.id,
                                          arguments: RecipeIngredientModel
                                              .noteOnlyModelOf(itemModel
                                                  .toIngredientNoteEntity()));
                                      if (result != null &&
                                          result is RecipeIngredientModel) {
                                        if (result.isDeleted) {
                                          model.removeItem(index, itemModel);
                                        } else {
                                          itemModel.updateFrom(result);
                                        }
                                      }
                                    })
                                : null,
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

import 'package:cookza/components/nothing_found.dart';
import 'package:cookza/screens/new_ingredient_screen.dart';
import 'package:cookza/services/abstract/shopping_list_text_export.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/viewmodel/ingredient_screen_model.dart';
import 'package:cookza/viewmodel/recipe_edit/recipe_ingredient_model.dart';
import 'package:cookza/viewmodel/shopping_list/shopping_list_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ShoppingListDetailScreen extends StatelessWidget {
  static const String id = 'shoppingListDetail';

  @override
  Widget build(BuildContext context) {
    var _model =
        ModalRoute.of(context)!.settings.arguments as ShoppingListModel;

    return ChangeNotifierProvider.value(
      value: _model,
      child: Consumer<ShoppingListModel>(
        builder: (context, model, _) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                await sl
                    .get<ShoppingListTextExporter>()
                    .exportShoppingListAsText(model);
              },
              child: Icon(Icons.share),
            ),
            appBar: AppBar(
              title: Text(model.shortTitle),
              actions: [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () async {
                    // open ingredient screen
                    final ingScreenModel = IngredientScreenModel(
                        model: RecipeIngredientModel.empty(false),
                        supportsRecipeReference: false,
                        requiresIngredientGroup: false,
                        groups: [],
                        group: null);
                    var result = await Navigator.pushNamed(
                        context, NewIngredientScreen.id,
                        arguments: ingScreenModel) as IngredientScreenModel?;

                    if (result != null) {
                      model.addCustomItem(
                          ingScreenModel.model.toIngredientNote());
                    }
                  },
                )
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

                if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        NothingFound(AppLocalizations.of(context).noItems),
                      ],
                    ),
                  );
                }

                return ReorderableListView(
                  onReorder: (oldIndex, newIndex) {
                    model.reorder(newIndex, oldIndex);
                  },
                  children: List.generate(snapshot.data!.length, (index) {
                    var _item = snapshot.data![index];

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
                                      final ingScreenModel =
                                          IngredientScreenModel(
                                              model: RecipeIngredientModel
                                                  .noteOnlyModelOf(itemModel
                                                      .toIngredientNoteEntity()),
                                              supportsRecipeReference: false,
                                              requiresIngredientGroup: false,
                                              groups: [],
                                              group: null);

                                      var result = await Navigator.pushNamed(
                                              context, NewIngredientScreen.id,
                                              arguments: ingScreenModel)
                                          as IngredientScreenModel?;
                                      if (result != null) {
                                        if (result.model.isDeleted) {
                                          model.removeItem(index, itemModel);
                                        } else {
                                          itemModel.updateFrom(result.model);
                                        }
                                      }
                                    })
                                : null,
                          );
                        },
                      ),
                    );
                  }),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

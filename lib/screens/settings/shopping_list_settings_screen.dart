import 'package:cookza/viewmodel/settings/shopping_list_settings_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ShoppingListSettingsScreen extends StatelessWidget {
  static final String id = 'shoppingListSettings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).functionsShoppingList,
        ),
      ),
      body: ChangeNotifierProvider<ShoppingListSettingsModel>.value(
        value: ShoppingListSettingsModel.create(),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Consumer<ShoppingListSettingsModel>(
              builder: (context, model, widget) {
                var column = Column(
                  children: [],
                );
                // var tile = SwitchListTile(
                //     title: Text('§Group items'),
                //     subtitle: Text('§Group items by category'),
                //     value: model.showCategories,
                //     onChanged: (value) {
                //       model.showCategories = value;
                //     });

                // column.children.add(tile);

                return column;
              },
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:cookza/localization/keys.dart';
import 'package:cookza/viewmodel/settings/shopping_list_settings_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

class ShoppingListSettingsScreen extends StatelessWidget {
  static final String id = 'shoppingListSettings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          translate(Keys.Functions_Shoppinglist),
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
                var tile = SwitchListTile(
                    title: Text('§Group items'),
                    subtitle: Text('§Group items by category'),
                    value: model.showCategories,
                    onChanged: (value) {
                      model.showCategories = value;
                    });

                column.children.add(tile);

                if (model.showCategories) {
                  column.children.add(_buildCategories(model, context));
                }

                return column;
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategories(
      ShoppingListSettingsModel model, BuildContext context) {
    List<Widget> tiles = [];

    tiles.add(
      Text('§Categories: '),
    );

    for (var item in model.categories) {
      tiles.add(
        ListTile(
          title: Text(item),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {},
          ),
        ),
      );
    }

    return Column(children: tiles);
  }
}

import 'package:cookly/localization/keys.dart';
import 'package:cookly/screens/shopping_list/shopping_list_detail_screen.dart';
import 'package:cookly/screens/shopping_list/shopping_list_dialog.dart';
import 'package:cookly/viewmodel/shopping_list/shopping_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

class ShoppingListOverviewScreen extends StatelessWidget {
  static final String id = 'shoppingLists';

  @override
  Widget build(BuildContext context) {
    // TODO: create shopping list view model
    // shopping list per: meal plan group and date range - any user of the meal group may access the shopping list
    // does not make sense to have different access rules
    ShoppingListOverviewModel _model = ShoppingListOverviewModel.of([]);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          translate(Keys.Functions_Shoppinglist),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              openShoppingListDialog(context);
            },
          ),
        ],
      ),
      body: ChangeNotifierProvider<ShoppingListOverviewModel>.value(
        value: _model,
        child: _getBody(),
      ),
    );
  }

  Widget _getBody() {
    return Consumer<ShoppingListOverviewModel>(builder: (context, model, _) {
      if (model.getLists().isEmpty) {
        return Center(
          child: Card(
            child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Use the add button to create a new shopping list',
                  textAlign: TextAlign.center,
                )),
          ),
        );
      }
      return ListView.builder(
        itemCount: model.getLists().length,
        itemBuilder: (context, index) {
          var entry = model.getLists()[index];
          return ListTile(
            title: Text('${entry.getDateFrom()} - ${entry.getDateEnd()}'),
            onTap: () {
              Navigator.pushNamed(context, ShoppingListDetailScreen.id,
                  arguments: entry);
            },
          );
        },
      );
    });
  }
}

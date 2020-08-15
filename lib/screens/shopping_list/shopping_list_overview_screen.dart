import 'package:cookly/constants.dart';
import 'package:cookly/localization/keys.dart';
import 'package:cookly/screens/shopping_list/shopping_list_detail_screen.dart';
import 'package:cookly/screens/shopping_list/shopping_list_dialog.dart';
import 'package:cookly/viewmodel/shopping_list/shopping_list_overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

class ShoppingListOverviewScreen extends StatelessWidget {
  static final String id = 'shoppingLists';

  @override
  Widget build(BuildContext context) {
    ShoppingListOverviewModel _model = ShoppingListOverviewModel();

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
      return FutureBuilder(
        future: model.getLists(),
        builder: (context, snapshot) {
          if (snapshot.data == null || snapshot.data.isEmpty) {
            return Container();
          }

          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              var entry = snapshot.data[index];
              return ListTile(
                title: Text(
                    '${kDateFormatter.format(entry.dateFrom)} - ${kDateFormatter.format(entry.dateEnd)}'),
                onTap: () {
                  Navigator.pushNamed(context, ShoppingListDetailScreen.id,
                      arguments: entry);
                },
              );
            },
          );
        },
      );
    });
  }
}

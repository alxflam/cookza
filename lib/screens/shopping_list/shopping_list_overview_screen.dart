import 'package:cookza/constants.dart';
import 'package:cookza/screens/shopping_list/shopping_list_detail_screen.dart';
import 'package:cookza/screens/shopping_list/shopping_list_dialog.dart';
import 'package:cookza/viewmodel/shopping_list/shopping_list_detail.dart';
import 'package:cookza/viewmodel/shopping_list/shopping_list_overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ShoppingListOverviewScreen extends StatelessWidget {
  static final String id = 'shoppingLists';

  @override
  Widget build(BuildContext context) {
    ShoppingListOverviewModel _model = ShoppingListOverviewModel();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).functionsShoppingList,
        ),
        actions: [
          IconButton(
            icon: Icon(kShoppingListIconData),
            onPressed: () async {
              await openShoppingListDialog(context);
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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data == null || snapshot.data.isEmpty) {
            return Container();
          }

          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              var entry = snapshot.data[index];
              return ListTile(
                title: Text(
                    '${kDateFormatter.format(entry.dateFrom)} - ${kDateFormatter.format(entry.dateUntil)}'),
                onTap: () async {
                  var detailsViewModel = ShoppingListModel.from(entry);
                  await Navigator.pushNamed(
                          context, ShoppingListDetailScreen.id,
                          arguments: detailsViewModel)
                      .then((value) => model.navigatedBack());
                },
              );
            },
          );
        },
      );
    });
  }
}

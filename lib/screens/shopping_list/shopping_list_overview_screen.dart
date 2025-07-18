import 'package:cookza/components/alert_dialog_title.dart';
import 'package:cookza/components/nothing_found.dart';
import 'package:cookza/constants.dart';
import 'package:cookza/model/entities/abstract/shopping_list_entity.dart';
import 'package:cookza/screens/shopping_list/shopping_list_detail_screen.dart';
import 'package:cookza/screens/shopping_list/shopping_list_dialog.dart';
import 'package:cookza/viewmodel/shopping_list/shopping_list_detail.dart';
import 'package:cookza/viewmodel/shopping_list/shopping_list_overview.dart';
import 'package:flutter/material.dart';
import 'package:cookza/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ShoppingListOverviewScreen extends StatelessWidget {
  static const String id = 'shoppingLists';

  const ShoppingListOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ShoppingListOverviewModel overviewModel = ShoppingListOverviewModel();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).functionsShoppingList,
        ),
        actions: [
          IconButton(
            icon: const Icon(kShoppingListIconData),
            onPressed: () async {
              await openShoppingListDialog(context);
            },
          ),
        ],
      ),
      body: ChangeNotifierProvider<ShoppingListOverviewModel>.value(
        value: overviewModel,
        child: _getBody(),
      ),
    );
  }

  Widget _getBody() {
    return Consumer<ShoppingListOverviewModel>(
      builder: (context, model, _) {
        return FutureBuilder<List<ShoppingListEntity>>(
          future: model.getLists(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return NothingFound(AppLocalizations.of(context).noShoppingLists);
            }

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var entry = snapshot.data![index];
                var mealPlanName = model.getMealPlanName(entry.groupID);
                var date =
                    '${kDateFormatter.format(entry.dateFrom)} - ${kDateFormatter.format(entry.dateUntil)}';
                return ListTile(
                  title: Text(date),
                  subtitle: Text(mealPlanName),
                  onTap: () async {
                    var detailsViewModel = ShoppingListModel.from(entry);
                    await Navigator.pushNamed(
                            context, ShoppingListDetailScreen.id,
                            arguments: detailsViewModel)
                        .then((value) => model.navigatedBack());
                  },
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    onPressed: () async {
                      var msg =
                          '${AppLocalizations.of(context).functionsShoppingList} ($date)';

                      /// as with all deletions, show a dialog whether we should really delete the data
                      await showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: AlertDialogTitle(
                                title: AppLocalizations.of(context).delete),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of(context)
                                        .confirmDelete(msg),
                                  ),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              ElevatedButton(
                                style: kRaisedGreyButtonStyle,
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                                child: Text(
                                  AppLocalizations.of(context).cancel,
                                ),
                              ),
                              ElevatedButton(
                                style: kRaisedRedButtonStyle,
                                onPressed: () async {
                                  final navigator = Navigator.of(context);
                                  await model.deleteList(entry);
                                  navigator.pop(true);
                                },
                                child: Text(
                                  AppLocalizations.of(context).delete,
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

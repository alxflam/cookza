import 'package:cookza/constants.dart';
import 'package:cookza/model/entities/abstract/recipe_collection_entity.dart';
import 'package:cookza/screens/groups/recipe_group.dart';
import 'package:cookza/screens/recipe_list_screen.dart';
import 'package:cookza/services/recipe/recipe_manager.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecipeGroupsDrawer extends StatelessWidget {
  const RecipeGroupsDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: StreamProvider<List<RecipeCollectionEntity>>.value(
        initialData: const [],
        value: sl.get<RecipeManager>().collectionsAsStream,
        child: const RecipeGroupsTiles(),
      ),
    );
  }
}

class RecipeGroupsTiles extends StatelessWidget {
  const RecipeGroupsTiles({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var groups = Provider.of<List<RecipeCollectionEntity>>(context);
    var recipeManager = sl.get<RecipeManager>();

    return Column(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  final navigator = Navigator.of(context);
                  // await the creation or cancellation
                  var result = await this._createRecipeGroup(context);
                  // if a new group got created
                  if (result != null) {
                    // then set the created group as the currently selected one
                    recipeManager.currentCollection = result.id;
                    // and make sure that the underlying view is updated
                    await navigator.pushReplacementNamed(RecipeListScreen.id);
                  }
                },
                child: Text(AppLocalizations.of(context).createGroup),
              )
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: groups.length,
            itemBuilder: (context, index) {
              var item = groups[index];
              var isActive = recipeManager.currentCollection == item.id;
              return ListTile(
                  title: Text(item.name),
                  leading: isActive ? const Icon(Icons.check) : const Text(''),
                  trailing: IconButton(
                    icon: const Icon(Icons.info),
                    onPressed: () {
                      Navigator.pushNamed(context, RecipeGroupScreen.id,
                          arguments: item);
                    },
                  ),
                  onTap: () {
                    recipeManager.currentCollection = item.id;
                    Navigator.pushReplacementNamed(
                        context, RecipeListScreen.id);
                  });
            },
          ),
        ),
      ],
    );
  }

  Future<RecipeCollectionEntity>? _createRecipeGroup(
      BuildContext context) async {
    return await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        var controller = TextEditingController(text: '');

        return Builder(
          // builder is needed to get a new context for the Provider
          builder: (context) {
            return SimpleDialog(
              title: Text(AppLocalizations.of(context).createGroup),
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: TextFormField(
                                textCapitalization:
                                    TextCapitalization.sentences,
                                controller: controller,
                                maxLines: 1,
                                autofocus: true,
                                decoration: InputDecoration(
                                    hintText:
                                        AppLocalizations.of(context).groupName),
                              ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          ElevatedButton(
                            style: kRaisedGreenButtonStyle,
                            onPressed: () async {
                              final navigator = Navigator.of(context);
                              var entity = await sl
                                  .get<RecipeManager>()
                                  .createCollection(controller.text);
                              navigator.pop(entity);
                            },
                            child: const Icon(Icons.save),
                          ),
                          ElevatedButton(
                            style: kRaisedRedButtonStyle,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.cancel),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

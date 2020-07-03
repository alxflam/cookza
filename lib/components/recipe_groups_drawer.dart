import 'package:cookly/model/entities/abstract/recipe_collection_entity.dart';
import 'package:cookly/screens/groups/recipe_group.dart';
import 'package:cookly/screens/recipe_list_screen.dart';
import 'package:cookly/services/recipe_manager.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipeGroupsDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: StreamProvider<List<RecipeCollectionEntity>>.value(
        value: sl.get<RecipeManager>().collectionsAsStream,
        child: RecipeGroupsTiles(),
      ),
    );
  }
}

class RecipeGroupsTiles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var groups = Provider.of<List<RecipeCollectionEntity>>(context);
    var recipeManager = sl.get<RecipeManager>();

    return Column(
      children: [
        DrawerHeader(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text('Recipe Groups'),
              RaisedButton(
                  child: Text('Create Group'),
                  onPressed: () async {
                    this._createRecipeGroup(context);
                  })
            ],
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: groups == null ? 0 : groups.length,
            itemBuilder: (context, index) {
              var item = groups[index];
              var isActive = recipeManager.currentCollection == item.id;
              return ListTile(
                  title: Text(item.name),
                  leading: isActive ? Icon(Icons.check) : Text(''),
                  trailing: IconButton(
                    icon: Icon(Icons.info),
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

  Future<void> _createRecipeGroup(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        var controller = TextEditingController(text: '');

        return Builder(
          // builder is needed to get a new context for the Provider
          builder: (context) {
            return SimpleDialog(
              title: Text('Create Collection'),
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: controller,
                                maxLines: 1,
                                autofocus: true,
                                decoration: InputDecoration(
                                    hintText: 'Collection name'),
                              ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          RaisedButton(
                              child: Icon(Icons.save),
                              color: Colors.green,
                              onPressed: () async {
                                sl
                                    .get<RecipeManager>()
                                    .createCollection(controller.text);
                                Navigator.pop(context);
                              }),
                          RaisedButton(
                              child: Icon(Icons.cancel),
                              color: Colors.red,
                              onPressed: () {
                                Navigator.pop(context);
                              }),
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

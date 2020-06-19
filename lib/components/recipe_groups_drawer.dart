import 'package:cookly/model/entities/abstract/recipe_collection_entity.dart';
import 'package:cookly/screens/groups/recipe_group.dart';
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

    if (groups == null || groups.isEmpty) {
      return Container();
    }

    return Column(
      children: [
        DrawerHeader(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text('Recipe Groups'),
              RaisedButton(child: Text('Create Group'), onPressed: () {})
            ],
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
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
                leading: isActive ? Icon(Icons.check) : Container(),
                trailing: IconButton(
                  icon: Icon(Icons.info),
                  onPressed: () {
                    Navigator.pushNamed(context, RecipeGroupScreen.id,
                        arguments: item);
                  },
                ),
                onTap: () => recipeManager.currentCollection = item.id,
              );
            },
          ),
        ),
      ],
    );
  }
}

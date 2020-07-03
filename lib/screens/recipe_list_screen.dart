import 'package:cookly/components/recipe_groups_drawer.dart';
import 'package:cookly/components/recipe_list_tile.dart';
import 'package:cookly/localization/keys.dart';
import 'package:cookly/model/entities/abstract/recipe_entity.dart';
import 'package:cookly/services/recipe_manager.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

class RecipeListScreen extends StatelessWidget {
  static final String id = 'recipes';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: RecipeGroupsDrawer(),
        appBar: AppBar(
          title: Text('${translatePlural(Keys.Ui_Recipe, 2)}'),
        ),
        body: AllRecipesList(),
      ),
    );
  }
}

class AllRecipesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<RecipeEntity>>.value(
      value: sl.get<RecipeManager>().recipes,
      child: Builder(
        builder: (context) {
          var recipes = Provider.of<List<RecipeEntity>>(context);

          if (recipes == null || recipes.isEmpty) {
            return Container();
          }

          // TODO: add filter text input at the top! => app bar with search icon then search field in app bar appears

          return ListView.separated(
            separatorBuilder: (context, index) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                color: Theme.of(context).primaryColorLight,
              ),
            ),
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              return RecipeListTile(item: recipes[index]);
            },
          );
        },
      ),
    );
  }
}

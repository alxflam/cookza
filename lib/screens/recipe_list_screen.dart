import 'package:cookza/components/open_drawer_button.dart';
import 'package:cookza/components/recipe_groups_drawer.dart';
import 'package:cookza/components/recipe_list_tile.dart';
import 'package:cookza/model/entities/abstract/recipe_entity.dart';
import 'package:cookza/screens/recipe_modify/new_recipe_screen.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/services/recipe/recipe_manager.dart';
import 'package:cookza/viewmodel/recipe_edit/recipe_edit_model.dart';
import 'package:cookza/viewmodel/recipe_list/recipe_list_model.dart';
import 'package:flutter/material.dart';
import 'package:cookza/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class RecipeListScreen extends StatelessWidget {
  static const String id = 'recipes';

  const RecipeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: RecipeListViewModel(),
      builder: (context, child) {
        return Builder(
          builder: (context) {
            return Scaffold(
              drawer: const RecipeGroupsDrawer(),
              appBar: _buildAppBar(context),
              body: Builder(
                builder: (context) {
                  /// check if a recipe group is already selected
                  var collectionID = sl.get<RecipeManager>().currentCollection;
                  if (collectionID == null || collectionID.isEmpty) {
                    return OpenDrawerButton(
                        AppLocalizations.of(context).noRecipeGroupSelected);
                  }

                  /// read recipes for selected recipe
                  return StreamProvider<List<RecipeEntity>>.value(
                    initialData: const [],
                    value:
                        Provider.of<RecipeListViewModel>(context, listen: false)
                            .getRecipes(),
                    child: Builder(
                      builder: (context) {
                        var recipes = Provider.of<List<RecipeEntity>>(context);

                        if (recipes.isEmpty) {
                          return Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      final navigator = Navigator.of(context);
                                      var collection = await sl
                                          .get<RecipeManager>()
                                          .collectionByID(collectionID);
                                      await navigator.pushNamed(
                                        NewRecipeScreen.id,
                                        arguments: RecipeEditModel.create(
                                            collection: collection),
                                      );
                                    },
                                    child: Text(AppLocalizations.of(context)
                                        .createRecipe),
                                  )
                                ],
                              ),
                            ),
                          );
                        }

                        return ListView.separated(
                          separatorBuilder: (context, index) => const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Divider(),
                          ),
                          itemCount: recipes.length,
                          itemBuilder: (context, index) {
                            return RecipeListTile(item: recipes[index]);
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    var model = Provider.of<RecipeListViewModel>(context);
    var searchEnabled = model.isSearchEnabled;

    if (searchEnabled) {
      return AppBar(
        title: TextField(
          autofocus: true,
          onChanged: (value) {
            model.filterString = value;
          },
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
          ),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.cancel,
                  color: Theme.of(context).colorScheme.error),
              onPressed: () {
                Provider.of<RecipeListViewModel>(context, listen: false)
                    .isSearchEnabled = false;
              }),
        ],
      );
    }
    return AppBar(
      title: Text(AppLocalizations.of(context).recipe(2)),
      actions: [
        IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Provider.of<RecipeListViewModel>(context, listen: false)
                  .isSearchEnabled = true;
            }),
      ],
    );
  }
}

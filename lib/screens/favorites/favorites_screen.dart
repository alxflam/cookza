import 'package:cookza/components/nothing_found.dart';
import 'package:cookza/components/recipe_list_tile.dart';
import 'package:cookza/components/recipe_rating_bar.dart';
import 'package:cookza/model/entities/abstract/recipe_entity.dart';
import 'package:cookza/viewmodel/favorites/favorite_recipes_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class FavoriteRecipesScreen extends StatelessWidget {
  static final String id = 'favorites';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: FavoriteRecipesViewModel(),
      builder: (context, child) {
        return Scaffold(
          appBar: _buildAppBar(context),
          body: FutureBuilder<List<RecipeEntity>>(
            future: Provider.of<FavoriteRecipesViewModel>(context)
                .getFavoriteRecipes(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              var favorites = snapshot.data ?? [];

              if (favorites.isEmpty) {
                var minRating = Provider.of<FavoriteRecipesViewModel>(context,
                        listen: false)
                    .minRating;

                return NothingFound(AppLocalizations.of(context)
                    .favoriteNotExisting(minRating));
              }

              return ListView.separated(
                separatorBuilder: (context, index) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(
                    color: Theme.of(context).primaryColorLight,
                  ),
                ),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  return RecipeListTile(item: favorites[index]);
                },
              );
            },
          ),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final viewModel =
        Provider.of<FavoriteRecipesViewModel>(context, listen: false);

    return AppBar(
      centerTitle: true,
      title: RecipeRatingBar(
        initialRating: viewModel.minRating,
        onUpdate: (value) => viewModel.minRating = value.toInt(),
      ),
    );
  }
}

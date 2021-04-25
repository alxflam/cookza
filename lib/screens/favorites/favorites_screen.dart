import 'package:cookza/components/recipe_list_tile.dart';
import 'package:cookza/model/entities/abstract/recipe_entity.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/services/recipe/recipe_manager.dart';
import 'package:cookza/viewmodel/favorites/favorite_recipes_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class FavoriteRecipesScreen extends StatelessWidget {
  static final String id = 'favorites';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RecipeEntity>>(
      future: sl.get<RecipeManager>().getFavoriteRecipes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(),
          );
        }
        return ChangeNotifierProvider.value(
          value: FavoriteRecipesViewModel(favorites: snapshot.data ?? []),
          builder: (context, child) {
            return Scaffold(
              appBar: _buildAppBar(context),
              body: FutureBuilder<List<RecipeEntity>>(
                future: sl.get<RecipeManager>().getFavoriteRecipes(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final model = Provider.of<FavoriteRecipesViewModel>(context);
                  var favorites = model.getFavoriteRecipes();

                  if (favorites.isEmpty) {
                    return Container(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('§You have not yet rated any recipes'),
                        ),
                      ),
                    );
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
      },
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final viewModel =
        Provider.of<FavoriteRecipesViewModel>(context, listen: false);

    return AppBar(
      centerTitle: true,
      title: RatingBar.builder(
        initialRating: viewModel.minRating.toDouble(),
        minRating: 1,
        maxRating: 5,
        direction: Axis.horizontal,
        allowHalfRating: false,
        unratedColor: Colors.amber.withAlpha(50),
        itemCount: 5,
        itemSize: 20.0,
        itemPadding: EdgeInsets.symmetric(horizontal: 5.0),
        itemBuilder: (context, _) => Icon(
          Icons.star,
          color: Colors.amberAccent,
        ),
        onRatingUpdate: (rating) {
          viewModel.minRating = rating.toInt();
        },
        updateOnDrag: false,
      ),
    );
  }
}

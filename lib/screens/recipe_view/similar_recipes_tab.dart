import 'package:cookza/components/nothing_found.dart';
import 'package:cookza/components/recipe_list_tile.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/services/recipe/similarity_service.dart';
import 'package:cookza/viewmodel/recipe_view/recipe_view_model.dart';
import 'package:flutter/material.dart';
import 'package:cookza/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class SimilarRecipesScreen extends StatelessWidget {
  const SimilarRecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeViewModel>(builder: (context, model, child) {
      return FutureBuilder(
          future: sl.get<SimilarityService>().getSimilarRecipes(model.recipe),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length == 0) {
                return NothingFound(
                    AppLocalizations.of(context).noSimilarRecipes);
              }

              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return RecipeListTile(
                      item: snapshot.data[index],
                      replaceRoute: true,
                    );
                  });
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          });
    });
  }
}

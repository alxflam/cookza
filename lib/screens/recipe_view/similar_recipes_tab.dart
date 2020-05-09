import 'package:cookly/components/recipe_list_tile.dart';
import 'package:cookly/model/view/recipe_view_model.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:cookly/services/similarity_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SimilarRecipesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeViewModel>(builder: (context, model, child) {
      return FutureBuilder(
          future: sl.get<SimilarityService>().getSimilarRecipes(model.id),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length == 0) {
                return Center(
                  child: Text('No similar recipes found'),
                );
              }

              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return RecipeListTile(item: snapshot.data[index]);
                  });
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          });
    });
  }
}

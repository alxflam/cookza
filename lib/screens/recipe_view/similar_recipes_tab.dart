import 'package:cookza/components/recipe_list_tile.dart';
import 'package:cookza/localization/keys.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/services/recipe/similarity_service.dart';
import 'package:cookza/viewmodel/recipe_view/recipe_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

class SimilarRecipesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeViewModel>(builder: (context, model, child) {
      return FutureBuilder(
          future: sl.get<SimilarityService>().getSimilarRecipes(model.recipe),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length == 0) {
                return Center(
                  child: Text(translate(Keys.Ui_Nosimilarrecipes)),
                );
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
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          });
    });
  }
}

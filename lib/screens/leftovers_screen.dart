import 'package:cookly/components/recipe_list_tile.dart';
import 'package:cookly/localization/keys.dart';
import 'package:cookly/model/entities/abstract/recipe_entity.dart';
import 'package:cookly/services/flutter/service_locator.dart';
import 'package:cookly/services/recipe/similarity_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class LeftoversScreen extends StatelessWidget {
  static final String id = 'leftovers';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate(Keys.Functions_Leftovers)),
      ),
      body: LeftoversBody(),
    );
  }
}

class LeftoversBody extends StatefulWidget {
  @override
  _LeftoversBodyState createState() => _LeftoversBodyState();
}

class _LeftoversBodyState extends State<LeftoversBody> {
  List<String> _ingredients = [];

  void _addIngredient(String ingredient) {
    if (ingredient != null &&
        ingredient.isNotEmpty &&
        !_ingredients.contains(ingredient)) {
      setState(() {
        _ingredients.add(ingredient);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var _ingredientController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // input field
        Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _ingredientController,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: translatePlural(Keys.Recipe_Ingredient, 1),
                    prefixIcon: Icon(Icons.search),
                  ),
                  keyboardType: TextInputType.text,
                  onSubmitted: (value) {
                    this._addIngredient(value);
                    _ingredientController.clear();
                  },
                ),
              ),
            ),
          ],
        ),
        // chips
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Wrap(
            spacing: 10,
            children: this._buildChips(),
          ),
        ),
        // list view with results
        Builder(builder: (context) {
          if (this._ingredients.isEmpty) {
            return Container();
          }
          return FutureBuilder(
            future: sl
                .get<SimilarityService>()
                .getRecipesContaining(this._ingredients),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data.length > 0) {
                var result = snapshot.data as List<RecipeEntity>;
                return Expanded(
                  child: ListView.builder(
                    itemCount: result.length,
                    itemBuilder: (context, index) {
                      return RecipeListTile(item: result[index]);
                    },
                  ),
                );
              } else if (snapshot.hasData && snapshot.data.isEmpty) {
                return Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.warning,
                      color: Colors.orange,
                    ),
                    title: Text(translate(Keys.Ui_Norecipesfound)),
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          );
        }),
      ],
    );
  }

  List<Widget> _buildChips() {
    List<InputChip> result = [];
    for (var ingredient in this._ingredients) {
      var chip = InputChip(
        label: Text(ingredient),
        onDeleted: () => this._removeIngredient(ingredient),
      );
      result.add(chip);
    }

    return result;
  }

  _removeIngredient(String ingredient) {
    setState(() {
      this._ingredients.remove(ingredient);
    });
  }
}

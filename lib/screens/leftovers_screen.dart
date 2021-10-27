import 'package:cookza/components/nothing_found.dart';
import 'package:cookza/components/recipe_list_tile.dart';
import 'package:cookza/model/entities/abstract/recipe_entity.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/services/recipe/similarity_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LeftoversScreen extends StatelessWidget {
  static const String id = 'leftovers';

  const LeftoversScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).functionsLeftovers),
      ),
      body: const LeftoversBody(),
    );
  }
}

class LeftoversBody extends StatefulWidget {
  const LeftoversBody({Key? key}) : super(key: key);

  @override
  _LeftoversBodyState createState() => _LeftoversBodyState();
}

class _LeftoversBodyState extends State<LeftoversBody> {
  final List<String> _ingredients = [];

  void _addIngredient(String ingredient) {
    if (ingredient.isNotEmpty && !_ingredients.contains(ingredient)) {
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
                    labelText: AppLocalizations.of(context).ingredient(1),
                    prefixIcon: const Icon(Icons.search),
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
          padding: const EdgeInsets.symmetric(horizontal: 10),
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
          return FutureBuilder<List<RecipeEntity>>(
            future: sl
                .get<SimilarityService>()
                .getRecipesContaining(this._ingredients),
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.data!.isNotEmpty &&
                  snapshot.connectionState == ConnectionState.done) {
                var result = snapshot.data as List<RecipeEntity>;
                return Expanded(
                  child: ListView.builder(
                    itemCount: result.length,
                    itemBuilder: (context, index) {
                      return RecipeListTile(item: result[index]);
                    },
                  ),
                );
              } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                return NothingFound(
                    AppLocalizations.of(context).noRecipesFound);
              } else {
                return const Center(
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
        deleteIconColor: Theme.of(context).errorColor,
        onDeleted: () => this._removeIngredient(ingredient),
      );
      result.add(chip);
    }

    return result;
  }

  void _removeIngredient(String ingredient) {
    setState(() {
      this._ingredients.remove(ingredient);
    });
  }
}

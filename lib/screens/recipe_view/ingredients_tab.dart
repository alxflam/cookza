import 'package:cookza/components/round_icon_button.dart';
import 'package:cookza/constants.dart';
import 'package:cookza/screens/recipe_view/recipe_screen.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/services/recipe/recipe_manager.dart';
import 'package:cookza/viewmodel/recipe_view/recipe_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class IngredientsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeViewModel>(
      builder: (context, model, child) {
        return Container(
          child: Column(
            children: <Widget>[
              ListOfIngredientsHeader(),
              DataTable(
                showCheckboxColumn: false,
                columns: [
                  DataColumn(
                    numeric: true,
                    label: Text(AppLocalizations.of(context)!.amount),
                  ),
                  DataColumn(
                    label: Text(AppLocalizations.of(context)!.unit),
                  ),
                  DataColumn(
                    label: Text(AppLocalizations.of(context)!.ingredient(1)),
                  ),
                ],
                rows: _buildIngredientRows(context, model),
              )
            ],
          ),
        );
      },
    );
  }

  List<DataRow> _buildIngredientRows(
      BuildContext context, RecipeViewModel model) {
    var widgets = model.ingredients
        .map(
          (item) => DataRow(
            onSelectChanged: (bool? value) async {
              if ((value ?? false) && item.isRecipeReference) {
                final recipes = await sl
                    .get<RecipeManager>()
                    .getRecipeById([item.ingredient.recipeReference!]);
                if (recipes.isNotEmpty) {
                  await Navigator.pushNamed(context, RecipeScreen.id,
                      arguments: recipes.first);
                }
              }
            },
            cells: [
              DataCell(
                Text(kFormatAmount(item.amount)),
              ),
              DataCell(
                Text(item.uomDisplayText),
              ),
              DataCell(
                Text(item.ingredient.name),
              ),
            ],
          ),
        )
        .toList();
    return widgets;
  }
}

class ListOfIngredientsHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeViewModel>(builder: (context, model, child) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RoundIconButton(
            icon: FontAwesomeIcons.minus,
            onPress: () {
              model.decreaseServings();
            },
          ),
          Text(
              '${model.servings} ${AppLocalizations.of(context)!.servings(model.servings)}'),
          RoundIconButton(
            icon: FontAwesomeIcons.plus,
            onPress: () {
              model.increaseServings();
            },
          ),
        ],
      );
    });
  }
}

import 'package:cookza/components/round_icon_button.dart';
import 'package:cookza/constants.dart';
import 'package:cookza/screens/recipe_view/recipe_screen.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/services/recipe/recipe_manager.dart';
import 'package:cookza/viewmodel/recipe_edit/recipe_ingredient_model.dart';
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
                    label: Text(AppLocalizations.of(context).amount),
                  ),
                  DataColumn(
                    label: Text(AppLocalizations.of(context).unit),
                  ),
                  DataColumn(
                    label: Text(AppLocalizations.of(context).ingredient(1)),
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
    final groups = model.ingredientGroups;
// TODO: refactor into common component to be reused in ingredient step...
    final result = <DataRow>[];

    /// iterate over every group
    for (var group in groups) {
      /// if there's more than one group print a header line with the groups name
      if (groups.length > 1) {
        result.add(
          DataRow(
            cells: [
              DataCell(
                Text(
                  group.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              // data table does not support spanned cells, hence two dummy cells are needed
              DataCell(Container()),
              DataCell(Container()),
            ],
          ),
        );
      }

      for (var i = 0; i < group.ingredients.length; i++) {
        var ingModel = RecipeIngredientModel.of(group.ingredients[i]);

        final row = DataRow(
          onSelectChanged: (bool? value) async {
            if ((value ?? false) && ingModel.isRecipeReference) {
              final recipes = await sl
                  .get<RecipeManager>()
                  .getRecipeById([ingModel.ingredient.recipeReference!]);
              if (recipes.isNotEmpty) {
                await Navigator.pushNamed(context, RecipeScreen.id,
                    arguments: recipes.first);
              }
            }
          },
          cells: [
            DataCell(
              Text(kFormatAmount(ingModel.amount)),
            ),
            DataCell(
              Text(ingModel.uomDisplayText),
            ),
            DataCell(
              Text(ingModel.name),
            ),
          ],
        );

        result.add(row);
      }
    }

    return result;
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
              '${model.servings} ${AppLocalizations.of(context).servings(model.servings)}'),
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

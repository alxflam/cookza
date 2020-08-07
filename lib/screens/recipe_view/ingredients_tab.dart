import 'package:cookly/components/round_icon_button.dart';
import 'package:cookly/constants.dart';
import 'package:cookly/localization/keys.dart';
import 'package:cookly/viewmodel/recipe_view/recipe_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
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
                columns: [
                  DataColumn(
                    numeric: true,
                    label: Text(translate(Keys.Recipe_Amount)),
                  ),
                  DataColumn(
                    label: Text(translate(Keys.Recipe_Unit)),
                  ),
                  DataColumn(
                    label: Text(translatePlural(Keys.Recipe_Ingredient, 1)),
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
          Text(translate(Keys.Recipe_Ingredientsforservings,
              args: {"0": model.servings})),
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

import 'package:cookza/components/round_icon_button.dart';
import 'package:cookza/constants.dart';
import 'package:cookza/model/entities/mutable/mutable_ingredient_note.dart';
import 'package:cookza/screens/new_ingredient_screen.dart';
import 'package:cookza/viewmodel/recipe_edit/recipe_edit_model.dart';
import 'package:cookza/viewmodel/recipe_edit/recipe_edit_step.dart';
import 'package:cookza/viewmodel/recipe_edit/recipe_ingredient_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Step getIngredientsStep(BuildContext context) {
  return Step(
    title: Container(),
    isActive:
        Provider.of<RecipeEditModel>(context, listen: false).currentStep == 3,
    state: StepState.indexed,
    content: IngredientStepContent(),
  );
}

class IngredientStepContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Provider.of<RecipeEditModel>(context, listen: false)
          .ingredientStepModel,
      child: Consumer<RecipeIngredientEditStep>(
        builder: (context, model, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _getTableHeaderButtons(context, model),
              DataTable(
                columnSpacing: 5,
                horizontalMargin: 0,
                columns: [
                  DataColumn(
                    label: Text(AppLocalizations.of(context)!.amount),
                  ),
                  DataColumn(
                    label: Text(AppLocalizations.of(context)!.unit),
                  ),
                  DataColumn(
                    label: Text(AppLocalizations.of(context)!.ingredient(1)),
                  ),
                  DataColumn(label: Text('')),
                ],
                rows: _getIngredientRows(context, model),
              ),
            ],
          );
        },
      ),
    );
  }
}

Widget _getTableHeaderButtons(
    BuildContext context, RecipeIngredientEditStep model) {
  if (MediaQuery.of(context).orientation == Orientation.portrait) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _getServingsRow(model, context),
        _getAddRowButton(context, model),
      ],
    );
  } else {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _getServingsRow(model, context),
        _getAddRowButton(context, model),
      ],
    );
  }
}

Widget _getServingsRow(RecipeIngredientEditStep model, BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      RoundIconButton(
        icon: FontAwesomeIcons.minus,
        onPress: () => model.servings > 1
            ? model.servings = model.servings - 1
            : model.servings,
      ),
      Text(
          '${model.servings} ${AppLocalizations.of(context)!.servings(model.servings)}'),
      RoundIconButton(
        icon: FontAwesomeIcons.plus,
        onPress: () => model.servings = model.servings + 1,
      ),
    ],
  );
}

Widget _getAddRowButton(BuildContext context, RecipeIngredientEditStep model) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
        primary: Theme.of(context).colorScheme.primary),
    onPressed: () async {
      RecipeIngredientModel ingModel =
          RecipeIngredientModel.of(MutableIngredientNote.empty());

      var result = await Navigator.pushNamed(context, NewIngredientScreen.id,
          arguments: ingModel) as RecipeIngredientModel;

      if (result != null && !result.isDeleted) {
        model.addNewIngredient(result);
      }
    },
    child: Text(AppLocalizations.of(context)!.addIngredient),
  );
}

List<DataRow> _getIngredientRows(
    BuildContext context, RecipeIngredientEditStep model) {
  List<DataRow> widgets = [];
  for (var i = 0; i < model.ingredients.length; i++) {
    var item = model.ingredients[i];
    widgets.add(
      DataRow(
        cells: [
          DataCell(
            Text(kFormatAmount(item.amount)),
          ),
          DataCell(
            Text(item.uomDisplayText),
          ),
          DataCell(
            Text(item.name),
          ),
          DataCell(
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () async {
                var result = await Navigator.pushNamed(
                        context, NewIngredientScreen.id, arguments: item)
                    as RecipeIngredientModel;
                if (result != null) {
                  if (!result.isDeleted) {
                    model.setAmount(i, result.amount);
                    model.setIngredient(i, result.ingredient);
                    model.setScale(i, result.unitOfMeasure);
                  } else {
                    model.removeIngredient(i);
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
  return widgets;
}

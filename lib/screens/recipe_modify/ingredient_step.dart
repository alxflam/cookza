import 'package:cookly/components/round_icon_button.dart';
import 'package:cookly/constants.dart';
import 'package:cookly/localization/keys.dart';
import 'package:cookly/model/json/ingredient_note.dart';
import 'package:cookly/model/view/recipe_edit_model.dart';
import 'package:cookly/model/view/recipe_edit_step.dart';
import 'package:cookly/model/view/recipe_ingredient_model.dart';
import 'package:cookly/screens/new_ingredient_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

Step getIngredientsStep(BuildContext context) {
  return Step(
    title: Container(),
    isActive:
        Provider.of<RecipeEditModel>(context, listen: false).currentStep == 3,
    state: StepState.indexed,
    content: ChangeNotifierProvider.value(
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
                    label: Text(translate(Keys.Recipe_Amount)),
                  ),
                  DataColumn(
                    label: Text(translate(Keys.Recipe_Unit)),
                  ),
                  DataColumn(
                    label: Text(translate(Keys.Recipe_Ingredient)),
                  ),
                  DataColumn(label: Text('')),
                ],
                rows: _getIngredientRows(context, model),
              ),
            ],
          );
        },
      ),
    ),
  );
}

Widget _getTableHeaderButtons(
    BuildContext context, RecipeIngredientEditStep model) {
  if (MediaQuery.of(context).orientation == Orientation.portrait) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _getServingsRow(model),
        _getAddRowButton(context, model),
      ],
    );
  } else {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _getServingsRow(model),
        _getAddRowButton(context, model),
      ],
    );
  }
}

Widget _getServingsRow(RecipeIngredientEditStep model) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      RoundIconButton(
        icon: FontAwesomeIcons.minus,
        onPress: () => model.servings > 1
            ? model.servings = model.servings - 1
            : model.servings,
      ),
      Text('${model.servings} ${translate(Keys.Recipe_Servings)}'),
      RoundIconButton(
        icon: FontAwesomeIcons.plus,
        onPress: () => model.servings = model.servings + 1,
      ),
    ],
  );
}

Widget _getAddRowButton(BuildContext context, RecipeIngredientEditStep model) {
  return FlatButton.icon(
    onPressed: () async {
      var ingredientNote = IngredientNote.create();

      RecipeIngredientModel ingModel = RecipeIngredientModel.of(ingredientNote);

      var result = await Navigator.pushNamed(context, NewIngredientScreen.id,
          arguments: ingModel) as RecipeIngredientModel;

      if (result != null && !result.isDeleted) {
        model.addNewIngredient(result);
      }
    },
    icon: Icon(Icons.add),
    label: Text(translate(Keys.Ui_Addrow)),
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
                    // todo: create single apply from method
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

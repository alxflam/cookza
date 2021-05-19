import 'package:cookza/components/round_icon_button.dart';
import 'package:cookza/constants.dart';
import 'package:cookza/model/entities/abstract/ingredient_group_entity.dart';
import 'package:cookza/model/entities/mutable/mutable_ingredient_note.dart';
import 'package:cookza/screens/new_ingredient_screen.dart';
import 'package:cookza/viewmodel/recipe_edit/recipe_edit_model.dart';
import 'package:cookza/viewmodel/recipe_edit/recipe_edit_step.dart';
import 'package:cookza/viewmodel/recipe_edit/recipe_ingredient_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// TODO: see https://foodnotify.kayako.com/de/article/17-rezept-strukturieren

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
          final groups = model.groups
              .map((e) => IngredientGroupCard(group: e, model: model))
              .toList();

          return Column(
            // TODO: each ingredient group has a single table
            // header of group has add / delete / rename buttons
            // make ingredients reorderable / reorderable list view or still use data table?
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // _getTableHeaderButtons(context, model),
              // DataTable(
              //   columnSpacing: 5,
              //   horizontalMargin: 0,
              //   showCheckboxColumn: false,
              //   columns: [
              //     DataColumn(
              //       label: Text(AppLocalizations.of(context)!.amount),
              //     ),
              //     DataColumn(
              //       label: Text(AppLocalizations.of(context)!.unit),
              //     ),
              //     DataColumn(
              //       label: Text(AppLocalizations.of(context)!.ingredient(1)),
              //     ),
              //     DataColumn(label: Text('')),
              //   ],
              //   rows: _getIngredientRows(context, model),
              // ),

              _getServingsRow(model, context),

              // all groups
              ...groups,

              // trailing add group button
              _getAddGroupButton(context, model),
            ],
          );
        },
      ),
    );
  }
}

class IngredientGroupCard extends StatelessWidget {
  final IngredientGroupEntity group;
  final RecipeIngredientEditStep model;

  const IngredientGroupCard(
      {Key? key, required this.group, required this.model})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(group.name),
              IconButton(icon: Icon(Icons.edit), onPressed: () {}),
              IconButton(icon: Icon(Icons.swap_vert), onPressed: () {}),
              IconButton(icon: Icon(Icons.add), onPressed: () {}),
              IconButton(icon: Icon(Icons.delete), onPressed: () {}),
            ],
          ),
          DataTable(
            columnSpacing: 5,
            horizontalMargin: 0,
            showCheckboxColumn: false,
            columns: [
              DataColumn(
                label: Text(AppLocalizations.of(context).amount),
              ),
              DataColumn(
                label: Text(AppLocalizations.of(context).unit),
              ),
              DataColumn(
                label: Text(AppLocalizations.of(context).ingredient(1)),
              ),
              DataColumn(label: Text('')),
            ],
            rows: _getIngredientRows(context, model),
          ),
        ],
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
          '${model.servings} ${AppLocalizations.of(context).servings(model.servings)}'),
      RoundIconButton(
        icon: FontAwesomeIcons.plus,
        onPress: () => model.servings = model.servings + 1,
      ),
    ],
  );
}

Widget _getAddGroupButton(
    BuildContext context, RecipeIngredientEditStep model) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
        primary: Theme.of(context).colorScheme.primary),
    onPressed: () {
      model.addGroup(AppLocalizations.of(context).ingredient(2));
    },
    child: Text(AppLocalizations.of(context).groupName),
  );
}

Widget _getAddRowButton(BuildContext context, RecipeIngredientEditStep model) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
        primary: Theme.of(context).colorScheme.primary),
    onPressed: () async {
      final rootModel = Provider.of<RecipeEditModel>(context, listen: false);
      RecipeIngredientModel ingModel = RecipeIngredientModel.of(
          MutableIngredientNote.empty(),
          sourceRecipe: rootModel.targetEntity.id);

      var result = await Navigator.pushNamed(context, NewIngredientScreen.id,
          arguments: ingModel) as RecipeIngredientModel?;

      if (result != null && !result.isDeleted) {
        model.addNewIngredient(result);
      }
    },
    child: Text(AppLocalizations.of(context).addIngredient),
  );
}

List<DataRow> _getIngredientRows(
    BuildContext context, RecipeIngredientEditStep model) {
  List<DataRow> widgets = [];
  for (var i = 0; i < model.ingredients.length; i++) {
    var item = model.ingredients[i];
    widgets.add(
      DataRow(
        onSelectChanged: (selected) async {
          if (selected ?? false) {
            var result = await Navigator.pushNamed(
                    context, NewIngredientScreen.id, arguments: item)
                as RecipeIngredientModel?;
            if (result == null) {
              return;
            } else if (!result.isDeleted) {
              model.setAmount(i, result.amount);
              model.setIngredient(i, result.ingredient);
              model.setScale(i, result.unitOfMeasure);
            } else if (result.isDeleted) {
              model.removeIngredient(i);
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
            Text(item.name),
          ),
          DataCell(
            Text(''),
            // IconButton(
            //   icon: Icon(Icons.edit),
            //   onPressed: () async {
            //     var result = await Navigator.pushNamed(
            //             context, NewIngredientScreen.id, arguments: item)
            //         as RecipeIngredientModel?;
            //     if (result != null && !result.isDeleted) {
            //       model.setAmount(i, result.amount);
            //       model.setIngredient(i, result.ingredient);
            //       model.setScale(i, result.unitOfMeasure);
            //     } else {
            //       model.removeIngredient(i);
            //     }
            //   },
            // ),
          ),
        ],
      ),
    );
  }
  return widgets;
}

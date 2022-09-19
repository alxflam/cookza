import 'package:cookza/components/round_icon_button.dart';
import 'package:cookza/constants.dart';
import 'package:cookza/model/entities/abstract/ingredient_group_entity.dart';
import 'package:cookza/model/entities/mutable/mutable_ingredient_note.dart';
import 'package:cookza/screens/new_ingredient_screen.dart';
import 'package:cookza/screens/util/wrapper.dart';
import 'package:cookza/viewmodel/ingredient_screen_model.dart';
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
  final _leastRecentlyUsedGroup = Wrapper<IngredientGroupEntity>(null);

  IngredientStepContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// create an initial group if there not yet any groups
    final model = context.read<RecipeEditModel>().ingredientStepModel;
    if (model.groups.isEmpty) {
      final defaultName = AppLocalizations.of(context).ingredient(2);
      model.addGroup(defaultName);
    }

    return ChangeNotifierProvider.value(
      value: Provider.of<RecipeEditModel>(context, listen: false)
          .ingredientStepModel,
      child: Consumer<RecipeIngredientEditStep>(
        builder: (context, model, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _getServingsRow(model, context),
              // TODO Prio 2 separate table for every ingredient group
              // then long group names can span horizontally
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
                ],
                rows: _getIngredientRows(context, model),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _addNewIngredient(
      BuildContext context, RecipeIngredientEditStep model) async {
    final rootModel = Provider.of<RecipeEditModel>(context, listen: false);
    RecipeIngredientModel ingModel = RecipeIngredientModel.of(
        MutableIngredientNote.empty(),
        sourceRecipe: rootModel.targetEntity.id);

    var result = await Navigator.pushNamed(
      context,
      NewIngredientScreen.id,
      arguments: IngredientScreenModel(
          model: ingModel,
          supportsRecipeReference: true,
          requiresIngredientGroup: true,
          groups: model.groups,
          group: _leastRecentlyUsedGroup.value ??
              (model.groups.isNotEmpty ? model.groups.first : null)),
    ) as IngredientScreenModel?;

    if (result != null && !result.model.isDeleted) {
      model.addNewIngredient(result.model, result.group!);
      _leastRecentlyUsedGroup.value = result.group!;
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
        _getAddRowButton(context, model),
      ],
    );
  }

  Widget _getAddRowButton(
      BuildContext context, RecipeIngredientEditStep model) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary),
      onPressed: () async => await _addNewIngredient(context, model),
      child: Text(AppLocalizations.of(context).addIngredient),
    );
  }
}

List<DataRow> _getIngredientRows(
    BuildContext context, RecipeIngredientEditStep model) {
  List<DataRow> widgets = [];

  /// iterate over every group
  for (var group in model.groups) {
    /// if there's more than one group print a header line with the groups name
    /// but only print groups with ingredients (while editing there may exist a group without assigned ingredients)
    if (model.groups.length > 1 && group.ingredients.isNotEmpty) {
      widgets.add(
        DataRow(
          cells: [
            DataCell(
              Text(
                group.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
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
      var item = RecipeIngredientModel.of(group.ingredients[i]);
      widgets.add(
        DataRow(
          onSelectChanged: (selected) async {
            if (selected ?? false) {
              var result = await Navigator.pushNamed(
                context,
                NewIngredientScreen.id,
                arguments: IngredientScreenModel(
                    model: item,
                    supportsRecipeReference: true,
                    requiresIngredientGroup: true,
                    groups: model.groups,
                    group: group),
              ) as IngredientScreenModel?;

              if (result == null) {
                return;
              } else if (!result.model.isDeleted) {
                model.setAmount(i, result.model.amount, group);
                model.setIngredient(i, result.model.ingredient, group);
                model.setScale(i, result.model.unitOfMeasure, group);
                if (group != result.group && result.group != null) {
                  // group assignment changed
                  model.changeGroup(i, group, result.group!);
                }
              } else if (result.model.isDeleted) {
                model.removeIngredient(i, group);
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
          ],
        ),
      );
    }
  }

  return widgets;
}

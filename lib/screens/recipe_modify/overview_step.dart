import 'package:cookza/model/entities/abstract/recipe_collection_entity.dart';
import 'package:cookza/model/entities/abstract/recipe_entity.dart';
import 'package:cookza/services/recipe/recipe_manager.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/viewmodel/recipe_edit/recipe_edit_model.dart';
import 'package:cookza/viewmodel/recipe_edit/recipe_edit_step.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

Step getOverviewStep(BuildContext context) {
  return Step(
    title: Container(),
    isActive:
        Provider.of<RecipeEditModel>(context, listen: false).currentStep == 0,
    state: StepState.indexed,
    content: FutureBuilder<List<RecipeCollectionEntity>>(
      future: sl.get<RecipeManager>().collections,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          // return progress indicator until the future has finished
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        /// if there are no collections, render a error card
        if (snapshot.connectionState == ConnectionState.done &&
            (!snapshot.hasData || snapshot.data!.isEmpty)) {
          return Card(
            child: ListTile(
              leading: const Icon(
                Icons.error,
                color: Colors.red,
              ),
              title: Text(AppLocalizations.of(context)
                  .mandatoryRecipeGroupNotAvailable),
              subtitle:
                  Text(AppLocalizations.of(context).createMandatoryRecipeGroup),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          var _model = Provider.of<RecipeEditModel>(context, listen: false)
              .overviewStepModel;

          final nameController = TextEditingController(text: _model.name);
          final descController =
              TextEditingController(text: _model.description);

          nameController.addListener(
            () {
              _model.name = nameController.text;
            },
          );

          descController.addListener(
            () {
              _model.description = descController.text;
            },
          );

          return ChangeNotifierProvider.value(
            value: _model,
            child: Consumer<RecipeOverviewEditStep>(
              builder: (context, model, child) {
                return Column(
                  children: <Widget>[
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).recipeName),
                      controller: nameController,
                    ),
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).recipeDesc),
                      controller: descController,
                    ),
                    _getCollectionDropDown(context, model, snapshot.data!),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('${AppLocalizations.of(context).duration}:'),
                        Flexible(
                          flex: 1,
                          child: Slider(
                            min: 1,
                            max: 120,
                            divisions: 12,
                            label: '${model.duration}',
                            onChanged: (double value) {
                              model.duration = value.toInt();
                            },
                            value: model.duration.toDouble(),
                            activeColor: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Container(
                          width: 50,
                          alignment: Alignment.center,
                          child: Text('${model.duration} min'),
                        ),
                      ],
                    ),
                    Wrap(
                      spacing: 5,
                      children: <Widget>[
                        DifficultyChip(DIFFICULTY.EASY, model),
                        DifficultyChip(DIFFICULTY.MEDIUM, model),
                        DifficultyChip(DIFFICULTY.HARD, model),
                      ],
                    )
                  ],
                );
              },
            ),
          );
        }

        return Container();
      },
    ),
  );
}

Widget _getCollectionDropDown(BuildContext context,
    RecipeOverviewEditStep model, List<RecipeCollectionEntity> collections) {
  if (collections.isEmpty) {
    return Container();
  }

  List<DropdownMenuItem<RecipeCollectionEntity>> items = collections
      .map((item) => DropdownMenuItem<RecipeCollectionEntity>(
          value: item, child: Text(item.name)))
      .toList();

  model.collection ??= collections.first;

  var selectedCollection =
      collections.firstWhere((e) => e.id == model.collection!.id);

  return DropdownButtonFormField<RecipeCollectionEntity>(
    value: selectedCollection,
    items: items,
    decoration: InputDecoration(
      isDense: true,
      labelText: AppLocalizations.of(context).recipeGroup,
    ),
    onChanged: (RecipeCollectionEntity? value) {
      model.collection = value;
    },
  );
}

class DifficultyChip extends StatelessWidget {
  final DIFFICULTY _difficulty;
  final RecipeOverviewEditStep _model;

  const DifficultyChip(this._difficulty, this._model, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: _getLabel(context),
      onSelected: (value) {
        _model.difficulty = this._difficulty;
      },
      selected: _model.difficulty == this._difficulty,
      checkmarkColor: Theme.of(context).colorScheme.primary,
    );
  }

  Widget _getLabel(BuildContext context) {
    switch (this._difficulty) {
      case DIFFICULTY.EASY:
        return Text(AppLocalizations.of(context).difficultyEasy);
      case DIFFICULTY.MEDIUM:
        return Text(AppLocalizations.of(context).difficultyMedium);
      case DIFFICULTY.HARD:
        return Text(AppLocalizations.of(context).difficultyHard);
      default:
        return const Text('unknown');
    }
  }
}

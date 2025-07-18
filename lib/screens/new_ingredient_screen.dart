import 'package:cookza/components/alert_dialog_title.dart';
import 'package:cookza/components/recipe_list_tile.dart';
import 'package:cookza/constants.dart';
import 'package:cookza/model/entities/abstract/ingredient_group_entity.dart';
import 'package:cookza/model/entities/abstract/recipe_entity.dart';
import 'package:cookza/model/entities/mutable/mutable_ingredient_group.dart';
import 'package:cookza/services/recipe/recipe_manager.dart';
import 'package:cookza/viewmodel/ingredient_screen_model.dart';
import 'package:cookza/viewmodel/recipe_edit/recipe_ingredient_model.dart';
import 'package:cookza/viewmodel/recipe_selection_model.dart';
import 'package:cookza/screens/recipe_selection_screen.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/services/unit_of_measure.dart';
import 'package:cookza/viewmodel/recipe_view/recipe_view_model.dart';
import 'package:flutter/material.dart';
import 'package:cookza/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class NewIngredientScreen extends StatelessWidget {
  static const String id = 'ingredient';

  const NewIngredientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    final screenModel =
        ModalRoute.of(context)!.settings.arguments as IngredientScreenModel;

    return ChangeNotifierProvider<RecipeIngredientModel>.value(
      value: screenModel.model,
      child: Consumer<RecipeIngredientModel>(builder: (context, model, child) {
        var amountController =
            TextEditingController(text: kFormatAmount(model.amount));
        amountController.addListener(() {
          final parsedAmount = _stringToDouble(amountController.text);
          model.amount = parsedAmount ?? 0;
        });

        var inputWidgets = <Widget>[];
        if (screenModel.requiresIngredientGroup) {
          final groups =
              ValueNotifier<List<IngredientGroupEntity>>(screenModel.groups);
          // initially either the given group is selected or the first of all available groups
          screenModel.group = screenModel.group ??
              (groups.value.isNotEmpty ? groups.value.first : null);
          inputWidgets.add(
            ValueListenableBuilder<List<IngredientGroupEntity>>(
              valueListenable: groups,
              builder: (context, value, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: DropdownButtonFormField<IngredientGroupEntity>(
                        value: screenModel.group,
                        items: value
                            .map(
                              (e) => DropdownMenuItem<IngredientGroupEntity>(
                                value: e,
                                child: Text(e.name),
                              ),
                            )
                            .toList(),
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: AppLocalizations.of(context).groupName,
                        ),
                        onChanged: (IngredientGroupEntity? value) {
                          screenModel.group = value!;
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        final group =
                            await _createGroup(context, screenModel, null);
                        if (group != null) {
                          final newList = [...groups.value, group];
                          // select the created group
                          screenModel.group = group;
                          // and update the value listenable
                          groups.value = newList;
                        }
                      },
                      icon: const Icon(Icons.add),
                    ),
                    IconButton(
                      onPressed: () async {
                        final group = await _createGroup(
                            context, screenModel, screenModel.group);
                        if (group != null) {
                          final t = screenModel.group;
                          if (t is MutableIngredientGroup) {
                            t.name = group.name;
                            final newList = [...groups.value];
                            // select the created group
                            screenModel.group = t;
                            // and update the value listenable
                            groups.value = newList;
                          }
                        }
                      },
                      icon: const Icon(Icons.edit),
                    ),
                  ],
                );
              },
            ),
          );
        }

        inputWidgets.addAll(
          <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                        isDense: true,
                        labelText: AppLocalizations.of(context).amount),
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        // it's fine to provide no amount
                        return null;
                      }

                      var numValue = _stringToDouble(value);
                      if (numValue == null || numValue == 0) {
                        return AppLocalizations.of(context)
                            .validationEnterNumber;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Builder(
                  builder: (context) {
                    if (model.isRecipeReference) {
                      return Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                              isDense: true,
                              labelText: AppLocalizations.of(context).unit),
                          keyboardType: TextInputType.number,
                          initialValue: model.uomDisplayText,
                          enabled: false,
                        ),
                      );
                    } else {
                      List<UnitOfMeasure> uoms =
                          sl.get<UnitOfMeasureProvider>().getVisible();
                      List<DropdownMenuItem<UnitOfMeasure>> items = uoms
                          // todo null check on uom
                          // let it not be null, but have an empty uom instead
                          // which returns an empty string instead of trying to translate the id
                          .map((uom) => DropdownMenuItem<UnitOfMeasure>(
                                value: uom,
                                child: Text(uom.getDisplayName(
                                    amountController.text.isNotEmpty
                                        ? double.parse(amountController.text)
                                            .toInt()
                                        : 0)),
                              ))
                          .toList();
                      return Expanded(
                        child: DropdownButtonFormField<UnitOfMeasure>(
                          value: uoms.contains(model.uom) ? model.uom : null,
                          items: items,
                          decoration: InputDecoration(
                            isDense: true,
                            labelText: AppLocalizations.of(context).unit,
                          ),
                          onChanged: (UnitOfMeasure? value) {
                            model.uom = value!;
                          },
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
            _getRecipeWidget(model, context),
            const SizedBox(
              height: 8,
            ),
            _getRecipeRefButton(context, model),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    style: kRaisedGreenButtonStyle,
                    onPressed: () {
                      // check whether either a recipe ref is selected or the ingredient name is given
                      try {
                        if (formKey.currentState?.validate() ?? true) {
                          model.validate(context);
                          Navigator.pop(context, screenModel);
                        }
                      } catch (e) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: AlertDialogTitle(
                                title: AppLocalizations.of(context).error,
                              ),
                              content: Text(e.toString()),
                            );
                          },
                        );
                      }
                    },
                    child: const Icon(Icons.save),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: ElevatedButton(
                    style: kRaisedGreyButtonStyle,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.cancel),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: ElevatedButton(
                    style: kRaisedRedButtonStyle,
                    onPressed: () {
                      model.setDeleted();
                      Navigator.pop(context, screenModel);
                    },
                    child: const Icon(Icons.delete),
                  ),
                ),
              ],
            ),
          ],
        );

        return Scaffold(
          appBar: AppBar(
            title: Text(model.name),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: inputWidgets,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  /// Transforms a string to a double
  double? _stringToDouble(final String text) {
    var parsedAmount = double.tryParse(text);
    // if the user used a comma as decimal separator tryParse will return null
    if (parsedAmount == null && text.contains(',')) {
      final adjustedText = text.replaceAll(',', '.');
      parsedAmount = double.tryParse(adjustedText);
    }
    return parsedAmount;
  }

  Widget _getRecipeWidget(RecipeIngredientModel model, BuildContext context) {
    if (model.isRecipeReference) {
      return RecipeListTile(item: model.recipe!.recipe);
    } else {
      var ingredientController = TextEditingController(text: model.name);
      ingredientController
          .addListener(() => model.name = ingredientController.text);

      return IngredientNameTextInput(
          ingredientController: ingredientController);
    }
  }

  Widget _getRecipeRefButton(
      BuildContext context, RecipeIngredientModel model) {
    if (model.supportsRecipeReference) {
      return ElevatedButton.icon(
        onPressed: () async {
          if (model.isRecipeReference) {
            // remove reference
            model.removeRecipeReference();
          } else {
            final navigator = Navigator.of(context);
            // fetch all recipes the app currently stores
            var recipes = await sl.get<RecipeManager>().getAllRecipes();
            // create the view model with type reference ingredient
            // and prevent referencing itself
            var selModel = RecipeSelectionModel.forReferenceIngredient(
                recipes.map((e) => RecipeViewModel.of(e)).toList(),
                [model.sourceRecipe ?? '']);
            // navigate to the selection screen
            var result = await navigator.pushNamed(RecipeSelectionScreen.id,
                arguments: selModel) as RecipeEntity?;
            if (result != null) {
              await model.setRecipeReference(result.id);
            }
          }
        },
        icon: model.isRecipeReference
            ? const Icon(Icons.delete)
            : const Icon(Icons.note_add),
        label: model.isRecipeReference
            ? Text(AppLocalizations.of(context).removeRecipe)
            : Text(AppLocalizations.of(context).referToRecipe),
      );
    }
    return Container();
  }
}

class IngredientNameTextInput extends StatelessWidget {
  const IngredientNameTextInput(
      {required this.ingredientController, super.key});

  final TextEditingController ingredientController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
          labelText: AppLocalizations.of(context).ingredient(1)),
      controller: ingredientController,
      keyboardType: TextInputType.text,
    );
  }
}

Future<IngredientGroupEntity?> _createGroup(BuildContext context,
    IngredientScreenModel model, IngredientGroupEntity? group) {
  return showDialog<IngredientGroupEntity?>(
    context: context,
    builder: (context) {
      final nameController = TextEditingController(text: group?.name ?? '');

      return SimpleDialog(
        children: [
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  controller: nameController,
                  style: const TextStyle(fontSize: 20),
                  autofocus: true,
                  maxLines: 1,
                  decoration: InputDecoration(
                      hintText: AppLocalizations.of(context).groupName),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: () {
                final adaptedGroup = MutableIngredientGroup.forValues(
                    1, nameController.text, []);

                Navigator.pop(context, adaptedGroup);
              },
              child: const Icon(Icons.save),
            ),
          ),
        ],
      );
    },
  );
}

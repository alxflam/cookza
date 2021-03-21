import 'package:cookza/components/alert_dialog_title.dart';
import 'package:cookza/components/recipe_list_tile.dart';
import 'package:cookza/constants.dart';
import 'package:cookza/model/entities/abstract/recipe_entity.dart';
import 'package:cookza/services/recipe/recipe_manager.dart';
import 'package:cookza/viewmodel/recipe_edit/recipe_ingredient_model.dart';
import 'package:cookza/viewmodel/recipe_selection_model.dart';
import 'package:cookza/screens/recipe_selection_screen.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/services/unit_of_measure.dart';
import 'package:cookza/viewmodel/recipe_view/recipe_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class NewIngredientScreen extends StatelessWidget {
  static final String id = 'ingredient';

  @override
  Widget build(BuildContext context) {
    final _model =
        ModalRoute.of(context)!.settings.arguments as RecipeIngredientModel;

    return ChangeNotifierProvider<RecipeIngredientModel>.value(
      value: _model,
      child: Consumer<RecipeIngredientModel>(builder: (context, model, child) {
        var amountController =
            TextEditingController(text: kFormatAmount(model.amount));
        amountController.addListener(() {
          var parsedAmount = double.tryParse(amountController.text);
          model.amount = parsedAmount ?? 0;
        });

        return Scaffold(
          appBar: AppBar(
            title: Text(model.name),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                              isDense: true,
                              labelText: AppLocalizations.of(context)!.amount),
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!
                                  .validationEnterNumber;
                            }

                            var numValue = double.tryParse(value);
                            if (numValue == 0) {
                              return AppLocalizations.of(context)!
                                  .validationEnterNumber;
                            }
                            return '';
                          },
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Builder(
                        builder: (context) {
                          if (model.isRecipeReference) {
                            return Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                    isDense: true,
                                    labelText:
                                        AppLocalizations.of(context)!.unit),
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
                                      child: Text(uom.getDisplayName(
                                          amountController.text.isNotEmpty
                                              ? double.parse(
                                                      amountController.text)
                                                  .toInt()
                                              : 0)),
                                      value: uom,
                                    ))
                                .toList();
                            return Expanded(
                              child: DropdownButtonFormField<UnitOfMeasure>(
                                  value: uoms.contains(model.uom)
                                      ? model.uom
                                      : null,
                                  items: items,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    labelText:
                                        AppLocalizations.of(context)!.unit,
                                  ),
                                  onChanged: (UnitOfMeasure? value) {
                                    model.uom = value!;
                                  }),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  _getRecipeWidget(model, context),
                  SizedBox(
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
                              model.validate();
                              Navigator.pop(context, model);
                            } catch (e) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: AlertDialogTitle(
                                      title:
                                          AppLocalizations.of(context)!.error,
                                    ),
                                    content: Text(e.toString()),
                                  );
                                },
                              );
                            }
                          },
                          child: Icon(Icons.save),
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          style: kRaisedGreyButtonStyle,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.cancel),
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          style: kRaisedRedButtonStyle,
                          onPressed: () {
                            model.setDeleted();
                            Navigator.pop(context, model);
                          },
                          child: Icon(Icons.delete),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
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
            // fetch all recipes the app currently stores
            var recipes = await sl.get<RecipeManager>().getAllRecipes();
            // create the view model with type reference ingredient
            // TODO: add calling recipe id to model and pass it as list to factory!
            var selModel = RecipeSelectionModel.forReferenceIngredient(
                recipes.map((e) => RecipeViewModel.of(e)).toList(), []);
            // navigate to the selection screen
            var result = await Navigator.pushNamed(
                    context, RecipeSelectionScreen.id, arguments: selModel)
                as RecipeEntity;
            if (result != null) {
              await model.setRecipeReference(result.id);
            }
          }
        },
        icon:
            model.isRecipeReference ? Icon(Icons.delete) : Icon(Icons.note_add),
        label: model.isRecipeReference
            ? Text(AppLocalizations.of(context)!.removeRecipe)
            : Text(AppLocalizations.of(context)!.referToRecipe),
      );
    }
    return Container();
  }
}

class IngredientNameTextInput extends StatelessWidget {
  const IngredientNameTextInput({
    required this.ingredientController,
  });

  final TextEditingController ingredientController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
          labelText: AppLocalizations.of(context)!.ingredient(1)),
      controller: ingredientController,
      keyboardType: TextInputType.text,
    );
  }
}

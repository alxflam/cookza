import 'package:cookza/components/recipe_list_tile.dart';
import 'package:cookza/constants.dart';
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
    final RecipeIngredientModel _model =
        ModalRoute.of(context).settings.arguments;
    assert(_model != null);

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
                              labelText: AppLocalizations.of(context).amount),
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            var numValue = double.tryParse(value);
                            if (value.isEmpty || numValue == 0) {
                              // TODO: replace with localized string
                              return 'Please provide a number';
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
                                        AppLocalizations.of(context).unit),
                                keyboardType: TextInputType.number,
                                initialValue: model.uomDisplayText,
                                enabled: false,
                              ),
                            );
                          } else {
                            List<UnitOfMeasure> uoms =
                                sl.get<UnitOfMeasureProvider>().getVisible();
                            List<DropdownMenuItem> items = uoms
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
                                        AppLocalizations.of(context).unit,
                                  ),
                                  onChanged: (UnitOfMeasure value) {
                                    model.uom = value;
                                  }),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  // TODO: from here on column shown only if model supports recipe reference...
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      _getRecipeWidget(model, context),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  _getRecipeRefButton(context, model),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.pop(context, model);
                          },
                          child: Icon(Icons.save),
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.cancel),
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: RaisedButton(
                          onPressed: () {
                            model.setDeleted();
                            Navigator.pop(context, model);
                          },
                          child: Icon(Icons.delete),
                          color: Colors.red,
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
      return RecipeListTile(item: model.recipe.recipe);
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
      return RaisedButton.icon(
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
                as String;
            if (result != null && result.isNotEmpty) {
              await model.setRecipeReference(result);
            }
          }
        },
        icon:
            model.isRecipeReference ? Icon(Icons.delete) : Icon(Icons.note_add),
        label: model.isRecipeReference
            ? Text(AppLocalizations.of(context).removeRecipe)
            : Text(AppLocalizations.of(context).referToRecipe),
      );
    }
    return Container();
  }
}

class IngredientNameTextInput extends StatelessWidget {
  const IngredientNameTextInput({
    @required this.ingredientController,
  });

  final TextEditingController ingredientController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFormField(
        decoration: InputDecoration(
            labelText: AppLocalizations.of(context).ingredient(1)),
        controller: ingredientController,
        keyboardType: TextInputType.text,
      ),
    );
  }
}

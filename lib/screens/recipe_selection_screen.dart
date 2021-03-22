import 'package:cookza/components/future_progress_dialog.dart';
import 'package:cookza/services/recipe/recipe_manager.dart';
import 'package:cookza/viewmodel/recipe_selection_model.dart';
import 'package:cookza/services/abstract/pdf_export.dart';
import 'package:cookza/services/abstract/pdf_generator.dart';
import 'package:cookza/services/abstract/recipe_file_export.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

typedef OnActionButtonPressed = void Function(
    BuildContext context, RecipeSelectionModel model);

class RecipeSelectionScreen extends StatelessWidget {
  static final String id = 'selection';

  Text _getTitle(RecipeSelectionModel model, BuildContext context) {
    return model.countSelected == 0
        ? Text(
            AppLocalizations.of(context)!.selectRecipes,
          )
        : Text(
            '${model.countSelected} ${AppLocalizations.of(context)!.recipe(model.countSelected)}',
          );
  }

  @override
  Widget build(BuildContext context) {
    final _model =
        ModalRoute.of(context)!.settings.arguments as RecipeSelectionModel;

    final IconData _icon = _getIconForMode(_model.mode);
    final OnActionButtonPressed _onPressed =
        _getOnPressedCallbackForMode(_model.mode);

    return ChangeNotifierProvider<RecipeSelectionModel>.value(
      value: _model,
      child: Consumer<RecipeSelectionModel>(
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: _getTitle(model, context),
              actions: <Widget>[
                IconButton(
                    icon: FaIcon(_icon),
                    onPressed: () {
                      _onPressed(context, model);
                    })
              ],
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SelectButton(
                        icon: Icons.check_box_outlined,
                        text: AppLocalizations.of(context)!.selectAll,
                        onTap: () => model.selectAll()),
                    SelectButton(
                        icon: Icons.check_box_outline_blank,
                        text: AppLocalizations.of(context)!.deselectAll,
                        onTap: () => model.deselectAll()),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) {
                      model.filter(value);
                    },
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.search,
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                Flexible(
                  child: ListView.builder(
                    itemCount: model.countAll,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: _getLeadingIcon(context, model, index),
                        title: Text(
                          model.getRecipeName(index),
                        ),
                        onTap: () {
                          model.switchSelection(index);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _getLeadingIcon(
      BuildContext context, RecipeSelectionModel model, int index) {
    if (model.isMultiSelection) {
      return model.isSelected(index)
          ? Icon(
              Icons.check_box,
              color: Theme.of(context).colorScheme.primary,
            )
          : Icon(Icons.check_box_outline_blank);
    } else {
      return model.isSelected(index)
          ? Icon(
              Icons.radio_button_checked,
              color: Theme.of(context).colorScheme.primary,
            )
          : Icon(Icons.radio_button_unchecked);
    }
  }

  IconData _getIconForMode(SELECTION_MODE mode) {
    switch (mode) {
      case SELECTION_MODE.EXPORT_PDF:
      case SELECTION_MODE.EXPORT:
        return FontAwesomeIcons.fileExport;
      case SELECTION_MODE.IMPORT:
        return FontAwesomeIcons.fileImport;
      case SELECTION_MODE.REFERENCE_INGREDIENT:
      case SELECTION_MODE.ADD_TO_MEAL_PLAN:
        return FontAwesomeIcons.check;
      default:
        return Icons.device_unknown;
    }
  }

  OnActionButtonPressed _getOnPressedCallbackForMode(SELECTION_MODE mode) {
    switch (mode) {
      case SELECTION_MODE.EXPORT:
        return (context, model) async {
          sl
              .get<RecipeFileExport>()
              .exportRecipesFromEntity(model.selectedRecipeEntities);
          Navigator.pop(context);
        };
      case SELECTION_MODE.EXPORT_PDF:
        return (context, model) async {
          var doc = await sl
              .get<PDFGenerator>()
              .generatePDF(model.selectedRecipeViewModels);
          sl.get<PDFExporter>().export(doc);
          Navigator.pop(context);
        };
      case SELECTION_MODE.IMPORT:
        return (context, model) async {
          var recipes = model.getSelectedRecipes();
          var future = sl.get<RecipeManager>().importRecipes(recipes);
          await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => SimpleDialog(
                    title: Center(
                        child: Text(AppLocalizations.of(context)!
                            .importingRecipes(recipes.length))),
                    children: [FutureProgressDialog(future)],
                  ));
          Navigator.pop(context);
        };
      case SELECTION_MODE.REFERENCE_INGREDIENT:
      case SELECTION_MODE.ADD_TO_MEAL_PLAN:
        return (context, model) async {
          if (model.selectedRecipes.isNotEmpty) {
            Navigator.pop(context, model.selectedRecipeEntities.first);
          }
        };
    }
  }
}

class SelectButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const SelectButton(
      {required this.icon, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: ElevatedButton(
          onPressed: this.onTap,
          child: Row(
            children: [
              Icon(this.icon),
              SizedBox(
                width: 8,
              ),
              Text(this.text)
            ],
          ),
        ),
      ),
    );
  }
}

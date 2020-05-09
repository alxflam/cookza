import 'package:cookly/localization/keys.dart';
import 'package:cookly/model/view/recipe_selection_model.dart';
import 'package:cookly/services/abstract/data_store.dart';
import 'package:cookly/services/abstract/recipe_file_export.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class RecipeSelectionScreen extends StatelessWidget {
  static final String id = 'selection';

  _getTitle(RecipeSelectionModel model) {
    return model.countSelected == 0
        ? Text(
            translate(Keys.Ui_Selectrecipes),
          )
        : Text(
            '${model.countSelected} ${translatePlural(Keys.Ui_Recipe, model.countSelected)}',
          );
  }

  @override
  Widget build(BuildContext context) {
    final RecipeSelectionModel _model =
        ModalRoute.of(context).settings.arguments;

    return ChangeNotifierProvider<RecipeSelectionModel>.value(
      value: _model,
      child: Consumer<RecipeSelectionModel>(
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: _getTitle(model),
              actions: <Widget>[
                _getActionButton(model, context),
              ],
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) {
                      print('filter by $value');
                      model.filter(value);
                    },
                    decoration: InputDecoration(
                      labelText: "Search",
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: model.countAll,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: _getLeadingIcon(model, index),
                      title: Text(
                        model.getRecipeName(index),
                      ),
                      onTap: () {
                        model.switchSelection(index);
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  _getLeadingIcon(RecipeSelectionModel model, int index) {
    if (model.isMultiSelection) {
      return model.isSelected(index)
          ? Icon(
              Icons.check_box,
              color: Colors.green,
            )
          : Icon(Icons.check_box_outline_blank);
    } else {
      return model.isSelected(index)
          ? Icon(
              Icons.radio_button_checked,
              color: Colors.green,
            )
          : Icon(Icons.radio_button_unchecked);
    }
  }

  Widget _getActionButton(RecipeSelectionModel model, BuildContext context) {
    switch (model.mode) {
      case SELECTION_MODE.EXPORT:
        return IconButton(
          icon: FaIcon(FontAwesomeIcons.fileExport),
          onPressed: () {
            sl.get<RecipeFileExport>().exportRecipes(model.selectedRecipes);
            Navigator.pop(context);
          },
        );
      case SELECTION_MODE.IMPORT:
        return IconButton(
          icon: FaIcon(FontAwesomeIcons.fileImport),
          onPressed: () {
            sl.get<DataStore>().importRecipes(model.getSelectedRecipes());
            Navigator.pop(context);
          },
        );
      case SELECTION_MODE.REFERENCE_INGREDIENT:
        return IconButton(
            icon: FaIcon(FontAwesomeIcons.check),
            onPressed: model.selectedRecipes.length == 0
                ? null
                : () => Navigator.pop(context, model.selectedRecipes.first));
    }
    return Icon(Icons.device_unknown);
  }
}

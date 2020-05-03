import 'package:cookly/localization/keys.dart';
import 'package:cookly/model/recipe_selection_model.dart';
import 'package:cookly/services/data_store.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class RecipeSelectionScreen extends StatelessWidget {
  static final String id = 'recipeSelectionScreen';

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
    final RecipeSelectionModel model =
        ModalRoute.of(context).settings.arguments;

    return ChangeNotifierProvider<RecipeSelectionModel>(
      create: (BuildContext context) {
        return model;
      },
      child: Consumer<RecipeSelectionModel>(
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: _getTitle(model),
              actions: <Widget>[
                model.mode == DATA_EXCHANGE_DIRECTION.EXPORT
                    ? IconButton(
                        icon: FaIcon(FontAwesomeIcons.fileExport),
                        onPressed: () {
                          sl.get<DataStore>().exportRecipes(model.selected);
                          Navigator.pop(context);
                        },
                      )
                    : IconButton(
                        icon: FaIcon(FontAwesomeIcons.fileImport),
                        onPressed: () {
                          sl
                              .get<DataStore>()
                              .importRecipes(model.getSelectedRecipes());
                          Navigator.pop(context);
                        },
                      )
              ],
            ),
            body: ListView.builder(
              itemCount: model.countAll,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: model.isSelected(index)
                      ? Icon(
                          Icons.check_box,
                          color: Colors.green,
                        )
                      : Icon(Icons.check_box_outline_blank),
                  title: Text(
                    model.getRecipeName(index),
                  ),
                  onTap: () {
                    model.switchSelection(index);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

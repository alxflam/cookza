import 'package:cookza/components/round_icon_button.dart';
import 'package:cookza/constants.dart';
import 'package:cookza/viewmodel/meal_plan/meal_plan_item_dialog_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MealPlanItemDialog extends StatelessWidget {
  final MealPlanItemDialogModel _model;
  MealPlanItemDialog(this._model);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MealPlanItemDialogModel>.value(
      value: _model,
      builder: (context, child) {
        return Consumer<MealPlanItemDialogModel>(
          builder: (context, model, _) {
            if (model.isNote) {
              return SimpleDialog(children: [NoteItemDialog()]);
            }
            return SimpleDialog(children: [RecipeItemDialog()]);
          },
        );
      },
    );
  }
}

class RecipeItemDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MealPlanItemDialogModel>(builder: (context, model, _) {
      return Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              model.name,
              style: TextStyle(fontSize: 20),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(AppLocalizations.of(context)!.servings(model.servings ?? 1)),
              RoundIconButton(
                icon: FontAwesomeIcons.minus,
                onPress: () {
                  model.servings = model.servings! - 1;
                },
              ),
              Text(model.servings.toString()),
              RoundIconButton(
                icon: FontAwesomeIcons.plus,
                onPress: () {
                  model.servings = model.servings! + 1;
                },
              ),
            ],
          ),
          DialogButtonRow(),
        ],
      );
    });
  }
}

class NoteItemDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MealPlanItemDialogModel>(builder: (context, model, _) {
      final nameController = TextEditingController(text: model.name);
      nameController.addListener(
        () {
          model.name = nameController.text;
        },
      );

      return Column(children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: TextFormField(
            textCapitalization: TextCapitalization.sentences,
            controller: nameController,
            style: TextStyle(fontSize: 20),
            autofocus: true,
          ),
        ),
        DialogButtonRow()
      ]);
    });
  }
}

class DialogButtonRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MealPlanItemDialogModel>(builder: (context, model, _) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ElevatedButton(
            style: kRaisedGreenButtonStyle,
            child: Icon(Icons.check),
            onPressed: () {
              model.applyChanges();
              Navigator.pop(context, model);
            },
          ),
          ElevatedButton(
            style: kRaisedRedButtonStyle,
            child: Icon(Icons.delete),
            onPressed: () {
              model.setDeleted(true);
              Navigator.pop(context, model);
            },
          ),
        ],
      );
    });
  }
}

import 'package:cookly/localization/keys.dart';
import 'package:cookly/model/view/recipe_edit_model.dart';
import 'package:cookly/model/view/recipe_edit_step.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

Step getInstructionsStep(BuildContext context) {
  return Step(
    title: Container(),
    isActive:
        Provider.of<RecipeEditModel>(context, listen: false).currentStep == 4,
    state: StepState.indexed,
    content: ChangeNotifierProvider.value(
      value: Provider.of<RecipeEditModel>(context, listen: false)
          .instructionStepModel,
      child: Consumer<RecipeInstructionEditStep>(
        builder: (context, model, child) {
          return Column(
            children: <Widget>[
              FlatButton.icon(
                onPressed: () {
                  model.addEmptyInstruction();
                },
                icon: Icon(Icons.add),
                label: Text(translate(Keys.Ui_Addrow)),
              ),
              _getInstructionRows(context, model),
            ],
          );
        },
      ),
    ),
  );
}

Column _getInstructionRows(
    BuildContext context, RecipeInstructionEditStep model) {
  List<Widget> rows = [];
  if (model.instructions.length == 0) {
    return Column();
  }

  for (var i = 0; i < model.instructions.length; i++) {
    var textController =
        TextEditingController(text: model.getInstruction(i).toString());

    textController
        .addListener(() => model.setInstruction(textController.text, i));

    var row = Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            model.removeInstruction(i);
          },
        ),
        Expanded(
          child: TextFormField(
            minLines: 1,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            controller: textController,
            autofocus: true,
          ),
        ),
      ],
    );

    rows.add(row);
  }

  return Column(children: rows);
}

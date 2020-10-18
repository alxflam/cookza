import 'package:cookza/viewmodel/recipe_edit/recipe_edit_model.dart';
import 'package:cookza/viewmodel/recipe_edit/recipe_edit_step.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

Step getInstructionsStep(BuildContext context) {
  return Step(
    title: Container(),
    isActive:
        Provider.of<RecipeEditModel>(context, listen: false).currentStep == 4,
    state: StepState.indexed,
    content: InstructionsStepContent(),
  );
}

class InstructionsStepContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
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
                label: Text(AppLocalizations.of(context).addRow),
              ),
              _getInstructionRows(context, model),
            ],
          );
        },
      ),
    );
  }
}

Column _getInstructionRows(
    BuildContext context, RecipeInstructionEditStep model) {
  List<Widget> rows = [];
  if (model.instructions.isEmpty) {
    return Column();
  }

  for (var i = 0; i < model.instructions.length; i++) {
    var textController =
        TextEditingController(text: model.getInstruction(i).text);

    textController
        .addListener(() => model.setInstruction(textController.text, i));

    var autofocus =
        textController.text.isEmpty && i == model.instructions.length - 1
            ? true
            : false;

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
            autofocus: autofocus,
            minLines: 1,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            controller: textController,
          ),
        ),
      ],
    );

    rows.add(row);
  }

  return Column(children: rows);
}

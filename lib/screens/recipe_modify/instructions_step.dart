import 'package:cookza/viewmodel/recipe_edit/recipe_edit_model.dart';
import 'package:cookza/viewmodel/recipe_edit/recipe_edit_step.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:cookza/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

Step getInstructionsStep(BuildContext context) {
  return Step(
    title: Container(),
    isActive:
        Provider.of<RecipeEditModel>(context, listen: false).currentStep == 4,
    state: StepState.indexed,
    content: const InstructionsStepContent(),
  );
}

class InstructionsStepContent extends StatelessWidget {
  const InstructionsStepContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Provider.of<RecipeEditModel>(context, listen: false)
          .instructionStepModel,
      child: Consumer<RecipeInstructionEditStep>(
        builder: (context, model, child) {
          return Column(
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  model.addEmptyInstruction();
                },
                child: Text(AppLocalizations.of(context).addRow),
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
    return const Column();
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
    FocusNode? focusNode;
    if (autofocus) {
      focusNode = FocusNode();
    }

    var row = Row(
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            model.removeInstruction(i);
          },
        ),
        // TODO: does not support long press delete
        Expanded(
          child: TextFormField(
            autofocus: false,
            textCapitalization: TextCapitalization.sentences,
            focusNode: focusNode, // null on all TextFormFields but a single one
            minLines: 1,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            controller: textController,
          ),
        ),
      ],
    );

    if (focusNode != null) {
      SchedulerBinding.instance.scheduleTask(() {
        focusNode?.requestFocus();
      }, Priority.animation);
    }

    rows.add(row);
  }

  return Column(children: rows);
}

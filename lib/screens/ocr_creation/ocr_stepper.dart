import 'package:cookly/localization/keys.dart';
import 'package:cookly/screens/ocr_creation/ingredients_image_step.dart';
import 'package:cookly/screens/ocr_creation/instruction_image_step.dart';
import 'package:cookly/screens/ocr_creation/overview_image_step.dart';
import 'package:cookly/screens/recipe_modify/new_recipe_screen.dart';
import 'package:cookly/viewmodel/ocr_creation/recipe_ocr_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

class OcrCreationScreen extends StatelessWidget {
  static final String id = 'ocrCreation';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate(Keys.Functions_Textrecognition)),
      ),
      body: ChangeNotifierProvider.value(
        value: RecipeOCRModel.create(),
        child: Column(
          children: <Widget>[
            OCRRecipeStepper(),
          ],
        ),
      ),
    );
  }
}

class OCRRecipeStepper extends StatelessWidget {
  nextButtonPressed(BuildContext context) async {
    RecipeOCRModel model = Provider.of<RecipeOCRModel>(context, listen: false);
    if (model.currentStep + 1 < model.countSteps) {
      nextStep(context);
    } else {
      var recipeModel = model.toRecipeEditModel();
      Navigator.pushReplacementNamed(context, NewRecipeScreen.id,
          arguments: recipeModel);
    }
  }

  cancelButtonPressed(BuildContext context) {
    var model = Provider.of<RecipeOCRModel>(context, listen: false);
    int modelStep = model.currentStep;
    if (modelStep >= 1) {
      previousStep(context);
    } else if (model.currentStep == 0) {
      Navigator.pop(context);
    }
  }

  nextStep(BuildContext context) {
    Provider.of<RecipeOCRModel>(context, listen: false).nextStep();
  }

  previousStep(BuildContext context) {
    Provider.of<RecipeOCRModel>(context, listen: false).previousStep();
  }

  void stepPressed(BuildContext context, int step) {
    Provider.of<RecipeOCRModel>(context, listen: false).goToStep(step);
  }

  List<Step> getSteps(BuildContext context) {
    return [
      getOverviewImageStep(context),
      getIngredientsImageStep(context),
      getInstructionImageStep(context),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stepper(
        type: StepperType.horizontal,
        steps: getSteps(context),
        currentStep: Provider.of<RecipeOCRModel>(context).currentStep,
        onStepContinue: () {
          nextButtonPressed(context);
        },
        onStepTapped: (step) {
          stepPressed(context, step);
        },
        onStepCancel: () {
          cancelButtonPressed(context);
        },
      ),
    );
  }
}

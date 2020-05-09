import 'package:cookly/constants.dart';
import 'package:cookly/localization/keys.dart';
import 'package:cookly/model/view/recipe_edit_model.dart';
import 'package:cookly/screens/home_screen.dart';
import 'package:cookly/screens/recipe_modify/image_step.dart';
import 'package:cookly/screens/recipe_modify/ingredient_step.dart';
import 'package:cookly/screens/recipe_modify/instructions_step.dart';
import 'package:cookly/screens/recipe_modify/overview_step.dart';
import 'package:cookly/screens/recipe_modify/tag_step.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

class NewRecipeScreen extends StatelessWidget {
  static final String id = 'newRecipe';

  @override
  Widget build(BuildContext context) {
    var model = ModalRoute.of(context).settings.arguments as RecipeEditModel;

    return Scaffold(
      appBar: AppBar(
        title: model.isCreate
            ? Text(translate(Keys.Recipe_Createrecipe))
            : Text(translate(Keys.Recipe_Editrecipe)),
      ),
      body: ChangeNotifierProvider(
        create: (context) => model,
        child: Column(
          children: <Widget>[
            NewRecipeStepper(),
          ],
        ),
      ),
    );
  }
}

class NewRecipeStepper extends StatelessWidget {
  nextButtonPressed(BuildContext context) async {
    RecipeEditModel model =
        Provider.of<RecipeEditModel>(context, listen: false);
    if (model.currentStep + 1 < model.countSteps) {
      nextStep(context);
    } else {
      try {
        await model.save();
        Navigator.pushReplacementNamed(context, HomeScreen.id);
        // Navigator.pushReplacementNamed(context, RecipeScreen.id,
        //     arguments: model.recipeId);
      } catch (e) {
        kErrorDialog(context, 'Error occured while saving', e.toString());
      }
    }
  }

  cancelButtonPressed(BuildContext context) {
    RecipeEditModel model =
        Provider.of<RecipeEditModel>(context, listen: false);
    int modelStep = model.currentStep;
    if (modelStep >= 1) {
      previousStep(context);
    } else if (model.currentStep == 0) {
      Navigator.pop(context);
    }
  }

  nextStep(BuildContext context) {
    Provider.of<RecipeEditModel>(context, listen: false).nextStep();
  }

  previousStep(BuildContext context) {
    Provider.of<RecipeEditModel>(context, listen: false).previousStep();
  }

  List<Step> getSteps(BuildContext context) {
    return [
      getOverviewStep(context),
      getImageStep(context),
      getTagStep(context),
      getIngredientsStep(context),
      getInstructionsStep(context),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stepper(
        type: StepperType.horizontal,
        steps: getSteps(context),
        currentStep: Provider.of<RecipeEditModel>(context).currentStep,
        onStepContinue: () {
          nextButtonPressed(context);
        },
        onStepTapped: (step) {
          kNotImplementedDialog(context);
        },
        onStepCancel: () {
          cancelButtonPressed(context);
        },
      ),
    );
  }
}

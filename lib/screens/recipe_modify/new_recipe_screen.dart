import 'package:cookly/constants.dart';
import 'package:cookly/localization/keys.dart';
import 'package:cookly/screens/recipe_modify/image_step.dart';
import 'package:cookly/screens/recipe_modify/ingredient_step.dart';
import 'package:cookly/screens/recipe_modify/instructions_step.dart';
import 'package:cookly/screens/recipe_modify/overview_step.dart';
import 'package:cookly/screens/recipe_modify/tag_step.dart';
import 'package:cookly/screens/recipe_view/recipe_screen.dart';
import 'package:cookly/services/recipe_manager.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:cookly/viewmodel/recipe_edit/recipe_edit_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

Future<void> saveModel(BuildContext context, RecipeEditModel model) async {
  print('show progress indicator before save');

  try {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: [
            Center(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(25),
                    child: CircularProgressIndicator(),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );

    print('calling save on the viewmodel');
    var id = await model.save();
    print('save returned' + id);
    Navigator.pop(context);

    if (model.isCreate) {
      // create: navigate to recipe view in case save was successful
      var result = await sl.get<RecipeManager>().getRecipeById([id]);
      if (result.length == 1) {
        Navigator.pushReplacementNamed(context, RecipeScreen.id,
            arguments: result.first);
      } else {
        kErrorDialog(context, 'Could not find created recipe',
            'Manually navigate to the recipe');
        Navigator.pop(context);
      }
    } else {
      // update: just pop the screen off, user returns to recipe view
      Navigator.pop(context);
    }
  } catch (e) {
    kErrorDialog(context, 'Error occured while saving', e.toString());
  }
}

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
        actions: <Widget>[
          IconButton(
            icon: FaIcon(FontAwesomeIcons.save),
            onPressed: () async {
              saveModel(context, model);
            },
          ),
        ],
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
      saveModel(context, model);
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

  void stepPressed(BuildContext context, int step) {
    Provider.of<RecipeEditModel>(context, listen: false).goToStep(step);
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
          stepPressed(context, step);
        },
        onStepCancel: () {
          cancelButtonPressed(context);
        },
      ),
    );
  }
}

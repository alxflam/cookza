import 'package:cookza/constants.dart';
import 'package:cookza/screens/home_screen.dart';
import 'package:cookza/screens/ocr_creation/ingredients_image_step.dart';
import 'package:cookza/screens/ocr_creation/instruction_image_step.dart';
import 'package:cookza/screens/ocr_creation/overview_image_step.dart';
import 'package:cookza/screens/recipe_modify/image_step.dart';
import 'package:cookza/screens/recipe_modify/ingredient_step.dart';
import 'package:cookza/screens/recipe_modify/instructions_step.dart';
import 'package:cookza/screens/recipe_modify/overview_step.dart';
import 'package:cookza/screens/recipe_modify/tag_step.dart';
import 'package:cookza/screens/recipe_view/recipe_screen.dart';
import 'package:cookza/services/recipe/recipe_manager.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/viewmodel/recipe_edit/recipe_edit_model.dart';
import 'package:cookza/viewmodel/recipe_edit/recipe_edit_step.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

Future<void> saveModel(BuildContext context, RecipeEditModel model) async {
  // never await this future because whilst showing the dialog we want to perform the
  // ignore: unawaited_futures
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return SimpleDialog(
        children: [
          Center(
            child: Column(
              children: const [
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

  String id;
  try {
    id = await model.save(context);
  } catch (e) {
    // close progress dialog
    Navigator.pop(context);
    // show errors and exit
    kErrorDialog(context, AppLocalizations.of(context).saveRecipeValidation,
        e.toString());
    return;
  }

  if (model.isCreate) {
    // create: navigate to recipe view in case save was successful
    var result = await sl.get<RecipeManager>().getRecipeById([id]);
    if (result.length == 1) {
      await Navigator.pushNamedAndRemoveUntil(
          context, RecipeScreen.id, ModalRoute.withName(HomeScreen.id),
          arguments: result.first);
    } else {
      kErrorDialog(context, 'Could not find created recipe',
          'Manually navigate to the recipe');
      Navigator.pop(context);
    }
  } else {
    // update: just pop the screen off, user returns to recipe view and can update the view based on the returned model
    // needs to pop off two screens: progress dialog and wizard
    Navigator.pop(context);
    Navigator.pop(context, model.targetEntity);
  }
}

class NewRecipeScreen extends StatelessWidget {
  static const String id = 'newRecipe';

  const NewRecipeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var model = ModalRoute.of(context)!.settings.arguments as RecipeEditModel;

    return Scaffold(
      appBar: AppBar(
        title: model.isCreate
            ? Text(AppLocalizations.of(context).createRecipe)
            : Text(AppLocalizations.of(context).editRecipe),
        actions: <Widget>[
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.save),
            onPressed: () async {
              await saveModel(context, model);
            },
          ),
        ],
      ),
      body: ChangeNotifierProvider(
        create: (context) => model,
        child: Column(
          children: const <Widget>[
            NewRecipeStepper(),
          ],
        ),
      ),
    );
  }
}

class NewRecipeStepper extends StatelessWidget {
  const NewRecipeStepper({Key? key}) : super(key: key);

  void nextButtonPressed(BuildContext context) async {
    RecipeEditModel model =
        Provider.of<RecipeEditModel>(context, listen: false);
    if (model.currentStep + 1 < model.countSteps) {
      nextStep(context);
    } else {
      await saveModel(context, model);
    }
  }

  void cancelButtonPressed(BuildContext context) {
    RecipeEditModel model =
        Provider.of<RecipeEditModel>(context, listen: false);
    int modelStep = model.currentStep;
    if (modelStep >= 1) {
      previousStep(context);
    } else if (model.currentStep == 0) {
      Navigator.pop(context);
    }
  }

  void nextStep(BuildContext context) {
    Provider.of<RecipeEditModel>(context, listen: false).nextStep();
  }

  void previousStep(BuildContext context) {
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

  ControlsWidgetBuilder getControlsBuilder() {
    return (context, details) {
      final MaterialLocalizations localizations =
          MaterialLocalizations.of(context);

      final nextButton = ElevatedButton(
        onPressed: () => nextButtonPressed(context),
        child: Text(localizations.continueButtonLabel),
      );

      final cancelButton = ElevatedButton(
        onPressed: () => cancelButtonPressed(context),
        style: kRaisedGreyButtonStyle,
        child: Text(localizations.cancelButtonLabel),
      );

      var ocrButton = Container(
        margin: const EdgeInsetsDirectional.only(start: 8.0),
        child: TextButton(
            onPressed: () async {
              var model = Provider.of<RecipeEditModel>(context, listen: false);

              // navigate to the OCR screen
              var targetScreen = '';
              switch (model.currentStep) {
                case 0:
                  targetScreen = OCROverviewImageScreen.id;
                  break;
                case 3:
                  targetScreen = OCRIngredientsImageScreen.id;
                  break;
                case 4:
                  targetScreen = OCRInstructionsImageScreen.id;
                  break;
              }

              RecipeEditModel editModel =
                  Provider.of<RecipeEditModel>(context, listen: false);
              var result = await Navigator.pushNamed(context, targetScreen,
                  arguments: editModel);
              if (result != null && result is RecipeEditStep) {
                editModel.applyCurrentStep(result);
              }
            },
            // textColor: cancelColor,
            // textTheme: ButtonTextTheme.normal,
            child: const Icon(Icons.image)),
      );

      var buttonRow = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[nextButton, cancelButton],
      );

      var model = Provider.of<RecipeEditModel>(context);

      if (model.hasCurrentStepOCR()) {
        buttonRow.children.add(ocrButton);
      }

      return Container(
        margin: const EdgeInsets.only(top: 16.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints.tightFor(height: 48.0),
          child: buttonRow,
        ),
      );
    };
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
        controlsBuilder: getControlsBuilder(),
      ),
    );
  }
}

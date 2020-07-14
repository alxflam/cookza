import 'package:cookly/screens/ocr_creation/ocr_base_step.dart';
import 'package:cookly/viewmodel/ocr_creation/recipe_ocr_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Step getInstructionImageStep(BuildContext context) {
  return getOCRImageStep(context, 2, 'Add Instructions Image',
      Provider.of<RecipeOCRModel>(context, listen: false).instructionStepModel);
}

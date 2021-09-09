import 'package:cookza/screens/ocr_creation/ocr_base_step.dart';
import 'package:cookza/viewmodel/ocr_creation/recipe_ocr_step.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OCRIngredientsImageScreen extends StatelessWidget {
  static const String id = 'ingredientsImage';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RecipeOCRStep>.value(
        value: RecipeIngredientOCRStep(),
        child: OCRImageStep(
            AppLocalizations.of(context).functionsTextRecognition));
  }
}

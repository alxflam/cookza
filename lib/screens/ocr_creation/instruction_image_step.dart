import 'package:cookza/screens/ocr_creation/ocr_base_step.dart';
import 'package:cookza/viewmodel/ocr_creation/recipe_ocr_step.dart';
import 'package:cookza/viewmodel/recipe_edit/recipe_edit_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cookza/l10n/app_localizations.dart';

class OCRInstructionsImageScreen extends StatelessWidget {
  static const String id = 'instructionsImage';

  const OCRInstructionsImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var editModel =
        ModalRoute.of(context)!.settings.arguments as RecipeEditModel?;

    return ChangeNotifierProvider<RecipeOCRStep>.value(
        value: RecipeInstructionOCRStep(editModel: editModel),
        child: OCRImageStep(
            AppLocalizations.of(context).functionsTextRecognition));
  }
}

import 'package:cookza/screens/ocr_creation/ocr_base_step.dart';
import 'package:cookza/viewmodel/ocr_creation/recipe_ocr_step.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cookza/l10n/app_localizations.dart';

class OCROverviewImageScreen extends StatelessWidget {
  static const String id = 'overviewImage';

  const OCROverviewImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RecipeOCRStep>.value(
        value: RecipeOverviewOCRStep(),
        child: OCRImageStep(
            AppLocalizations.of(context).functionsTextRecognition));
  }
}

import 'package:cookly/screens/ocr_creation/ocr_base_step.dart';
import 'package:cookly/viewmodel/ocr_creation/recipe_ocr_step.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OCROverviewImageScreen extends StatelessWidget {
  static final String id = 'overviewImage';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RecipeOCRStep>.value(
        value: RecipeOverviewOCRStep(), child: OCRImageStep('Overview Image'));
  }
}

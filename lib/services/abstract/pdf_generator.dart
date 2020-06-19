import 'package:cookly/viewmodel/recipe_view/recipe_view_model.dart';
import 'package:pdf/widgets.dart';

abstract class PDFGenerator {
  Document generatePDF(List<RecipeViewModel> recipes);
}

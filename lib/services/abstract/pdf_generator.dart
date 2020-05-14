import 'package:cookly/model/view/recipe_view_model.dart';
import 'package:pdf/widgets.dart';

abstract class PdfGenerator {
  Document generatePDF(List<RecipeViewModel> recipes);
}

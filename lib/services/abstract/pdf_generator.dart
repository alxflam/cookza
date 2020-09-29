import 'package:cookza/viewmodel/recipe_view/recipe_view_model.dart';
import 'package:pdf/widgets.dart';

abstract class PDFGenerator {
  Future<Document> generatePDF(List<RecipeViewModel> recipes);
}

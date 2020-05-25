import 'package:cookly/constants.dart';
import 'package:pdf/widgets.dart';

abstract class PDFExporter {
  void export(Document doc);

  String getExportFileName() {
    return 'cooklyRecipes${kFileNameDateFormatter.format(DateTime.now())}';
  }
}

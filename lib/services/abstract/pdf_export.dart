import 'package:cookza/constants.dart';
import 'package:pdf/widgets.dart';

abstract class PDFExporter {
  void export(Document doc);

  String getExportFileName() {
    return 'cookzaRecipes${kFileNameDateFormatter.format(DateTime.now())}';
  }
}

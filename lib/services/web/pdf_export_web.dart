import 'dart:html' as html;

import 'package:cookza/services/abstract/pdf_export.dart';
import 'package:pdf/widgets.dart';

class PDFExporterImpl extends PDFExporter {
  @override
  void export(Document doc) async {
    final bytes = doc.save();
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = '${this.getExportFileName()}.pdf';
    html.document.body?.children.add(anchor);

    // trigger downlaod
    anchor.click();

    // remove DOM element
    html.document.body?.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }
}

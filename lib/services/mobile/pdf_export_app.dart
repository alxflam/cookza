import 'dart:io';

import 'package:cookly/services/abstract/pdf_export.dart';
import 'package:cookly/services/local_storage.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:pdf/widgets.dart';
import 'package:share_extend/share_extend.dart';

class PDFExporterImpl extends PDFExporter {
  @override
  void export(Document doc) async {
    String directory = await sl.get<StorageProvider>().getTempDirectory();
    var file = File('$directory/${this.getExportFileName()}.pdf');
    await file.writeAsBytes(doc.save());

    ShareExtend.share(file.path, 'file');
  }
}

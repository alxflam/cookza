import 'dart:io';

import 'package:cookza/services/abstract/pdf_export.dart';
import 'package:cookza/services/local_storage.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/widgets.dart';
import 'package:share_plus/share_plus.dart';

class PDFExporterImpl extends PDFExporter {
  @override
  void export(Document doc) async {
    String directory = await sl.get<StorageProvider>().getTempDirectory();
    var file = File('$directory/${this.getExportFileName()}.pdf');
    await file.writeAsBytes(await doc.save());

    await Share.shareXFiles([XFile(file.path)]);
  }
}

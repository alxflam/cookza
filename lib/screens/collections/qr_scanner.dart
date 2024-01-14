import 'package:cookza/screens/collections/camera_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

class QrScannerScreen extends StatefulWidget {
  static const String id = 'liveCameraScanner';

  const QrScannerScreen({super.key});

  @override
  QrScannerScreenState createState() => QrScannerScreenState();
}

class QrScannerScreenState extends State<QrScannerScreen> {
  BarcodeScanner barcodeScanner =
      BarcodeScanner(formats: [BarcodeFormat.qrCode]);
  bool isBusy = false;

  @override
  void dispose() {
    barcodeScanner.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CameraView(
      title: AppLocalizations.of(context).scanQRCode,
      onImage: (inputImage) => processImage(inputImage),
      hasQrCode: (inputImage) async =>
          (await barcodeScanner.processImage(inputImage)).isEmpty,
    );
  }

  Future<void> processImage(InputImage inputImage) async {
    if (isBusy) return;
    isBusy = true;
    await Future.delayed(const Duration(milliseconds: 50));
    final codes = await barcodeScanner.processImage(inputImage);
    if (codes.isNotEmpty) {
      final qrCodeValue = codes.first.rawValue;

      /// wait until we can navigate
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        final navigator = Navigator.of(context);

        /// make sure the image is at least shown and can be seen
        await Future.delayed(const Duration(seconds: 1));

        /// then return to previous page with the scanned result
        navigator.pop(qrCodeValue);
      });
    } else {
      isBusy = false;
    }

    if (mounted) {
      setState(() {});
    }
  }
}

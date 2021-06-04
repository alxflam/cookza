import 'package:cookza/screens/collections/camera_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QrScannerScreen extends StatefulWidget {
  static final String id = 'liveCameraScanner';

  @override
  _QrScannerScreenState createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  BarcodeScanner barcodeScanner =
      GoogleMlKit.vision.barcodeScanner([BarcodeFormat.qrCode]);
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
      onImage: processImage,
      hasQrCode: (inputImage) async =>
          (await barcodeScanner.processImage(inputImage)).isEmpty,
    );
  }

  Future<void> processImage(InputImage inputImage) async {
    if (isBusy) return;
    isBusy = true;
    await Future.delayed(Duration(milliseconds: 50));
    final codes = await barcodeScanner.processImage(inputImage);
    if (codes.isNotEmpty) {
      final qrCodeValue = codes.first.value.displayValue;

      /// wait until we can navigate
      SchedulerBinding.instance!.addPostFrameCallback((_) async {
        /// make sure the image is at least shown and can be seen
        await Future.delayed(Duration(seconds: 1));

        /// then return to previous page with the scanned result
        Navigator.pop(context, qrCodeValue);
      });
    } else {
      isBusy = false;
    }

    if (mounted) {
      setState(() {});
    }
  }
}

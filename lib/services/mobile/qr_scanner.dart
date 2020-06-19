import 'package:barcode_scan/barcode_scan.dart';

class QRScanner {
  Future<String> scanQRCode() async {
    var options = ScanOptions(
      restrictFormat: [BarcodeFormat.qr],
    );

    var scanResult = await BarcodeScanner.scan(options: options);
    return scanResult.rawContent;
  }
}

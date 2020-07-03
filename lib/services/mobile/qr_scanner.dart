import 'dart:convert';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:cookly/model/entities/abstract/user_entity.dart';
import 'package:cookly/model/entities/json/user_entity.dart';
import 'package:cookly/model/json/user.dart';

class QRScanner {
  Future<String> _scanQRCode() async {
    var options = ScanOptions(
      restrictFormat: [BarcodeFormat.qr],
    );

    var scanResult = await BarcodeScanner.scan(options: options);
    return scanResult.rawContent;
  }

  Future<UserEntity> scanUserQRCode() async {
    var content = await _scanQRCode();
    if (content != null && content.isNotEmpty) {
      var user = JsonUser.fromJson(jsonDecode(content));
      if (user.id == null ||
          user.id.isEmpty ||
          user.name == null ||
          user.name.isEmpty) {
        return null;
      }
      var result = UserEntityJson.from(user);
      return result;
    }
    return null;
  }
}

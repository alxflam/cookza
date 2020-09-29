import 'dart:convert';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:cookza/model/entities/abstract/user_entity.dart';
import 'package:cookza/model/entities/json/user_entity.dart';
import 'package:cookza/model/json/user.dart';

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
      // TODO: catch FormatException from jsonDecode??
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

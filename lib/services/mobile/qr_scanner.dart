import 'dart:convert';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:cookza/model/entities/abstract/user_entity.dart';
import 'package:cookza/model/entities/json/user_entity.dart';
import 'package:cookza/model/json/user.dart';

class QRScanner {
  Future<String> _scanQRCode() async {
    // TODO: needs to be implemented now with the ML Vision api as the old scan plugin got deprecated
    BarcodeDetectorOptions options =
        BarcodeDetectorOptions(barcodeFormats: BarcodeFormat.qrCode);

    // var scanResult = await BarcodeScanner.scan(options: options);
    // return scanResult.rawContent;
    return '';
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

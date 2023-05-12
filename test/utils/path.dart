import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> setupTmpAndDocumentsDir() async {
  // Create a temporary directory.
  final directory = await Directory.systemTemp.createTemp();

  // Mock out the MethodChannel for the path_provider plugin.

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMessageHandler('plugins.flutter.io/path_provider', (message) {
    // If you're getting the apps documents directory, return the path to the
    // temp directory on the test environment instead.
    final methodCall = const StandardMethodCodec().decodeMethodCall(message);
    if (methodCall.method == 'getApplicationDocumentsDirectory' ||
        methodCall.method == 'getTemporaryDirectory') {
      return Future.value(
          const StandardMethodCodec().encodeSuccessEnvelope(directory.path));
    }

    return null;
  });
}

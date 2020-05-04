import 'dart:io';

import 'package:cookly/services/local_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // Create a temporary directory.
    final directory = await Directory.systemTemp.createTemp();

    // Mock out the MethodChannel for the path_provider plugin.
    const MethodChannel('plugins.flutter.io/path_provider')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      // If you're getting the apps documents directory, return the path to the
      // temp directory on the test environment instead.
      if (methodCall.method == 'getApplicationDocumentsDirectory') {
        return directory.path;
      }

      // create sample json profile file
      final file =
          File('$directory.path/${LocalStorageProvider.profileFileName}');
      await file.writeAsString("");

      return null;
    });

    test('Deserializing Json Profile', () async {
      var cut = LocalStorageProvider();

      bool exists = await cut.profileFileExists();
      expect(exists, false);

      expect(1, 1);
    });
  });
}

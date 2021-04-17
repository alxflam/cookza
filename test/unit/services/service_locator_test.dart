import 'package:cookza/services/flutter/exception_handler.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../utils/firebase_app_mock.dart';

void main() {
  test(
    'Services are registered',
    () async {
      // initialization of firebase app is mandatory ...
      setupMockFirebaseApp();
      await Firebase.initializeApp();
      setupServiceLocator();
      expect(sl.get<ExceptionHandler>(), isNotNull);
    },
  );
}

import 'package:cookza/services/firebase_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';

class FirebaseProviderMock extends Mock implements FirebaseProvider {}

var mock = FirebaseProviderMock();

void main() {
  setUpAll(() {
    GetIt.I.registerSingleton<FirebaseProvider>(mock);
  });

  test('Parse overview', () async {});
}

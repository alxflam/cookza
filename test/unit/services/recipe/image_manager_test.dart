import 'package:cookza/services/local_storage.dart';
import 'package:cookza/services/recipe/image_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../../mocks/file_mock.dart';
import '../../../utils/firebase.dart';
import '../../../utils/firebase_app_mock.dart';

void main() {
  setUp(() async {
    setupMockFirebaseApp();
    await mockFirestore();
    await Firebase.initializeApp();
    GetIt.I.registerSingleton<StorageProvider>(LocalStorageProvider());
  });

  test('Upload file', () async {
    var cut = ImageManagerFirebase();
    var file = FakeFile();
    file.stubContent('TEST');

    await cut.uploadRecipeImage('1234', file);
    // TODO:    MissingPluginException(No implementation found for method Task#startPutFile on channel plugins.flutter.io/firebase_storage)
    // can only be implement once mocks are updated
  }, skip: true);
}

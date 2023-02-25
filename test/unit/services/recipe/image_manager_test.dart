import 'package:cookza/services/local_storage.dart';
import 'package:cookza/services/recipe/image_manager.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../../mocks/file_mock.dart';
import '../../../utils/firebase.dart';
import '../../../utils/firebase_app_mock.dart';
import '../../../utils/path.dart';
import '../../../utils/recipe_creator.dart';

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await setupTmpAndDocumentsDir();
    setupMockFirebaseApp();
    await mockFirestore();
    await Firebase.initializeApp();
    GetIt.I.registerSingleton<StorageProvider>(LocalStorageProvider());
    GetIt.I.registerSingleton<FirebaseStorage>(MockFirebaseStorage());
  });

  test('Get file path', () async {
    var cut = ImageManagerFirebase();
    final path = cut.getRecipeImagePath('1234');
    expect(path, 'images/recipe/1234.jpg');
  });

  test('Upload file', () async {
    var cut = ImageManagerFirebase();
    var file = FakeFile();
    file.stubContent('TEST');

    final recipe = RecipeCreator.createRecipe('Test');
    recipe.image = 'true';
    recipe.modificationDate = DateTime.now().subtract(const Duration(days: 1));

    await cut.uploadRecipeImage(recipe.id!, file);

    final actual = await cut.getRecipeImageFile(recipe);
    expect(actual, isNotNull);
    expect(actual!.existsSync(), true);
    expect(actual.path.endsWith('${recipe.id}.jpg'), true);
  });

  test('Get not existing image returns null', () async {
    var cut = ImageManagerFirebase();
    final recipe = RecipeCreator.createRecipe('Test');

    final actual = await cut.getRecipeImageFile(recipe);

    expect(actual, isNull);
  });
}

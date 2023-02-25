import 'package:cookza/services/local_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../utils/path.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Create a temporary directory.
    await setupTmpAndDocumentsDir();
  });

  test('Deserializing Json Profile', () async {
    var cut = LocalStorageProvider();

    String path = await cut.getImageDirectory();
    expect(path.endsWith('images'), true);
  });

  test('Exception log file exists', () async {
    var cut = LocalStorageProvider();

    var file = await cut.getExeptionLogFile();
    expect(file.existsSync(), true);
  });

  test('Update exception log file content', () async {
    var cut = LocalStorageProvider();

    var file = await cut.updateExeptionLogFile('test');
    expect(file.readAsStringSync(), 'test');
  });

  test('Clear exception log file content', () async {
    var cut = LocalStorageProvider();

    var file = await cut.updateExeptionLogFile('test');
    expect(file.readAsStringSync(), 'test');

    await cut.clearExceptionLogFile();
    expect(file.readAsStringSync(), isEmpty);
  });

  test('Get temp dir', () async {
    var cut = LocalStorageProvider();

    var dir = await cut.getTempDirectory();
    expect(dir, isNotEmpty);
  });
}

import 'package:cookly/services/abstract/data_store.dart';
import 'package:cookly/services/abstract/recipe_file_export.dart';
import 'package:cookly/services/abstract/recipe_file_import.dart';
import 'package:cookly/services/id_gen.dart';
import 'package:cookly/services/local_storage.dart';
import 'package:cookly/services/share_receive_handler.dart';
import 'package:cookly/services/similarity_service.dart';
import 'package:cookly/services/unit_of_measure.dart';
import 'package:get_it/get_it.dart';

import 'package:cookly/services/data_store.dart'
    if (dart.library.html) 'package:cookly/services/web/data_store_web.dart';
import 'package:cookly/services/mobile/recipe_file_import_app.dart'
    if (dart.library.html) 'package:cookly/services/web/recipe_file_import_web.dart';
import 'package:cookly/services/mobile/recipe_file_export_app.dart'
    if (dart.library.html) 'package:cookly/services/web/recipe_file_export_web.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  sl.registerSingleton<IdGenerator>(UniqueKeyIdGenerator());
  sl.registerSingleton<StorageProvider>(LocalStorageProvider());
  sl.registerSingleton<UnitOfMeasureProvider>(StaticUnitOfMeasure());
  sl.registerSingleton<SimilarityService>(SimilarityService());
  sl.registerSingleton<ShareReceiveHandler>(ShareReceiveHandler());
  sl.registerSingleton<RecipeFileImport>(RecipeFileImportImpl());
  sl.registerSingleton<RecipeFileExport>(RecipeFileExportImpl());

  sl.registerSingletonAsync<DataStore>(
      () async => LocalStorageDataStore().init());
}

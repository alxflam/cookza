import 'package:cookly/services/data_store.dart';
import 'package:cookly/services/id_gen.dart';
import 'package:cookly/services/local_storage.dart';
import 'package:cookly/services/share_receive_handler.dart';
import 'package:cookly/services/similarity_service.dart';
import 'package:cookly/services/unit_of_measure.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  sl.registerSingleton<IdGenerator>(UniqueKeyIdGenerator());
  sl.registerSingleton<StorageProvider>(LocalStorageProvider());
  sl.registerSingleton<UnitOfMeasureProvider>(StaticUnitOfMeasure());
  sl.registerSingleton<SimilarityService>(SimilarityService());
  sl.registerSingleton<ShareReceiveHandler>(ShareReceiveHandler());
  sl.registerSingletonAsync<DataStore>(
      () async => LocalStorageDataStore().init());
}

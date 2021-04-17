import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookza/services/abstract/pdf_export.dart';
import 'package:cookza/services/abstract/pdf_generator.dart';
import 'package:cookza/services/abstract/platform_info.dart';
import 'package:cookza/services/abstract/receive_intent_handler.dart';
import 'package:cookza/services/abstract/recipe_file_export.dart';
import 'package:cookza/services/abstract/recipe_file_import.dart';
import 'package:cookza/services/abstract/recipe_text_export.dart';
import 'package:cookza/services/abstract/shopping_list_text_export.dart';
import 'package:cookza/services/flutter/exception_handler.dart';
import 'package:cookza/services/firebase_provider.dart';
import 'package:cookza/services/recipe/image_manager.dart';
import 'package:cookza/services/image_parser.dart';
import 'package:cookza/services/recipe/ingredients_calculator.dart';
import 'package:cookza/services/local_storage.dart';
import 'package:cookza/services/meal_plan_manager.dart';
import 'package:cookza/services/mobile/receive_intent_handler_app.dart';
import 'package:cookza/services/mobile/recipe_text_export_app.dart';
import 'package:cookza/services/mobile/shopping_list_text_export.dart';
import 'package:cookza/services/flutter/navigator_service.dart';
import 'package:cookza/services/pdf_generator.dart';
import 'package:cookza/services/recipe/recipe_manager.dart';
import 'package:cookza/services/recipe/recipe_text_generator.dart';
import 'package:cookza/services/share_receive_handler.dart';
import 'package:cookza/services/shared_preferences_provider.dart';
import 'package:cookza/services/shopping_list/shopping_list_items_generator.dart';
import 'package:cookza/services/shopping_list/shopping_list_manager.dart';
import 'package:cookza/services/shopping_list/shopping_list_text_generator.dart';
import 'package:cookza/services/recipe/similarity_service.dart';
import 'package:cookza/services/unit_of_measure.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

/// recipe import: use file_picker (mobile) or open a explorer window (web)
import 'package:cookza/services/mobile/recipe_file_import_app.dart'
    if (dart.library.html) 'package:cookza/services/web/recipe_file_import_web.dart';

/// recipe export: file download (web) or ShareExtend (mobile)
import 'package:cookza/services/mobile/recipe_file_export_app.dart'
    if (dart.library.html) 'package:cookza/services/web/recipe_file_export_web.dart';

/// pdf export: file download (web) or ShareExtend (mobile)
import 'package:cookza/services/mobile/pdf_export_app.dart'
    if (dart.library.html) 'package:cookza/services/web/pdf_export_web.dart';

/// platform info: detects web or mobile environment
import 'package:cookza/services/mobile/platform_info_app.dart'
    if (dart.library.html) 'package:cookza/services/web/platform_info_web.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  sl.registerSingleton<StorageProvider>(LocalStorageProvider());
  sl.registerSingleton<UnitOfMeasureProvider>(StaticUnitOfMeasure());
  sl.registerSingleton<SimilarityService>(SimilarityService());
  sl.registerSingleton<ShareReceiveHandler>(ShareReceiveHandler());
  sl.registerSingleton<RecipeFileImport>(RecipeFileImportImpl());
  sl.registerSingleton<RecipeFileExport>(RecipeFileExportImpl());
  sl.registerSingleton<ReceiveIntentHandler>(ReceiveIntentHandlerImpl());
  sl.registerSingleton<PDFGenerator>(PDFGeneratorImpl());
  sl.registerSingleton<IngredientsCalculator>(IngredientsCalculatorImpl());
  sl.registerSingleton<PlatformInfo>(PlatformInfoImpl());
  sl.registerSingleton<PDFExporter>(PDFExporterImpl());
  sl.registerSingleton<RecipeManager>(RecipeManagerFirebase());
  sl.registerSingletonAsync<ImageManager>(() async => ImageManagerFirebase());
  sl.registerSingleton<MealPlanManager>(MealPlanManagerFirebase());
  sl.registerSingleton<NavigatorService>(NavigatorService());
  sl.registerSingleton<ImageTextExtractor>(ImageTextExtractorImpl());
  sl.registerSingleton<RecipeTextGenerator>(RecipeTextGeneratorImpl());
  sl.registerSingleton<RecipeTextExporter>(RecipeTextExporterApp());
  sl.registerSingleton<ShoppingListTextGenerator>(
      ShoppingListTextGeneratorImpl());
  sl.registerSingleton<ShoppingListTextExporter>(ShoppingListTextExporterApp());
  sl.registerSingleton<ShoppingListManager>(ShoppingListManagerImpl());
  sl.registerSingleton<ShoppingListItemsGenerator>(
      ShoppingListItemsGeneratorImpl());
  sl.registerSingleton<ExceptionHandler>(ExceptionHandlerImpl());

  sl.registerSingletonAsync<SharedPreferencesProvider>(
      () async => SharedPreferencesProviderImpl().init());

  sl.registerSingletonAsync<FirebaseProvider>(
      () async => FirebaseProvider().init(),
      dependsOn: [SharedPreferencesProvider]);
}

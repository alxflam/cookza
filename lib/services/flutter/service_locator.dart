import 'package:cookly/services/abstract/pdf_export.dart';
import 'package:cookly/services/abstract/pdf_generator.dart';
import 'package:cookly/services/abstract/platform_info.dart';
import 'package:cookly/services/abstract/receive_intent_handler.dart';
import 'package:cookly/services/abstract/recipe_file_export.dart';
import 'package:cookly/services/abstract/recipe_file_import.dart';
import 'package:cookly/services/abstract/recipe_text_export.dart';
import 'package:cookly/services/abstract/shopping_list_text_export.dart';
import 'package:cookly/services/flutter/exception_handler.dart';
import 'package:cookly/services/firebase_provider.dart';
import 'package:cookly/services/util/id_gen.dart';
import 'package:cookly/services/recipe/image_manager.dart';
import 'package:cookly/services/image_parser.dart';
import 'package:cookly/services/recipe/ingredients_calculator.dart';
import 'package:cookly/services/local_storage.dart';
import 'package:cookly/services/meal_plan_manager.dart';
import 'package:cookly/services/mobile/qr_scanner.dart';
import 'package:cookly/services/mobile/receive_intent_handler_app.dart';
import 'package:cookly/services/mobile/recipe_text_export_app.dart';
import 'package:cookly/services/mobile/shopping_list_text_export.dart';
import 'package:cookly/services/flutter/navigator_service.dart';
import 'package:cookly/services/pdf_generator.dart';
import 'package:cookly/services/recipe/recipe_manager.dart';
import 'package:cookly/services/recipe/recipe_text_generator.dart';
import 'package:cookly/services/share_receive_handler.dart';
import 'package:cookly/services/shared_preferences_provider.dart';
import 'package:cookly/services/shopping_list/shopping_list_items_generator.dart';
import 'package:cookly/services/shopping_list/shopping_list_manager.dart';
import 'package:cookly/services/shopping_list/shopping_list_text_generator.dart';
import 'package:cookly/services/recipe/similarity_service.dart';
import 'package:cookly/services/unit_of_measure.dart';
import 'package:get_it/get_it.dart';

/// recipe import: use file_picker (mobile) or open a explorer window (web)
import 'package:cookly/services/mobile/recipe_file_import_app.dart'
    if (dart.library.html) 'package:cookly/services/web/recipe_file_import_web.dart';

/// recipe export: file download (web) or ShareExtend (mobile)
import 'package:cookly/services/mobile/recipe_file_export_app.dart'
    if (dart.library.html) 'package:cookly/services/web/recipe_file_export_web.dart';

/// pdf export: file download (web) or ShareExtend (mobile)
import 'package:cookly/services/mobile/pdf_export_app.dart'
    if (dart.library.html) 'package:cookly/services/web/pdf_export_web.dart';

/// platform info: detects web or mobile environment
import 'package:cookly/services/mobile/platform_info_app.dart'
    if (dart.library.html) 'package:cookly/services/web/platform_info_web.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  sl.registerSingleton<IdGenerator>(UniqueKeyIdGenerator());
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
  sl.registerSingleton<QRScanner>(QRScanner());
  sl.registerSingleton<ImageManager>(ImageManagerFirebase());
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
      () async => FirebaseProvider().init());
}
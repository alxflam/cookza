import 'dart:async';

import 'package:cookza/constants.dart';
import 'package:cookza/routes.dart';
import 'package:cookza/screens/settings/onboarding_screen.dart';
import 'package:cookza/screens/web/web_landing_screen.dart';
import 'package:cookza/services/flutter/exception_handler.dart';
import 'package:cookza/services/flutter/navigator_service.dart';
import 'package:cookza/services/shared_preferences_provider.dart';
import 'package:cookza/viewmodel/settings/theme_model.dart';
import 'package:cookza/screens/home_screen.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupServiceLocator();
  await GetIt.I.allReady();

  /// delegating flutter exceptions (usually widget errors) is disabled for debug mode
  /// as the flutter exception handler adds more verbose output for troubleshooting
  if (kReleaseMode || kIsWeb) {
    setupFlutterErrorHandling();
    Logger.root.level = Level.OFF; // disable logging
  } else {
    /// enable logging for development builds
    Logger.root.level = Level.ALL; // log all severities
    Logger.root.onRecord.listen((record) {
      // print logs to console
      // ignore: avoid_print
      print('${record.level.name}: ${record.time}: ${record.message}');
    });
  }

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    GetIt.I
        .get<ExceptionHandler>()
        .reportException(details.exception, details.stack, DateTime.now());
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    GetIt.I
        .get<ExceptionHandler>()
        .reportException(error, stack, DateTime.now());
    return true;
  };

  /// use a custom guarded zone to run the app
  /// this enables custom handling of uncatched exceptions
  runApp(
    const ProviderChainApp(),
  );
}

/// forward all uncatched exceptions to the custom exception handler
void setupFlutterErrorHandling() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    Zone.current.handleUncaughtError(details.exception, details.stack!);
  };
}

class ProviderChainApp extends StatelessWidget {
  const ProviderChainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeModel>(
      create: (context) => ThemeModel(),
      child: const CookzaMaterialApp(),
    );
  }
}

class CookzaMaterialApp extends StatelessWidget {
  const CookzaMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kAppName,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: kDebugMode,
      theme: Provider.of<ThemeModel>(context).current,
      navigatorKey: sl.get<NavigatorService>().navigatorKey,
      initialRoute: getInitialRoute(),
      routes: kRoutes,
    );
  }

  String getInitialRoute() {
    if (kIsWeb) {
      return WebLandingPage.id;
    }

    var prefs = sl.get<SharedPreferencesProvider>();
    if (!prefs.introductionShown() ||
        !prefs.acceptedDataPrivacyStatement() ||
        !prefs.acceptedTermsOfUse()) {
      return OnBoardingScreen.id;
    }

    return HomeScreen.id;
  }
}

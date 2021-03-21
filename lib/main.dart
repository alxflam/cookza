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
  if (kReleaseMode) {
    setupFlutterErrorHandling();
  }

  /// use a custom guarded zone to run the app
  /// this enables custom handling of uncatched exceptions
  runZonedGuarded(
    () => runApp(
      ProviderChainApp(),
    ),
    (Object error, StackTrace stackTrace) => {
      // delegate exception to service
      GetIt.I
          .get<ExceptionHandler>()
          .reportException(error, stackTrace, DateTime.now())
    },
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
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeModel>(
      create: (context) => ThemeModel(),
      child: CookzaMaterialApp(),
    );
  }
}

class CookzaMaterialApp extends StatelessWidget {
  const CookzaMaterialApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kAppName,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
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

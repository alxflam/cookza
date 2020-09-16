import 'dart:async';

import 'package:cookly/localization/keys.dart';
import 'package:cookly/routes.dart';
import 'package:cookly/screens/settings/onboarding_screen.dart';
import 'package:cookly/screens/web/web_landing_screen.dart';
import 'package:cookly/services/exception_handler.dart';
import 'package:cookly/services/navigator_service.dart';
import 'package:cookly/services/shared_preferences_provider.dart';
import 'package:cookly/viewmodel/settings/theme_model.dart';
import 'package:cookly/screens/home_screen.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_translate/localization_delegate.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  var delegate = await LocalizationDelegate.create(
    fallbackLocale: 'en',
    supportedLocales: ['en', 'de'],
  );

  await Firebase.initializeApp();
  setupServiceLocator();
  await GetIt.I.allReady();

  /// delegating flutter exceptions (usually widget errors) is disbled for debug mode
  /// as the flutter exception handler adds more verbose output for troubleshooting
  if (kReleaseMode) {
    setupFlutterErrorHandling();
  }

  /// use a custom guarded zone to run the app
  /// this enables custom handling of uncatched exceptions
  runZonedGuarded(
      () => runApp(
            LocalizedApp(
              delegate,
              ProviderChainApp(),
            ),
          ),
      (Object error, StackTrace stackTrace) => {
            // delegate exception to service
            GetIt.I
                .get<ExceptionHandler>()
                .reportException(error, stackTrace, DateTime.now())
          });
}

/// forward all uncatched exceptions to the custom exception handler
void setupFlutterErrorHandling() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    Zone.current.handleUncaughtError(details.exception, details.stack);
  };
}

class ProviderChainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;

    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: ChangeNotifierProvider<ThemeModel>(
        create: (context) => ThemeModel(),
        child: CooklyMaterialApp(localizationDelegate: localizationDelegate),
      ),
    );
  }
}

class CooklyMaterialApp extends StatelessWidget {
  const CooklyMaterialApp({
    @required this.localizationDelegate,
  });

  final LocalizationDelegate localizationDelegate;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: translate(Keys.App_Title),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        localizationDelegate
      ],
      supportedLocales: localizationDelegate.supportedLocales,
      locale: localizationDelegate.currentLocale,
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

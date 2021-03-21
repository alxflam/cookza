import 'package:cookza/routes.dart';
import 'package:cookza/screens/settings/error_log_screen.dart';
import 'package:cookza/services/flutter/exception_handler.dart';
import 'package:cookza/services/shared_preferences_provider.dart';
import 'package:cookza/viewmodel/settings/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../mocks/shared_mocks.mocks.dart';

void main() {
  var observer = MockNavigatorObserver();

  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
    GetIt.I.registerSingleton<ExceptionHandler>(ExceptionHandlerImpl());
    GetIt.I.registerSingletonAsync<SharedPreferencesProvider>(
        () async => SharedPreferencesProviderImpl().init());
  });

  testWidgets('Exception tile exists', (WidgetTester tester) async {
    // open fake app
    await _initApp(tester, observer);

    expect(find.byType(ErrorLogScreen), findsOneWidget);
  });
}

Future<void> _initApp(WidgetTester tester, NavigatorObserver observer) async {
  await tester.pumpWidget(
    ChangeNotifierProvider<ThemeModel>.value(
      value: ThemeModel(),
      builder: (context, child) {
        return MaterialApp(
            routes: kRoutes,
            navigatorObservers: [observer],
            localizationsDelegates: [
              AppLocalizations.delegate,
            ],
            home: ErrorLogScreen());
      },
    ),
  );
}

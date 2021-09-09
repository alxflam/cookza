import 'package:cookza/routes.dart';
import 'package:cookza/screens/settings/error_log_screen.dart';
import 'package:cookza/services/flutter/exception_handler.dart';
import 'package:cookza/services/local_storage.dart';
import 'package:cookza/services/shared_preferences_provider.dart';
import 'package:cookza/viewmodel/settings/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../mocks/file_mock.dart';
import '../../mocks/shared_mocks.mocks.dart';

void main() {
  var observer = MockNavigatorObserver();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    GetIt.I.registerSingleton<ExceptionHandler>(ExceptionHandlerImpl());
    GetIt.I.registerSingleton<StorageProvider>(MockStorageProvider());
    GetIt.I.registerSingletonAsync<SharedPreferencesProvider>(
        () async => SharedPreferencesProviderImpl().init());
  });

  testWidgets('Exception tile exists', (WidgetTester tester) async {
    // create a log entry
    await _createLogEntry();

    // open fake app
    await _initApp(tester, observer);
    await tester.pumpAndSettle();

    expect(find.byType(ErrorLogScreen), findsOneWidget);
    expect(find.byType(ExceptionEntry), findsWidgets);
  });

  testWidgets('Tap on tile shows stacktrace', (WidgetTester tester) async {
    // create a log entry
    await _createLogEntry();

    // open fake app
    await _initApp(tester, observer);
    await tester.pumpAndSettle();

    expect(find.byType(ErrorLogScreen), findsOneWidget);
    expect(find.byType(ExceptionEntry), findsWidgets);

    await tester.tap(find.byType(ExceptionEntry));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
  });

  testWidgets('Delete entries', (WidgetTester tester) async {
    // create a log entry
    await _createLogEntry();

    // open fake app
    await _initApp(tester, observer);
    await tester.pumpAndSettle();

    expect(find.byType(ErrorLogScreen), findsOneWidget);
    expect(find.byType(ExceptionEntry), findsWidgets);

    var moreFinder = find.byIcon(Icons.more_vert);
    expect(moreFinder, findsOneWidget);
    await tester.tap(moreFinder);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
  });
}

Future _createLogEntry() async {
  var sp = GetIt.I.get<StorageProvider>();
  var file = FakeFile();

  when(sp.getExeptionLogFile()).thenAnswer((_) => Future.value(file));
  var json =
      '''{"errors":[{"error":"Some Error","stackTrace":"#0      main.<anonymous closure>","date":"01.01.2020"}]}
    ''';
  file.stubContent(json);
  file.stubExists(true);
}

Future<void> _initApp(WidgetTester tester, NavigatorObserver observer) async {
  await tester.pumpWidget(
    ChangeNotifierProvider<ThemeModel>.value(
      value: ThemeModel(),
      builder: (context, child) {
        return MaterialApp(
          routes: kRoutes,
          navigatorObservers: [observer],
          localizationsDelegates: const [
            AppLocalizations.delegate,
          ],
          home: ErrorLogScreen(),
        );
      },
    ),
  );
}

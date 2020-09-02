import 'package:cookly/routes.dart';
import 'package:cookly/screens/settings/about_screen.dart';
import 'package:cookly/screens/settings/changelog_screen.dart';
import 'package:cookly/screens/settings/onboarding_screen.dart';
import 'package:cookly/screens/settings/saved_images_screen.dart';
import 'package:cookly/services/shared_preferences_provider.dart';
import 'package:cookly/viewmodel/settings/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_translate/localization.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mocks/navigator_observer_mock.dart';

void main() {
  var observer = MockNavigatorObserver();

  setUpAll(() {
    Map<String, dynamic> translations = {};
    Localization.load(translations);
    SharedPreferences.setMockInitialValues({});
    GetIt.I.registerSingletonAsync<SharedPreferencesProvider>(
        () async => SharedPreferencesProviderImpl().init());
  });

  setUp(() {
    //
  });

  testWidgets('Onboarding tile exists', (WidgetTester tester) async {
    // open fake app
    await _initApp(tester, observer);

    var tile = find.text('settings.getStarted');
    expect(tile, findsOneWidget);

    await tester.tap(tile);
    verify(observer.didPush(any, any));
    await tester.pumpAndSettle();

    expect(find.byType(OnBoardingScreen), findsOneWidget);
  });

  testWidgets('Copyright notice exists', (WidgetTester tester) async {
    // open fake app
    await _initApp(tester, observer);

    var tile = find.text('settings.copyright');
    expect(tile, findsOneWidget);
  });

  testWidgets('Changelog tile exists', (WidgetTester tester) async {
    // open fake app
    await _initApp(tester, observer);

    var tile = find.text('settings.changelog');
    expect(tile, findsOneWidget);

    await tester.tap(tile);
    verify(observer.didPush(any, any));
    await tester.pumpAndSettle();

    expect(find.byType(ChangelogScreen), findsOneWidget);
  });

  testWidgets('Saved Images tile exists', (WidgetTester tester) async {
    // open fake app
    await _initApp(tester, observer);

    var tile = find.text('settings.localImages');
    expect(tile, findsOneWidget);

    await tester.tap(tile);
    verify(observer.didPush(any, any));
    await tester.pumpAndSettle();

    expect(find.byType(SavedImagesScreen), findsOneWidget);
  });

  testWidgets('Support tile exists', (WidgetTester tester) async {
    // open fake app
    await _initApp(tester, observer);

    var tile = find.text('settings.support');
    expect(tile, findsOneWidget);
  });

  testWidgets('Delete All Data tile exists', (WidgetTester tester) async {
    // open fake app
    await _initApp(tester, observer);

    var tile = find.text('settings.deleteAllData');
    expect(tile, findsOneWidget);

    await tester.tap(tile);
    await tester.pumpAndSettle();

    // dialog opened
    expect(find.byType(DeleteAllDataDialog), findsOneWidget);
  });

  testWidgets('License Page tile exists', (WidgetTester tester) async {
    // open fake app
    await _initApp(tester, observer);

    var tile = find.text('Licenses');
    expect(tile, findsOneWidget);
  });

  testWidgets('Privacy Statement tile exists', (WidgetTester tester) async {
    // open fake app
    await _initApp(tester, observer);

    var tile = find.text('settings.privacyStatement');
    expect(tile, findsOneWidget);
  });

  testWidgets('Terms of Use tile exists', (WidgetTester tester) async {
    // open fake app
    await _initApp(tester, observer);

    var tile = find.text('settings.termsOfUse');
    expect(tile, findsOneWidget);
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
            home: AboutScreen());
      },
    ),
  );
}

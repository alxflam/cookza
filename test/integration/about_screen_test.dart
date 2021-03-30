import 'package:cookza/constants.dart';
import 'package:cookza/routes.dart';
import 'package:cookza/screens/settings/about_screen.dart';
import 'package:cookza/screens/settings/changelog_screen.dart';
import 'package:cookza/screens/settings/error_log_screen.dart';
import 'package:cookza/screens/settings/onboarding_screen.dart';
import 'package:cookza/screens/settings/saved_images_screen.dart';
import 'package:cookza/services/shared_preferences_provider.dart';
import 'package:cookza/viewmodel/settings/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../mocks/shared_mocks.mocks.dart';

void main() {
  setUpAll(() {
    const MethodChannel('plugins.flutter.io/package_info')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getAll') {
        return <String, dynamic>{
          'appName': kAppName,
          'packageName': 'test',
          'version': '0.42.0',
          'buildNumber': '42'
        };
      }
      return null;
    });

    SharedPreferences.setMockInitialValues({});
    GetIt.I.registerSingletonAsync<SharedPreferencesProvider>(
        () async => SharedPreferencesProviderImpl().init());
  });

  testWidgets('Onboarding tile exists', (WidgetTester tester) async {
    // open fake app
    final observer = MockNavigatorObserver();
    await _initApp(tester, observer);

    var tile = find.text('Get Started');
    expect(tile, findsOneWidget);

    await tester.tap(tile);
    verify(observer.didPush(any, any));
    await tester.pumpAndSettle();

    expect(find.byType(OnBoardingScreen), findsOneWidget);
  });

  testWidgets('Copyright notice exists', (WidgetTester tester) async {
    // open fake app
    final observer = MockNavigatorObserver();
    await _initApp(tester, observer);

    var tile = find.text('© 2020 The Great Cookza Foundation');
    expect(tile, findsOneWidget);
  });

  testWidgets('Changelog tile exists', (WidgetTester tester) async {
    // open fake app
    final observer = MockNavigatorObserver();
    await _initApp(tester, observer);

    var tile = find.text('Changelog');
    expect(tile, findsOneWidget);

    await tester.tap(tile);
    verify(observer.didPush(any, any));
    await tester.pumpAndSettle();

    expect(find.byType(ChangelogScreen), findsOneWidget);
  });

  testWidgets('Saved Images tile exists', (WidgetTester tester) async {
    // open fake app
    final observer = MockNavigatorObserver();
    await _initApp(tester, observer);

    var tile = find.text('Local Images');
    expect(tile, findsOneWidget);

    await tester.tap(tile);
    verify(observer.didPush(any, any));
    await tester.pumpAndSettle();

    expect(find.byType(SavedImagesScreen), findsOneWidget);
  });

  testWidgets('Support tile exists', (WidgetTester tester) async {
    // open fake app
    final observer = MockNavigatorObserver();
    await _initApp(tester, observer);

    var tile = find.text('Support');
    expect(tile, findsOneWidget);
  });

  testWidgets('Delete All Data tile exists', (WidgetTester tester) async {
    // open fake app
    final observer = MockNavigatorObserver();
    await _initApp(tester, observer);
    await tester.pumpAndSettle();

    final tile = find.ancestor(
        of: find.text('Delete all data'), matching: find.byType(ListTile));

    // somehow tester#tap doesn't work, there invoke the onTap manually
    ListTile wd = tile.first.evaluate().first.widget as ListTile;
    wd.onTap!.call();
    await tester.pumpAndSettle();

    verify(observer.didPush(any, any));
    await tester.pumpAndSettle();

    expect(find.byType(DeleteAllDataDialog), findsOneWidget);
  });

  testWidgets('License Page tile exists', (WidgetTester tester) async {
    // open fake app
    final observer = MockNavigatorObserver();
    await _initApp(tester, observer);

    var tile = find.text('Licenses');
    expect(tile, findsOneWidget);
  });

  testWidgets('Privacy Statement tile exists', (WidgetTester tester) async {
    // open fake app
    final observer = MockNavigatorObserver();
    await _initApp(tester, observer);

    var tile = find.text('Data Privacy Statement');
    expect(tile, findsOneWidget);
  });

  testWidgets('Terms of Use tile exists', (WidgetTester tester) async {
    // open fake app
    final observer = MockNavigatorObserver();
    await _initApp(tester, observer);

    var tile = find.text('Terms of Use');
    expect(tile, findsOneWidget);
  });

  testWidgets('Error log tile exists', (WidgetTester tester) async {
    // open fake app
    final observer = MockNavigatorObserver();
    await _initApp(tester, observer);

    final tile = find.ancestor(
        of: find.text('Error Log'), matching: find.byType(ListTile));

    // somehow tester#tap doesn't work, there invoke the onTap manually
    ListTile wd = tile.first.evaluate().first.widget as ListTile;
    wd.onTap!.call();
    await tester.pumpAndSettle();

    verify(observer.didPush(any, any));
    await tester.pumpAndSettle();

    expect(find.byType(ErrorLogScreen), findsOneWidget);
  });

  testWidgets('Version is shown', (WidgetTester tester) async {
    // open fake app
    final observer = MockNavigatorObserver();
    await _initApp(tester, observer);
    await tester.pumpAndSettle();

    var tile = find.text('0.42.0 - Build 42');
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
            localizationsDelegates: [
              AppLocalizations.delegate,
            ],
            home: AboutScreen());
      },
    ),
  );
}

import 'package:cookza/routes.dart';
import 'package:cookza/screens/settings/about_screen.dart';
import 'package:cookza/screens/settings/meal_plan_settings_screen.dart';
import 'package:cookza/screens/settings/settings_screen.dart';
import 'package:cookza/screens/settings/shopping_list_settings_screen.dart';
import 'package:cookza/screens/settings/theme_settings_screen.dart';
import 'package:cookza/screens/settings/uom_visibility_settings_screen.dart';
import 'package:cookza/services/flutter/navigator_service.dart';
import 'package:cookza/services/shared_preferences_provider.dart';
import 'package:cookza/services/unit_of_measure.dart';
import 'package:cookza/viewmodel/settings/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cookza/l10n/app_localizations.dart';

import '../mocks/shared_mocks.mocks.dart';

void main() {
  var observer = MockNavigatorObserver();

  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
    GetIt.I.registerSingleton<NavigatorService>(NavigatorService());
    GetIt.I.registerSingleton<UnitOfMeasureProvider>(StaticUnitOfMeasure());
    GetIt.I.registerSingletonAsync<SharedPreferencesProvider>(
        () async => SharedPreferencesProviderImpl().init());
  });

  testWidgets('UnitOfMeasureTile tile exists', (WidgetTester tester) async {
    // open fake app
    await _initApp(tester, observer);

    var tile = find.text('Units of Measure');
    expect(tile, findsOneWidget);

    await tester.tap(tile);
    verify(observer.didPush(any, any));
    await tester.pumpAndSettle();

    // now we should have navigated to the shopping list screen
    expect(find.byType(UoMVisibilityScreen), findsOneWidget);
  });

  testWidgets('Themes tile exists', (WidgetTester tester) async {
    // open fake app
    await _initApp(tester, observer);

    var tile = find.text('Themes');
    expect(tile, findsOneWidget);

    await tester.tap(tile);
    verify(observer.didPush(any, any));
    await tester.pumpAndSettle();

    // now we should have navigated to the shopping list screen
    expect(find.byType(ThemeSettingsScreen), findsOneWidget);
  });

  testWidgets('Meal Plan tile exists', (WidgetTester tester) async {
    // open fake app
    await _initApp(tester, observer);

    var tile = find.text('Meal Planner');
    expect(tile, findsOneWidget);

    await tester.tap(tile);
    verify(observer.didPush(any, any));
    await tester.pumpAndSettle();

    // now we should have navigated to the shopping list screen
    expect(find.byType(MealPlanSettingsScreen), findsOneWidget);
  });

  testWidgets('Shopping List tile exists', (WidgetTester tester) async {
    // open fake app
    await _initApp(tester, observer);

    var tile = find.text('Shopping List');
    expect(tile, findsOneWidget);

    await tester.tap(tile);
    verify(observer.didPush(any, any));
    await tester.pumpAndSettle();

    // now we should have navigated to the shopping list screen
    expect(find.byType(ShoppingListSettingsScreen), findsOneWidget);
  });

  testWidgets('About tile exists', (WidgetTester tester) async {
    // open fake app
    await _initApp(tester, observer);

    var aboutTile = find.text('About Cookza');
    expect(aboutTile, findsOneWidget);

    await tester.tap(aboutTile);
    verify(observer.didPush(any, any));
    await tester.pumpAndSettle();

    // now we should have navigated to the shopping list screen
    expect(find.byType(AboutScreen), findsOneWidget);
  });
}

Future<void> _initApp(WidgetTester tester, NavigatorObserver observer) async {
  await tester.pumpWidget(
    ChangeNotifierProvider<ThemeModel>.value(
      value: ThemeModel(),
      builder: (context, child) {
        return MaterialApp(
            routes: kRoutes,
            navigatorKey: GetIt.I.get<NavigatorService>().navigatorKey,
            localizationsDelegates: const [
              AppLocalizations.delegate,
            ],
            navigatorObservers: [observer],
            home: const SettingsScreen());
      },
    ),
  );
}

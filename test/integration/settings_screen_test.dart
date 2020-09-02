import 'package:cookly/routes.dart';
import 'package:cookly/screens/settings/about_screen.dart';
import 'package:cookly/screens/settings/export_settings_screen.dart';
import 'package:cookly/screens/settings/meal_plan_settings_screen.dart';
import 'package:cookly/screens/settings/settings_screen.dart';
import 'package:cookly/screens/settings/shopping_list_settings_screen.dart';
import 'package:cookly/screens/settings/theme_settings_screen.dart';
import 'package:cookly/screens/settings/uom_visibility_settings_screen.dart';
import 'package:cookly/services/shared_preferences_provider.dart';
import 'package:cookly/services/unit_of_measure.dart';
import 'package:cookly/viewmodel/settings/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_translate/localization.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mocks/navigator_observer_mock.dart';
import '../mocks/unit_of_measure_provider_mock.dart';

void main() {
  var observer = MockNavigatorObserver();

  setUpAll(() {
    Map<String, dynamic> translations = {};
    Localization.load(translations);
    SharedPreferences.setMockInitialValues({});
    GetIt.I
        .registerSingleton<UnitOfMeasureProvider>(UnitOfMeasureProviderMock());
    GetIt.I.registerSingletonAsync<SharedPreferencesProvider>(
        () async => SharedPreferencesProviderImpl().init());
  });

  setUp(() {
    //
  });

  testWidgets('Import tile exists', (WidgetTester tester) async {
    // open fake app
    await _initApp(tester, observer);

    var tile = find.text('ui.import');
    expect(tile, findsOneWidget);
  });

  testWidgets('Export tile exists', (WidgetTester tester) async {
    // open fake app
    await _initApp(tester, observer);

    var tile = find.text('ui.export');
    expect(tile, findsOneWidget);

    await tester.tap(tile);
    verify(observer.didPush(any, any));
    await tester.pumpAndSettle();

    // now we should have navigated to the shopping list screen
    expect(find.byType(ExportSettingsScreen), findsOneWidget);
  });

  testWidgets('UnitOfMeasureTile tile exists', (WidgetTester tester) async {
    // open fake app
    await _initApp(tester, observer);

    var tile = find.text('recipe.unitLongPlural');
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

    var tile = find.text('theme.title');
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

    var tile = find.text('functions.mealPlanner');
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

    var tile = find.text('functions.shoppingList');
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

    var aboutTile = find.text('About app.title');
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
            navigatorObservers: [observer],
            home: SettingsScreen());
      },
    ),
  );
}

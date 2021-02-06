import 'package:cookza/routes.dart';
import 'package:cookza/screens/shopping_list/shopping_list_detail_screen.dart';
import 'package:cookza/screens/shopping_list/shopping_list_dialog.dart';
import 'package:cookza/services/util/id_gen.dart';
import 'package:cookza/services/meal_plan_manager.dart';
import 'package:cookza/services/recipe/recipe_manager.dart';
import 'package:cookza/services/shared_preferences_provider.dart';
import 'package:cookza/services/shopping_list/shopping_list_manager.dart';
import 'package:cookza/viewmodel/settings/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../mocks/meal_plan_manager_mock.dart';
import '../mocks/navigator_observer_mock.dart';
import '../mocks/recipe_manager_mock.dart';
import '../mocks/shopping_list_manager_mock.dart';

void main() {
  var recipeManager = RecipeManagerStub();
  var mealPlanManager = MealPlanManagerMock();
  var observer = MockNavigatorObserver();
  var shoppingListManager = ShoppingListManagerMock();

  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
    GetIt.I.registerSingleton<RecipeManager>(recipeManager);
    GetIt.I.registerSingleton<MealPlanManager>(mealPlanManager);
    GetIt.I.registerSingleton<IdGenerator>(UniqueKeyIdGenerator());
    GetIt.I.registerSingleton<ShoppingListManager>(shoppingListManager);

    GetIt.I.registerSingletonAsync<SharedPreferencesProvider>(
        () async => SharedPreferencesProviderImpl().init());
  });

  setUp(() {
    recipeManager.reset();
    mealPlanManager.reset();
  });

  testWidgets('No meal plans existing', (WidgetTester tester) async {
    // open fake app
    await _initApp(tester, observer);
    // open dialog
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    // snackbar displays message
    expect(find.byType(SnackBar), findsOneWidget);
  });

  testWidgets('Multiple meal plans existing', (WidgetTester tester) async {
    // open fake app
    await _initApp(tester, observer);
    //  create collections
    await mealPlanManager.createCollection('dummy1');
    await mealPlanManager.createCollection('dummy2');
    // open dialog
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    // dialog opened
    expect(find.byType(SimpleDialog), findsOneWidget);
  });

  testWidgets(
      'Single meal plan collection existing without persisted shopping list',
      (WidgetTester tester) async {
    // open fake app
    await _initApp(tester, observer);
    // create single collection
    await mealPlanManager.createCollection('dummy1');
    // open dialog
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    // date range dialog opened - has only private widgets
    // therefore check for semantics widget which is used there internally
    expect(find.text('SAVE'), findsOneWidget);
    expect(find.byType(Semantics), findsWidgets);
    // then press confirm
    await tester.tap(find.text('SAVE').first);
    await tester.pumpAndSettle();
    verify(observer.didPush(any, any));
    await tester.pumpAndSettle();

    // now we should have navigated to the shopping list screen
    expect(find.byType(ShoppingListDetailScreen), findsOneWidget);
  });

  testWidgets('Single meal plan with existing list',
      (WidgetTester tester) async {
    // open fake app
    await _initApp(tester, observer);
    // open dialog
    await tester.tap(find.byType(ElevatedButton));
    //
  });
}

Future<void> _initApp(WidgetTester tester, NavigatorObserver observer) async {
  await tester.pumpWidget(
    MaterialApp(
      routes: kRoutes,
      navigatorObservers: [observer],
      localizationsDelegates: [
        AppLocalizations.delegate,
      ],
      home: ChangeNotifierProvider<ThemeModel>(
        create: (context) => ThemeModel(),
        child: Builder(builder: (context) {
          return DummyScreen();
        }),
      ),
    ),
  );
}

class DummyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Builder(
          builder: (context) {
            return ElevatedButton(
              child: Container(),
              onPressed: () {
                openShoppingListDialog(context);
              },
            );
          },
        ),
      ),
    );
  }
}

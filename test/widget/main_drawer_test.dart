import 'package:cookly/components/main_app_drawer.dart';
import 'package:cookly/routes.dart';
import 'package:cookly/screens/collections/share_account_screen.dart';
import 'package:cookly/screens/meal_plan/meal_plan_screen.dart';
import 'package:cookly/screens/recipe_list_screen.dart';
import 'package:cookly/screens/recipe_modify/new_recipe_screen.dart';
import 'package:cookly/screens/settings/settings_screen.dart';
import 'package:cookly/screens/shopping_list/shopping_list_overview_screen.dart';
import 'package:cookly/screens/web_login_app.dart';
import 'package:cookly/services/abstract/platform_info.dart';
import 'package:cookly/services/abstract/receive_intent_handler.dart';
import 'package:cookly/services/firebase_provider.dart';
import 'package:cookly/services/meal_plan_manager.dart';
import 'package:cookly/services/mobile/platform_info_app.dart';
import 'package:cookly/services/navigator_service.dart';
import 'package:cookly/services/recipe_manager.dart';
import 'package:cookly/services/shared_preferences_provider.dart';
import 'package:cookly/services/shopping_list_manager.dart';
import 'package:cookly/viewmodel/settings/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_translate/localization.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mocks/firebase_provider_mock.dart';
import '../mocks/meal_plan_manager_mock.dart';
import '../mocks/navigator_observer_mock.dart';
import '../mocks/receive_intent_handler_mock.dart';
import '../mocks/recipe_manager_mock.dart';
import '../mocks/shopping_list_manager_mock.dart';

void main() {
  setUpAll(() {
    Map<String, dynamic> translations = {};
    translations.putIfAbsent(
        'ui',
        () => {
              'recipe': {'else': 'ui.recipe'}
            });
    translations.putIfAbsent(
        'recipe',
        () => {
              'ingredient': {'else': 'recipe.ingredient'}
            });
    Localization.load(translations);
    SharedPreferences.setMockInitialValues({});
    GetIt.I.registerSingletonAsync<SharedPreferencesProvider>(
        () async => SharedPreferencesProviderImpl().init());
    GetIt.I.registerSingleton<ReceiveIntentHandler>(ReceiveIntentHandlerMock());
    GetIt.I.registerSingleton<NavigatorService>(NavigatorService());
    GetIt.I.registerSingleton<RecipeManager>(RecipeManagerStub());
    GetIt.I.registerSingleton<MealPlanManager>(MealPlanManagerMock());
    GetIt.I.registerSingleton<PlatformInfo>(PlatformInfoImpl());

    GetIt.I.registerSingleton<ShoppingListManager>(ShoppingListManagerMock());
    GetIt.I.registerSingleton<FirebaseProvider>(FirebaseProviderMock());
  });

  testWidgets('Recipe list tile exists', (WidgetTester tester) async {
    await testTile(tester, 'ui.recipe', RecipeListScreen);
  });

  testWidgets('Meal planner tile exists', (WidgetTester tester) async {
    await testTile(tester, 'functions.mealPlanner', MealPlanScreen);
  });

  testWidgets('Shopping List tile exists', (WidgetTester tester) async {
    await testTile(
        tester, 'functions.shoppingList', ShoppingListOverviewScreen);
  });
  testWidgets('Create Recipe tile exists', (WidgetTester tester) async {
    await testTile(tester, 'functions.addRecipe', NewRecipeScreen);
  });

  testWidgets('Share Account tile exists', (WidgetTester tester) async {
    await testTile(tester, 'ui.shareAccount', ShareAccountScreen);
  });

  testWidgets('Settings tile exists', (WidgetTester tester) async {
    await testTile(tester, 'ui.settings', SettingsScreen);
  });

  testWidgets('Web Login tile exists', (WidgetTester tester) async {
    await testTile(tester, 'app.title ui.web', WebLoginOnAppScreen);
  });
}

Future<void> testTile(WidgetTester tester, String name, Object target) async {
  final mockObserver = MockNavigatorObserver();
  await tester.pumpWidget(MockApplication(mockObserver: mockObserver));

  expect(find.byType(MainAppDrawer), findsOneWidget);
  var finder = find.text(name);
  expect(finder, findsOneWidget);

  await tester.tap(finder);
  await tester.pumpAndSettle();

  expect(find.byType(target), findsOneWidget);
}

class MockApplication extends StatelessWidget {
  const MockApplication({
    @required this.mockObserver,
  });

  final MockNavigatorObserver mockObserver;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [mockObserver],
      routes: kRoutes,
      home: ChangeNotifierProvider<ThemeModel>(
        create: (context) => ThemeModel(),
        child: MainAppDrawer(),
      ),
    );
  }
}

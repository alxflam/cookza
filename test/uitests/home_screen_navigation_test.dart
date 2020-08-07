import 'package:cookly/routes.dart';
import 'package:cookly/screens/home_screen.dart';
import 'package:cookly/screens/leftovers_screen.dart';
import 'package:cookly/screens/meal_plan/meal_plan_screen.dart';
import 'package:cookly/screens/ocr_creation/ocr_stepper.dart';
import 'package:cookly/screens/recipe_list_screen.dart';
import 'package:cookly/screens/recipe_modify/new_recipe_screen.dart';
import 'package:cookly/services/abstract/receive_intent_handler.dart';
import 'package:cookly/services/meal_plan_manager.dart';
import 'package:cookly/services/navigator_service.dart';
import 'package:cookly/services/recipe_manager.dart';
import 'package:cookly/services/shared_preferences_provider.dart';
import 'package:cookly/viewmodel/settings/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_translate/localization.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mocks/meal_plan_manager_mock.dart';
import '../mocks/navigator_observer_mock.dart';
import '../mocks/receive_intent_handler_mock.dart';
import '../mocks/recipe_manager_mock.dart';

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
    GetIt.I.registerSingleton<RecipeManager>(RecipeManagerMock());
    GetIt.I.registerSingleton<MealPlanManager>(MealPlanManagerMock());
  });

  _verifyNavigation(WidgetTester tester, String button, Type type) async {
    final mockObserver = MockNavigatorObserver();
    await tester.pumpWidget(MockApplication(mockObserver: mockObserver));

    expect(find.byType(MainFunctionCard), findsWidgets);
    await tester.tap(find.text(button));
    await tester.pumpAndSettle();

    /// Verify that a push event happened
    verify(mockObserver.didPush(any, any));

    /// the navigation actually worked
    expect(find.byType(type), findsOneWidget);
  }

  testWidgets('Navigate to add new recipe', (WidgetTester tester) async {
    _verifyNavigation(tester, 'functions.addRecipe', NewRecipeScreen);
  });

  testWidgets('Navigate to recipe list', (WidgetTester tester) async {
    _verifyNavigation(tester, 'functions.listRecipes', RecipeListScreen);
  });

  testWidgets('Navigate to meal plan', (WidgetTester tester) async {
    _verifyNavigation(tester, 'functions.mealPlanner', MealPlanScreen);
  });

  testWidgets('Navigate to leftovers', (WidgetTester tester) async {
    _verifyNavigation(tester, 'functions.leftovers', LeftoversScreen);
  });

  testWidgets('Navigate to text recognition', (WidgetTester tester) async {
    _verifyNavigation(tester, 'functions.textRecognition', OcrCreationScreen);
  });
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
        child: HomeScreen(),
      ),
    );
  }
}

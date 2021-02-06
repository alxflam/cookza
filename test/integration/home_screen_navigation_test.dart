import 'package:cookza/screens/home_screen.dart';
import 'package:cookza/screens/leftovers_screen.dart';
import 'package:cookza/screens/meal_plan/meal_plan_screen.dart';
import 'package:cookza/screens/recipe_list_screen.dart';
import 'package:cookza/screens/recipe_modify/new_recipe_screen.dart';
import 'package:cookza/services/abstract/receive_intent_handler.dart';
import 'package:cookza/services/meal_plan_manager.dart';
import 'package:cookza/services/flutter/navigator_service.dart';
import 'package:cookza/services/recipe/recipe_manager.dart';
import 'package:cookza/services/shared_preferences_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mocks/application_mock.dart';
import '../mocks/meal_plan_manager_mock.dart';
import '../mocks/navigator_observer_mock.dart';
import '../mocks/receive_intent_handler_mock.dart';
import '../mocks/recipe_manager_mock.dart';

void main() {
  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
    GetIt.I.registerSingletonAsync<SharedPreferencesProvider>(
        () async => SharedPreferencesProviderImpl().init());
    GetIt.I.registerSingleton<ReceiveIntentHandler>(ReceiveIntentHandlerMock());
    GetIt.I.registerSingleton<NavigatorService>(NavigatorService());
    GetIt.I.registerSingleton<RecipeManager>(RecipeManagerStub());
    GetIt.I.registerSingleton<MealPlanManager>(MealPlanManagerMock());
  });

  void _verifyNavigation(WidgetTester tester, String button, Type type) async {
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
    _verifyNavigation(tester, 'New Recipe', NewRecipeScreen);
  });

  testWidgets('Navigate to recipe list', (WidgetTester tester) async {
    _verifyNavigation(tester, 'Recipes', RecipeListScreen);
  });

  testWidgets('Navigate to meal plan', (WidgetTester tester) async {
    _verifyNavigation(tester, 'Meal Planner', MealPlanScreen);
  });

  testWidgets('Navigate to leftovers', (WidgetTester tester) async {
    _verifyNavigation(tester, 'Leftover Reuse', LeftoversScreen);
  });
}

import 'package:cookza/components/main_app_drawer.dart';
import 'package:cookza/screens/home_screen.dart';
import 'package:cookza/services/abstract/receive_intent_handler.dart';
import 'package:cookza/services/meal_plan_manager.dart';
import 'package:cookza/services/flutter/navigator_service.dart';
import 'package:cookza/services/recipe/recipe_manager.dart';
import 'package:cookza/services/shared_preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mocks/application_mock.dart';
import '../mocks/meal_plan_manager_mock.dart';
import '../mocks/receive_intent_handler_mock.dart';
import '../mocks/recipe_manager_mock.dart';
import '../mocks/shared_mocks.mocks.dart';

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

  testWidgets('Open drawer by icon button', (WidgetTester tester) async {
    final mockObserver = MockNavigatorObserver();
    await tester.pumpWidget(MockApplication(mockObserver: mockObserver));

    expect(find.byType(HomeScreen), findsOneWidget);
    var buttonFinder = find.byType(IconButton);
    expect(buttonFinder, findsOneWidget);

    await tester.tap(buttonFinder);
    await tester.pumpAndSettle();

    expect(find.byType(MainAppDrawer), findsOneWidget);
  });
}

import 'package:cookza/screens/home_screen.dart';
import 'package:cookza/services/abstract/receive_intent_handler.dart';
import 'package:cookza/services/shared_preferences_provider.dart';
import 'package:cookza/viewmodel/settings/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mocks/receive_intent_handler_mock.dart';
import '../utils/localization_parent.dart';

void main() {
  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
    GetIt.I.registerSingletonAsync<SharedPreferencesProvider>(
        () async => SharedPreferencesProviderImpl().init());
    GetIt.I.registerSingleton<ReceiveIntentHandler>(ReceiveIntentHandlerMock());
  });

  testWidgets('HomeScreen has buttons for navigation',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ChangeNotifierProvider<ThemeModel>(
        create: (context) => ThemeModel(),
        child: const LocalizationParent(HomeScreen()),
      ),
    ));

    final addRecipe = find.text('New Recipe');
    expect(addRecipe, findsOneWidget);

    final mealPlanner = find.text('Meal Planner');
    expect(mealPlanner, findsOneWidget);

    final leftovers = find.text('Leftover Reuse');
    expect(leftovers, findsOneWidget);

    final shoppingList = find.text('Shopping List');
    expect(shoppingList, findsOneWidget);

    final listRecipes = find.text('Recipes');
    expect(listRecipes, findsOneWidget);
  });
}

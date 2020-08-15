import 'package:cookly/screens/home_screen.dart';
import 'package:cookly/services/abstract/receive_intent_handler.dart';
import 'package:cookly/services/shared_preferences_provider.dart';
import 'package:cookly/viewmodel/settings/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_translate/localization.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mocks/receive_intent_handler_mock.dart';

void main() {
  setUpAll(() {
    Map<String, dynamic> translations = {};
    Localization.load(translations);
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
        child: HomeScreen(),
      ),
    ));

    final addRecipe = find.text('functions.addRecipe');
    expect(addRecipe, findsOneWidget);

    final mealPlanner = find.text('functions.mealPlanner');
    expect(mealPlanner, findsOneWidget);

    final leftovers = find.text('functions.leftovers');
    expect(leftovers, findsOneWidget);

    final shoppingList = find.text('functions.shoppingList');
    expect(shoppingList, findsOneWidget);

    final listRecipes = find.text('functions.listRecipes');
    expect(listRecipes, findsOneWidget);
  });
}

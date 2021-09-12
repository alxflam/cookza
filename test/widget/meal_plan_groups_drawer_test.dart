import 'package:cookza/components/meal_plan_groups_drawer.dart';
import 'package:cookza/routes.dart';
import 'package:cookza/screens/meal_plan/meal_plan_screen.dart';
import 'package:cookza/services/meal_plan_manager.dart';
import 'package:cookza/services/recipe/recipe_manager.dart';
import 'package:cookza/services/shared_preferences_provider.dart';
import 'package:cookza/viewmodel/settings/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../mocks/meal_plan_manager_mock.dart';
import '../mocks/recipe_manager_mock.dart';
import '../mocks/shared_mocks.mocks.dart';

import '../utils/test_utils.dart';

void main() {
  var recipeManager = RecipeManagerStub();
  var mealPlanManager = MealPlanManagerMock();
  var mockObserver = MockNavigatorObserver();

  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
    GetIt.I.registerSingleton<RecipeManager>(recipeManager);
    GetIt.I.registerSingleton<MealPlanManager>(mealPlanManager);

    GetIt.I.registerSingletonAsync<SharedPreferencesProvider>(
        () async => SharedPreferencesProviderImpl().init());
  });

  setUp(() {
    recipeManager.reset();
    mealPlanManager.reset();
  });

  testWidgets('Create new meal plan group', (WidgetTester tester) async {
    await _initApp(tester, mockObserver);
    await tester.pumpAndSettle();

    final createButton = find.text('Create Group');
    expect(createButton, findsOneWidget);

    await tester.tap(createButton);
    await tester.pumpAndSettle();

    // dialog opened to create a meal plan group
    expect(find.byType(SimpleDialog), findsOneWidget);
    expect(find.text('Group Name'), findsWidgets);

    // set some name
    await inputFormField(tester, find.byType(TextFormField), 'Some Test');
    await tester.tap(find.byIcon(Icons.save));
    await tester.pumpAndSettle();

    // navigated to meal plan screen
    expect(find.byType(MealPlanScreen), findsOneWidget);

    // meal plan is shown for new group
    expect(find.byType(WeekNumber), findsWidgets);

    // open the drawer
    await tester.dragFrom(
        tester.getTopLeft(find.byType(MaterialApp)), const Offset(300, 0));
    await tester.pumpAndSettle();

    // the drawer opened
    expect(find.byType(MealPlanGroupsDrawer), findsOneWidget);
    // the name of the group is visible two times: in the drawer and in the app bar name of the now visible meal plan screen
    expect(find.text('Some Test'), findsNWidgets(2));
  });
}

Future<void> _initApp(WidgetTester tester, NavigatorObserver observer) async {
  await tester.pumpWidget(MaterialApp(
    routes: kRoutes,
    navigatorObservers: [observer],
    localizationsDelegates: const [
      AppLocalizations.delegate,
    ],
    home: ChangeNotifierProvider<ThemeModel>(
      create: (context) => ThemeModel(),
      child: const MealPlanGroupsDrawer(),
    ),
  ));
}

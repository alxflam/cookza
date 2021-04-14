import 'package:cookza/model/entities/mutable/mutable_shopping_list.dart';
import 'package:cookza/routes.dart';
import 'package:cookza/screens/shopping_list/shopping_list_detail_screen.dart';
import 'package:cookza/screens/shopping_list/shopping_list_overview_screen.dart';
import 'package:cookza/services/flutter/navigator_service.dart';
import 'package:cookza/services/unit_of_measure.dart';
import 'package:cookza/services/util/id_gen.dart';
import 'package:cookza/services/meal_plan_manager.dart';
import 'package:cookza/services/recipe/recipe_manager.dart';
import 'package:cookza/services/shared_preferences_provider.dart';
import 'package:cookza/services/shopping_list/shopping_list_manager.dart';
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
import '../mocks/shopping_list_manager_mock.dart';

var recipeManager = RecipeManagerStub();
var mealPlanManager = MealPlanManagerMock();
var observer = MockNavigatorObserver();
var shoppingListManager = ShoppingListManagerMock();
final navigatorService = NavigatorService();

void main() {
  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
    GetIt.I.registerSingleton<RecipeManager>(recipeManager);
    GetIt.I.registerSingleton<MealPlanManager>(mealPlanManager);
    GetIt.I.registerSingleton<IdGenerator>(UniqueKeyIdGenerator());
    GetIt.I.registerSingleton<ShoppingListManager>(shoppingListManager);
    GetIt.I.registerSingleton<UnitOfMeasureProvider>(StaticUnitOfMeasure());
    GetIt.I.registerSingleton<NavigatorService>(NavigatorService());

    GetIt.I.registerSingletonAsync<SharedPreferencesProvider>(
        () async => SharedPreferencesProviderImpl().init());
  });

  setUp(() {
    recipeManager.reset();
    mealPlanManager.reset();
  });

  testWidgets('Shopping lists in the past are not shown',
      (WidgetTester tester) async {
    MutableShoppingList list = MutableShoppingList.newList(
        '1',
        DateTime.now().subtract(Duration(days: 7)),
        DateTime.now().subtract(Duration(days: 1)));
    list.id = '1';

    await shoppingListManager.createOrUpdate(list);

    // open fake app
    await _initApp(tester, observer);
    await tester.pumpAndSettle();

    // tap shopping list
    expect(find.byType(ListTile), findsNothing);
  });

  testWidgets('Delete shopping list', (WidgetTester tester) async {
    MutableShoppingList list = MutableShoppingList.newList(
        '1', DateTime.now(), DateTime.now().add(Duration(days: 7)));
    list.id = '1';

    await shoppingListManager.createOrUpdate(list);

    // open fake app
    await _initApp(tester, observer);
    await tester.pumpAndSettle();

    // tap delete icon
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();

    // confirm deletion
    var deleteButton = find.ancestor(
        of: find.text('Delete'), matching: find.byType(ElevatedButton));
    await tester.tap(deleteButton);

    await tester.pumpAndSettle();

    // list tile is gone
    expect(find.byType(ListTile), findsNothing);
  });

  testWidgets('Shopping list entry navigates to detail screen on tap',
      (WidgetTester tester) async {
    MutableShoppingList list = MutableShoppingList.newList(
        '1', DateTime.now(), DateTime.now().add(Duration(days: 7)));
    list.id = '1';

    await shoppingListManager.createOrUpdate(list);

    // open fake app
    await _initApp(tester, observer);
    await tester.pumpAndSettle();

    // tap shopping list
    await tester.tap(find.byType(ListTile));
    await tester.pumpAndSettle();

    expect(find.byType(ShoppingListDetailScreen), findsOneWidget);
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
      navigatorKey: navigatorService.navigatorKey,
      home: ChangeNotifierProvider<ThemeModel>(
        create: (context) => ThemeModel(),
        child: ShoppingListOverviewScreen(),
      ),
    ),
  );
}

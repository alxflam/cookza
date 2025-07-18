import 'package:cookza/model/entities/mutable/mutable_ingredient_note.dart';
import 'package:cookza/model/entities/mutable/mutable_shopping_list.dart';
import 'package:cookza/model/entities/mutable/mutable_shopping_list_item.dart';
import 'package:cookza/routes.dart';
import 'package:cookza/screens/shopping_list/shopping_list_detail_screen.dart';
import 'package:cookza/screens/shopping_list/shopping_list_dialog.dart';
import 'package:cookza/services/flutter/navigator_service.dart';
import 'package:cookza/services/recipe/ingredients_calculator.dart';
import 'package:cookza/services/shopping_list/shopping_list_items_generator.dart';
import 'package:cookza/services/unit_of_measure.dart';
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
import 'package:cookza/l10n/app_localizations.dart';

import '../mocks/meal_plan_manager_mock.dart';
import '../mocks/recipe_manager_mock.dart';
import '../mocks/shared_mocks.mocks.dart';
import '../mocks/shopping_list_manager_mock.dart';

void main() {
  var recipeManager = RecipeManagerStub();
  var mealPlanManager = MealPlanManagerMock();
  var observer = MockNavigatorObserver();
  var shoppingListManager = ShoppingListManagerMock();
  var navigatorService = NavigatorService();

  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
    GetIt.I.registerSingleton<RecipeManager>(recipeManager);
    GetIt.I.registerSingleton<MealPlanManager>(mealPlanManager);
    GetIt.I.registerSingleton<ShoppingListManager>(shoppingListManager);
    GetIt.I.registerSingleton<ShoppingListItemsGenerator>(
        ShoppingListItemsGeneratorImpl());
    GetIt.I
        .registerSingleton<IngredientsCalculator>(IngredientsCalculatorImpl());
    GetIt.I.registerSingleton<UnitOfMeasureProvider>(StaticUnitOfMeasure());
    GetIt.I.registerSingleton<NavigatorService>(navigatorService);

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
    expect(find.byType(MultipeGroupSelectionDialog), findsOneWidget);
    //  date range is editable
    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();

    // change selected date
    await tester.tap(find.text(DateTime.now().day.toString()).first);
    await tester.tap(find
        .text(DateTime.now().add(const Duration(days: 2)).day.toString())
        .first);

    expect(find.text('Save'), findsOneWidget);
    expect(find.byType(Semantics), findsWidgets);
    // then press confirm
    await tester.tap(find.text('Save').first);
    await tester.pumpAndSettle();

    expect(find.byType(MultipeGroupSelectionDialog), findsOneWidget);
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
    expect(find.text('Save'), findsOneWidget);
    expect(find.byType(Semantics), findsWidgets);
    // then press confirm
    await tester.tap(find.text('Save'));
    await tester.pump();
    verify(observer.didPush(any, any));
    await tester.pumpAndSettle();

    // now we should have navigated to the shopping list screen
    expect(find.byType(ShoppingListDetailScreen), findsOneWidget);
  });

  testWidgets('Single meal plan with existing list',
      (WidgetTester tester) async {
    final plan = await mealPlanManager.createCollection('dummy1');

    MutableShoppingList list = MutableShoppingList.newList(
      plan.id!,
      DateTime.now().add(const Duration(days: 1)),
      DateTime.now().add(const Duration(days: 6)),
    );
    list.id = plan.id!;

    var item = MutableIngredientNote.empty();
    item.name = 'Cheese';
    item.unitOfMeasure = 'H87';
    list.addItem(MutableShoppingListItem.ofIngredientNote(item, false, true));

    await shoppingListManager.createOrUpdate(list);

    // open fake app
    await _initApp(tester, observer);
    // open dialog
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    // date range dialog opened - has only private widgets
    // therefore check for semantics widget which is used there internally

    var firstDayFinder = find.ancestor(
        of: find.text(list.dateFrom.day.toString()),
        matching: find.byType(GestureDetector));
    await tester.tap(firstDayFinder.first);

    var lastDayFinder = find.ancestor(
        of: find.text(list.dateUntil.day.toString()),
        matching: find.byType(GestureDetector));

    if (lastDayFinder.evaluate().length > 1) {
      // first if same month, last if next month...
      lastDayFinder = list.dateUntil.day > list.dateFrom.day
          ? lastDayFinder.first
          : lastDayFinder.last;
    }

    await tester.tap(lastDayFinder);
    expect(find.text('Save'), findsOneWidget);
    expect(find.byType(Semantics), findsWidgets);

    // then press confirm
    await tester.tap(find.text('Save').first);
    await tester.pump();
    verify(observer.didPush(any, any));
    await tester.pumpAndSettle();

    expect(find.byType(ShoppingListDetailScreen), findsOneWidget);
    expect(find.textContaining('Cheese'), findsOneWidget);
  });

  testWidgets('Single meal plan with existing list from the past',
      (WidgetTester tester) async {
    final plan = await mealPlanManager.createCollection('dummy1');

    MutableShoppingList list = MutableShoppingList.newList(
        plan.id!,
        DateTime.now().subtract(const Duration(days: 3)),
        DateTime.now().add(const Duration(days: 6)));
    list.id = plan.id!;

    var item = MutableIngredientNote.empty();
    item.name = 'Cheese';
    item.unitOfMeasure = 'H87';
    list.addItem(MutableShoppingListItem.ofIngredientNote(item, false, true));

    await shoppingListManager.createOrUpdate(list);

    // open fake app
    await _initApp(tester, observer);
    // open dialog
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    // date range dialog opened - has only private widgets
    // therefore check for semantics widget which is used there internally

    var firstDayFinder = find.ancestor(
        of: find.text(DateTime.now().day.toString()),
        matching: find.byType(GestureDetector));
    await tester.tap(firstDayFinder.first);

    var lastDayFinder = find.ancestor(
        of: find.text(list.dateUntil.day.toString()),
        matching: find.byType(GestureDetector));

    if (lastDayFinder.evaluate().length > 1) {
      // first if same month, last if next month...
      lastDayFinder = list.dateUntil.day > list.dateFrom.day
          ? lastDayFinder.first
          : lastDayFinder.last;
    }

    await tester.tap(lastDayFinder);

    expect(find.text('Save'), findsOneWidget);
    expect(find.byType(Semantics), findsWidgets);
    // then press confirm
    await tester.tap(find.text('Save').first);
    await tester.pump();
    verify(observer.didPush(any, any));
    await tester.pumpAndSettle();

    expect(find.byType(ShoppingListDetailScreen), findsOneWidget);
    expect(find.textContaining('Cheese'), findsOneWidget);
  });
}

Future<void> _initApp(WidgetTester tester, NavigatorObserver observer) async {
  await tester.pumpWidget(
    MaterialApp(
      routes: kRoutes,
      navigatorObservers: [observer],
      localizationsDelegates: const [
        AppLocalizations.delegate,
      ],
      navigatorKey: GetIt.I.get<NavigatorService>().navigatorKey,
      home: ChangeNotifierProvider<ThemeModel>(
        create: (context) => ThemeModel(),
        child: Builder(builder: (context) {
          return const DummyScreen();
        }),
      ),
    ),
  );
}

class DummyScreen extends StatelessWidget {
  const DummyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () {
                openShoppingListDialog(context);
              },
              child: Container(),
            );
          },
        ),
      ),
    );
  }
}

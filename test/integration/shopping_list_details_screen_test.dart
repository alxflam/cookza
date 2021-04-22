import 'package:cookza/model/entities/mutable/mutable_ingredient_note.dart';
import 'package:cookza/routes.dart';
import 'package:cookza/screens/new_ingredient_screen.dart';
import 'package:cookza/screens/shopping_list/shopping_list_detail_screen.dart';
import 'package:cookza/services/flutter/navigator_service.dart';
import 'package:cookza/services/recipe/ingredients_calculator.dart';
import 'package:cookza/services/shopping_list/shopping_list_items_generator.dart';
import 'package:cookza/services/unit_of_measure.dart';
import 'package:cookza/services/meal_plan_manager.dart';
import 'package:cookza/services/recipe/recipe_manager.dart';
import 'package:cookza/services/shared_preferences_provider.dart';
import 'package:cookza/services/shopping_list/shopping_list_manager.dart';
import 'package:cookza/viewmodel/settings/theme_model.dart';
import 'package:cookza/viewmodel/shopping_list/shopping_list_detail.dart';
import 'package:flutter/gestures.dart';
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
import '../utils/test_utils.dart';

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
    GetIt.I.registerSingleton<ShoppingListManager>(shoppingListManager);
    GetIt.I.registerSingleton<UnitOfMeasureProvider>(StaticUnitOfMeasure());
    GetIt.I.registerSingleton<NavigatorService>(NavigatorService());
    GetIt.I.registerSingleton<ShoppingListItemsGenerator>(
        ShoppingListItemsGeneratorImpl());
    GetIt.I
        .registerSingleton<IngredientsCalculator>(IngredientsCalculatorImpl());

    GetIt.I.registerSingletonAsync<SharedPreferencesProvider>(
        () async => SharedPreferencesProviderImpl().init());
  });

  setUp(() {
    recipeManager.reset();
    mealPlanManager.reset();
  });

  testWidgets('Shopping list with single custom entry',
      (WidgetTester tester) async {
    ShoppingListModel model = ShoppingListModel.empty();
    model.groupID = '1';

    // open fake app
    await _initApp(tester, observer, model);
    // navigate
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    var item = MutableIngredientNote.empty();
    item.name = 'Something important';
    item.unitOfMeasure = 'H87';
    model.addCustomItem(item);
    await tester.pumpAndSettle();

    expect(find.text('Something important'), findsOneWidget);
    expect(find.byType(CheckboxListTile), findsOneWidget);
  });

  testWidgets('Check off custom item', (WidgetTester tester) async {
    ShoppingListModel model = ShoppingListModel.empty();
    model.groupID = '1';

    // open fake app
    await _initApp(tester, observer, model);
    // navigate
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    var item = MutableIngredientNote.empty();
    item.name = 'Something important';
    item.unitOfMeasure = 'H87';
    model.addCustomItem(item);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();

    final items = await model.getItems();
    expect(items.first.isNoLongerNeeded, true);
  });

  testWidgets('Add custom entry', (WidgetTester tester) async {
    ShoppingListModel model = ShoppingListModel.empty();
    model.groupID = '1';

    // open fake app
    await _initApp(tester, observer, model);
    // navigate
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.byType(NewIngredientScreen), findsOneWidget);

    var input = find.ancestor(
        of: find.text('Ingredient'), matching: find.byType(TextFormField));
    await inputFormField(tester, input, 'Cheese');
    await tester.tap(find.byType(ElevatedButton).first);
    await tester.pumpAndSettle();

    expect(find.byType(ShoppingListDetailScreen), findsOneWidget);
    expect(find.text('Cheese'), findsOneWidget);
  });

  testWidgets('Delete a custom list entry', (WidgetTester tester) async {
    ShoppingListModel model = ShoppingListModel.empty();
    model.groupID = '1';

    // open fake app
    await _initApp(tester, observer, model);
    // navigate
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    var item = MutableIngredientNote.empty();
    item.name = 'Cheese';
    item.unitOfMeasure = 'H87';
    model.addCustomItem(item);
    await tester.pumpAndSettle();

    expect(find.text('Cheese'), findsOneWidget);
    expect(find.byIcon(Icons.edit), findsOneWidget);

    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();

    expect(find.byType(NewIngredientScreen), findsOneWidget);
    await tester.tap(find.byIcon(Icons.delete).last);
    await tester.pumpAndSettle();

    expect(find.byType(ShoppingListDetailScreen), findsOneWidget);
    expect(find.text('Cheese'), findsNothing);
  });

  testWidgets('Custom entries are editable', (WidgetTester tester) async {
    ShoppingListModel model = ShoppingListModel.empty();
    model.groupID = '1';

    // open fake app
    await _initApp(tester, observer, model);
    // navigate
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    var item = MutableIngredientNote.empty();
    item.name = 'Something important';
    item.unitOfMeasure = 'H87';
    model.addCustomItem(item);
    await tester.pumpAndSettle();

    expect(find.text('Something important'), findsOneWidget);
    expect(find.byIcon(Icons.edit), findsOneWidget);

    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();

    expect(find.byType(NewIngredientScreen), findsOneWidget);

    var input = find.ancestor(
        of: find.text('Something important'),
        matching: find.byType(TextFormField));
    await inputFormField(tester, input, 'Cheese');
    await tester.tap(find.byType(ElevatedButton).first);
    await tester.pumpAndSettle();

    expect(find.byType(ShoppingListDetailScreen), findsOneWidget);
    expect(find.text('Cheese'), findsOneWidget);
  });

  testWidgets('Reorder entry', (WidgetTester tester) async {
    ShoppingListModel model = ShoppingListModel.empty();
    model.groupID = '1';

    // open fake app
    await _initApp(tester, observer, model);
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    var item = MutableIngredientNote.empty();
    item.name = 'First';
    item.unitOfMeasure = 'H87';
    model.addCustomItem(item);

    item = MutableIngredientNote.empty();
    item.name = 'Second';
    item.unitOfMeasure = 'H87';
    model.addCustomItem(item);

    item = MutableIngredientNote.empty();
    item.name = 'Third';
    item.unitOfMeasure = 'H87';
    model.addCustomItem(item);
    await tester.pumpAndSettle();

    expect(find.byType(CheckboxListTile), findsNWidgets(3));

    var firstLoc = tester.getCenter(find.text('First'));
    var secondLoc = tester.getCenter(find.text('Second'));
    expect(firstLoc.dy < secondLoc.dy, true);

    final Offset firstLocation = tester.getCenter(find.text('First'));
    final TestGesture gesture =
        await tester.startGesture(firstLocation, pointer: 7);
    await tester.pump(kLongPressTimeout + kPressTimeout);

    final Offset lastLocation = tester.getCenter(find.text('Third'));
    await gesture.moveTo(lastLocation);
    await tester.pumpAndSettle();
    await gesture.up();
    await tester.pumpAndSettle();

    final afterMove = tester.getCenter(find.text('First'));
    expect(firstLoc.dy < afterMove.dy, true);
  });
}

Future<void> _initApp(WidgetTester tester, NavigatorObserver observer,
    ShoppingListModel model) async {
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
        child: Builder(
          builder: (context) {
            return Container(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, ShoppingListDetailScreen.id,
                      arguments: model);
                },
                child: Container(),
              ),
            );
          },
        ),
      ),
    ),
  );
}

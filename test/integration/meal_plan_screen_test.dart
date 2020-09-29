import 'package:cookza/components/meal_plan_groups_drawer.dart';
import 'package:cookza/components/round_icon_button.dart';
import 'package:cookza/model/entities/mutable/mutable_meal_plan.dart';
import 'package:cookza/routes.dart';
import 'package:cookza/screens/meal_plan/meal_plan_screen.dart';
import 'package:cookza/services/util/id_gen.dart';
import 'package:cookza/services/meal_plan_manager.dart';
import 'package:cookza/services/recipe/recipe_manager.dart';
import 'package:cookza/services/shared_preferences_provider.dart';
import 'package:cookza/viewmodel/settings/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_translate/localization.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mocks/meal_plan_manager_mock.dart';
import '../mocks/navigator_observer_mock.dart';
import '../mocks/recipe_manager_mock.dart';
import '../utils/meal_plan_creator.dart';

void main() {
  var recipeManager = RecipeManagerStub();
  var mealPlanManager = MealPlanManagerMock();
  var mockObserver = MockNavigatorObserver();

  setUpAll(() {
    Map<String, dynamic> translations = {};
    Localization.load(translations);
    SharedPreferences.setMockInitialValues({});
    GetIt.I.registerSingleton<RecipeManager>(recipeManager);
    GetIt.I.registerSingleton<MealPlanManager>(mealPlanManager);
    GetIt.I.registerSingleton<IdGenerator>(UniqueKeyIdGenerator());

    GetIt.I.registerSingletonAsync<SharedPreferencesProvider>(
        () async => SharedPreferencesProviderImpl().init());
  });

  setUp(() {
    recipeManager.reset();
    recipeManager.createCollection('dummy');
    mealPlanManager.createCollection('dummy');
  });

  testWidgets('Current meal plan is set', (WidgetTester tester) async {
    var mealPlan = MealPlanCreator.createMealPlan('My Plan', 1);
    mealPlanManager.addMealPlan('dummy', mealPlan);
    mealPlanManager.currentCollection = 'dummy';

    await _initApp(tester, mockObserver);

    await tester.pumpAndSettle();

    expect(find.byType(WeekNumber), findsWidgets);
  });

  testWidgets('Current meal plan is not set', (WidgetTester tester) async {
    await _initApp(tester, mockObserver);

    expect(find.byType(WeekNumber), findsNothing);
    expect(find.byType(NoMealPlanSelected), findsOneWidget);
  });

  testWidgets('Open drawer with one group', (WidgetTester tester) async {
    await _initApp(tester, mockObserver);

    expect(find.byType(NoMealPlanSelected), findsOneWidget);

    await tester.tap(find.byType(RaisedButton));

    await tester.pumpAndSettle();

    // drawer opened
    expect(find.byType(MealPlanGroupsDrawer), findsOneWidget);
    // there's one meal plan group existing
    expect(find.text('dummy'), findsWidgets);
    find.descendant(of: find.byType(ListTile), matching: find.text('dummy'));
  });

  testWidgets('Display recipe', (WidgetTester tester) async {
    var mealPlan = MealPlanCreator.createMealPlan('My Plan', 1);

    var item = MutableMealPlanDateEntity.empty(DateTime.now());
    item.addRecipe(
        MutableMealPlanRecipeEntity.fromValues('whatever', 'Spätzle', 2));
    mealPlan.items.add(item);
    mealPlanManager.saveMealPlan(mealPlan);

    mealPlanManager.createCollection(mealPlan.groupID);
    mealPlanManager.currentCollection = mealPlan.groupID;
    mealPlanManager.addMealPlan(mealPlan.groupID, mealPlan);

    await _initApp(tester, mockObserver);

    await tester.pumpAndSettle();

    // a meal plan is selected
    expect(find.byType(NoMealPlanSelected), findsNothing);

    find.descendant(of: find.byType(Card), matching: find.text('Spätzle'));
    find.descendant(of: find.byType(Card), matching: find.text('2'));
  });

  testWidgets('Tap on recipe navigates to recipe', (WidgetTester tester) async {
    var mealPlan = MealPlanCreator.createMealPlan('My Plan', 1);

    var item = MutableMealPlanDateEntity.empty(DateTime.now());
    item.addRecipe(
        MutableMealPlanRecipeEntity.fromValues('whatever', 'Spätzle', 2));
    mealPlan.items.add(item);
    mealPlanManager.saveMealPlan(mealPlan);

    mealPlanManager.createCollection(mealPlan.groupID);
    mealPlanManager.currentCollection = mealPlan.groupID;
    mealPlanManager.addMealPlan(mealPlan.groupID, mealPlan);

    await _initApp(tester, mockObserver);

    await tester.pumpAndSettle();

    // a meal plan is selected
    expect(find.byType(NoMealPlanSelected), findsNothing);

    var recipeFinder =
        find.descendant(of: find.byType(Card), matching: find.text('Spätzle'));
    find.descendant(of: find.byType(Card), matching: find.text('2'));

    tester.tap(recipeFinder);

    /// Verify that a push event happened
    verify(mockObserver.didPush(any, any));
  });

  testWidgets('Remove Recipe', (WidgetTester tester) async {
    var mealPlan = MealPlanCreator.createMealPlan('My Plan', 1);

    var item = MutableMealPlanDateEntity.empty(DateTime.now());
    item.addRecipe(
        MutableMealPlanRecipeEntity.fromValues('whatever', 'Spätzle', 2));
    mealPlan.items.add(item);
    mealPlanManager.saveMealPlan(mealPlan);

    mealPlanManager.createCollection(mealPlan.groupID);
    mealPlanManager.currentCollection = mealPlan.groupID;
    mealPlanManager.addMealPlan(mealPlan.groupID, mealPlan);

    await _initApp(tester, mockObserver);
    await tester.pumpAndSettle();

    // a meal plan is selected
    expect(find.byType(NoMealPlanSelected), findsNothing);

    find.descendant(of: find.byType(Card), matching: find.text('Spätzle'));
    find.descendant(of: find.byType(Card), matching: find.text('2'));
    var editIconButtonFinder = find.descendant(
        of: find.byType(ListTile), matching: find.byIcon(Icons.edit));

    await tester.tap(editIconButtonFinder);
    await tester.pumpAndSettle();

    /// Verify that a push event happened
    verify(mockObserver.didPush(any, any));

    /// delete item
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();

    /// recipe is gone
    expect(find.text('Spätzle'), findsNothing);
  });

  testWidgets('Change Recipe Servings', (WidgetTester tester) async {
    var mealPlan = MealPlanCreator.createMealPlan('My Plan', 1);

    var item = MutableMealPlanDateEntity.empty(DateTime.now());
    item.addRecipe(
        MutableMealPlanRecipeEntity.fromValues('whatever', 'Spätzle', 2));
    mealPlan.items.add(item);
    mealPlanManager.saveMealPlan(mealPlan);

    mealPlanManager.createCollection(mealPlan.groupID);
    mealPlanManager.currentCollection = mealPlan.groupID;
    mealPlanManager.addMealPlan(mealPlan.groupID, mealPlan);

    await _initApp(tester, mockObserver);

    await tester.pumpAndSettle();

    // a meal plan is selected
    expect(find.byType(NoMealPlanSelected), findsNothing);

    find.descendant(of: find.byType(Card), matching: find.text('Spätzle'));
    find.descendant(of: find.byType(Card), matching: find.text('2'));
    var editIconButtonFinder = find.descendant(
        of: find.byType(ListTile), matching: find.byIcon(Icons.edit));

    await tester.tap(editIconButtonFinder);
    await tester.pumpAndSettle();
    verify(mockObserver.didPush(any, any));

    var addIconFinder = find.byType(RoundIconButton).first;
    var decreaseIconFinder = find.byType(RoundIconButton).at(1);

    /// increase servings by one
    await tester.tap(addIconFinder);
    await tester.tap(addIconFinder);
    await tester.tap(decreaseIconFinder);

    /// accept changes
    await tester.tap(find.byIcon(Icons.check));

    /// new servings is shown
    find.descendant(of: find.byType(Card), matching: find.text('3'));
  });

  testWidgets('Add recipe by tap', (WidgetTester tester) async {
    var mealPlan = MealPlanCreator.createMealPlan('My Plan', 1);

    var item = MutableMealPlanDateEntity.empty(DateTime.now());
    item.addRecipe(
        MutableMealPlanRecipeEntity.fromValues('whatever', 'Spätzle', 2));
    mealPlan.items.add(item);
    mealPlanManager.saveMealPlan(mealPlan);

    mealPlanManager.createCollection(mealPlan.groupID);
    mealPlanManager.currentCollection = mealPlan.groupID;
    mealPlanManager.addMealPlan(mealPlan.groupID, mealPlan);

    await _initApp(tester, mockObserver);

    await tester.pumpAndSettle();

    // a meal plan is selected
    expect(find.byType(NoMealPlanSelected), findsNothing);

    find.descendant(of: find.byType(Card), matching: find.text('Spätzle'));
    find.descendant(of: find.byType(Card), matching: find.text('2'));
    var addIconButtonFinder = find.descendant(
        of: find.byType(Card), matching: find.byIcon(Icons.add));

    await tester.tap(addIconButtonFinder.first);
    await tester.pumpAndSettle();

    /// Verify that a push event happened
    verify(mockObserver.didPush(any, any));

    /// TODO: then select recipe in the dialog
  });

  testWidgets('Add note by tap', (WidgetTester tester) async {
    var mealPlan = MealPlanCreator.createMealPlan('My Plan', 1);

    var item = MutableMealPlanDateEntity.empty(DateTime.now());
    item.addRecipe(
        MutableMealPlanRecipeEntity.fromValues('whatever', 'Spätzle', 2));
    mealPlan.items.add(item);
    mealPlanManager.saveMealPlan(mealPlan);

    mealPlanManager.createCollection(mealPlan.groupID);
    mealPlanManager.currentCollection = mealPlan.groupID;
    mealPlanManager.addMealPlan(mealPlan.groupID, mealPlan);

    await _initApp(tester, mockObserver);

    await tester.pumpAndSettle();

    // a meal plan is selected
    expect(find.byType(NoMealPlanSelected), findsNothing);

    find.descendant(of: find.byType(Card), matching: find.text('Spätzle'));
    find.descendant(of: find.byType(Card), matching: find.text('2'));
    var addIconButtonFinder = find.descendant(
        of: find.byType(Card), matching: find.byIcon(Icons.add));

    await tester.tap(addIconButtonFinder.first);
    await tester.pumpAndSettle();

    /// Verify that a push event happened
    verify(mockObserver.didPush(any, any));

    var noteFinder = find.descendant(
        of: find.byType(RaisedButton),
        matching: find.text('ui.mealPlan.addNote'));
    await tester.tap(noteFinder);
    await tester.pumpAndSettle();

    /// Verify that a push event happened
    verify(mockObserver.didPush(any, any));

    var descInput = find.ancestor(
        of: find.text('Note'), matching: find.byType(TextFormField));
    await _inputFormField(tester, descInput, 'My special note');

    /// then save
    await tester.tap(find.byIcon(Icons.save));
    await tester.pumpAndSettle();

    /// Verify that a pop event happened
    verify(mockObserver.didPop(any, any));

    var noteCardFinder = find.descendant(
        of: find.byType(Card), matching: find.text('My special note'));
    expect(noteCardFinder, findsOneWidget);
  });

  testWidgets('Remove note', (WidgetTester tester) async {
    var mealPlan = MealPlanCreator.createMealPlan('My Plan', 1);

    var item = MutableMealPlanDateEntity.empty(DateTime.now());
    item.addRecipe(MutableMealPlanRecipeEntity.fromValues(
        null, 'Some special note', null));
    mealPlan.items.add(item);
    mealPlanManager.saveMealPlan(mealPlan);

    mealPlanManager.createCollection(mealPlan.groupID);
    mealPlanManager.currentCollection = mealPlan.groupID;
    mealPlanManager.addMealPlan(mealPlan.groupID, mealPlan);

    await _initApp(tester, mockObserver);
    await tester.pumpAndSettle();

    // a meal plan is selected
    expect(find.byType(NoMealPlanSelected), findsNothing);

    find.descendant(
        of: find.byType(Card), matching: find.text('Some special note'));
    var editIconButtonFinder = find.descendant(
        of: find.byType(Card), matching: find.byIcon(Icons.edit));

    await tester.tap(editIconButtonFinder.first);
    await tester.pumpAndSettle();

    /// Verify that a push event happened
    verify(mockObserver.didPush(any, any));

    /// then delete note
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();

    /// Verify that a pop event happened
    verify(mockObserver.didPop(any, any));

    var noteCardFinder = find.descendant(
        of: find.byType(Card), matching: find.text('Some special note'));
    expect(noteCardFinder, findsNothing);
  });

  testWidgets('Add recipe by navigation', (WidgetTester tester) async {
    await _initApp(tester, mockObserver);
    // TODO: implement test
  });
}

Future<void> _initApp(WidgetTester tester, NavigatorObserver observer) async {
  await tester.pumpWidget(MaterialApp(
    routes: kRoutes,
    navigatorObservers: [observer],
    home: ChangeNotifierProvider<ThemeModel>(
      create: (context) => ThemeModel(),
      child: MealPlanScreen(),
    ),
  ));
}

_inputFormField(WidgetTester tester, Finder finder, String value) async {
  await tester.enterText(finder, value);
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pumpAndSettle();
  expect(find.text(value), findsOneWidget);
}

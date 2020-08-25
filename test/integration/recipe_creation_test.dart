import 'package:cookly/components/recipe_list_tile.dart';
import 'package:cookly/routes.dart';
import 'package:cookly/screens/home_screen.dart';
import 'package:cookly/screens/leftovers_screen.dart';
import 'package:cookly/screens/new_ingredient_screen.dart';
import 'package:cookly/screens/recipe_modify/image_step.dart';
import 'package:cookly/screens/recipe_modify/ingredient_step.dart';
import 'package:cookly/screens/recipe_modify/instructions_step.dart';
import 'package:cookly/screens/recipe_modify/new_recipe_screen.dart';
import 'package:cookly/screens/recipe_modify/tag_step.dart';
import 'package:cookly/screens/recipe_view/overview_tab.dart';
import 'package:cookly/services/abstract/receive_intent_handler.dart';
import 'package:cookly/services/image_manager.dart';
import 'package:cookly/services/recipe_manager.dart';
import 'package:cookly/services/shared_preferences_provider.dart';
import 'package:cookly/services/similarity_service.dart';
import 'package:cookly/services/unit_of_measure.dart';
import 'package:cookly/viewmodel/settings/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_translate/localization.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mocks/application_mock.dart';
import '../mocks/image_manager_mock.dart';
import '../mocks/navigator_observer_mock.dart';
import '../mocks/receive_intent_handler_mock.dart';
import '../mocks/recipe_manager_mock.dart';
import '../mocks/uom_mock.dart';

void main() {
  var mock = RecipeManagerMock();
  var imageMock = ImageManagerMock();
  GetIt.I.registerSingleton<RecipeManager>(mock);
  GetIt.I.registerSingleton<ImageManager>(imageMock);
  GetIt.I.registerSingleton<SimilarityService>(SimilarityService());

  setUp(() {
    mock.reset();
    mock.createCollection('dummy');
  });

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
    GetIt.I.registerSingleton<UnitOfMeasureProvider>(UoMMock());
  });

  testWidgets('test overview step', (WidgetTester tester) async {
    await setupApplication(tester);
    await _navigateToNewRecipeScreen(tester);

    expect(find.text('recipe.recipeName'), findsOneWidget);
    expect(find.text('recipe.recipeDesc'), findsOneWidget);
    expect(find.text('recipe.duration:'), findsOneWidget);

    expect(find.text('recipe.difficulty.easy'), findsOneWidget);
    expect(find.text('recipe.difficulty.medium'), findsOneWidget);
    expect(find.text('recipe.difficulty.hard'), findsOneWidget);
  });

  testWidgets('test create a recipe', (WidgetTester tester) async {
    await setupApplication(tester);
    await _navigateToNewRecipeScreen(tester);

    /// add name
    var nameInput = find.ancestor(
        of: find.text('recipe.recipeName'),
        matching: find.byType(TextFormField));
    await _inputFormField(tester, nameInput, 'My simple recipe');

    /// add desc
    var descInput = find.ancestor(
        of: find.text('recipe.recipeDesc'),
        matching: find.byType(TextFormField));
    await _inputFormField(tester, descInput, 'My Desc');

    /// navigate to next page
    await tester.tap(find.text('CONTINUE'));
    await tester.pumpAndSettle();

    /// then verify we're on the image step
    expect(find.byType(SelectImageWidget), findsOneWidget);

    /// then proceed
    await tester.tap(find.text('CONTINUE'));
    await tester.pumpAndSettle();

    /// then verify we're on the tag step
    expect(find.byType(TagColumn), findsOneWidget);
    expect(find.byType(SwitchListTile), findsNWidgets(4));

    // make the recipe vegetarian
    var veggie = find.text('recipe.tags.vegetarian');
    await tester.tap(veggie);
    await tester.pumpAndSettle();

    /// then proceed
    await _proceedStep(tester);

    /// then verify we're on the ingredient step
    expect(find.byType(IngredientStepContent), findsOneWidget);

    /// then navigate to add a new ingredient
    var addButton = find.byIcon(Icons.add);
    await tester.tap(addButton);
    await tester.pumpAndSettle();

    /// verify we navigated
    expect(find.byType(NewIngredientScreen), findsOneWidget);

    /// set amount
    var amountInput = find.ancestor(
        of: find.text('recipe.amount'), matching: find.byType(TextFormField));
    await _inputFormField(tester, amountInput, '10');
    expect(find.text('10'), findsOneWidget);

    /// set ingredient
    var ingredientNameInput = find.descendant(
        of: find.byType(IngredientNameTextInput),
        matching: find.byType(TextFormField));
    await _inputFormField(tester, ingredientNameInput, 'Onions');
    expect(find.text('Onions'), findsOneWidget);

    /// then save the ingredient
    var saveButton = find.byIcon(Icons.save);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    /// then verify we're on the ingredient step
    expect(find.byType(IngredientStepContent), findsOneWidget);

    /// then verify it got added
    expect(find.text('10'), findsOneWidget);
    expect(find.text('Onions'), findsOneWidget);

    /// then edit it
    var editButton = find.byIcon(Icons.edit);
    await tester.tap(editButton);
    await tester.pumpAndSettle();

    /// verify we navigated
    expect(find.byType(NewIngredientScreen), findsOneWidget);

    /// verify ingredient is shown
    expect(find.text('Onions'), findsWidgets);
    expect(find.text('10'), findsWidgets);

    /// change ingredient name
    await _inputFormField(tester, ingredientNameInput, 'Mushrooms');
    expect(find.text('Mushrooms'), findsOneWidget);

    /// change amount
    await _inputFormField(tester, amountInput, '12');
    expect(find.text('12'), findsOneWidget);

    /// then save the ingredient
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    /// then verify we're on the ingredient step
    expect(find.byType(IngredientStepContent), findsOneWidget);

    /// then verify ingredient changed
    expect(find.text('12'), findsOneWidget);
    expect(find.text('Mushrooms'), findsOneWidget);

    /// then proceed
    await _proceedStep(tester);

    /// then verify we're on the ingredient step
    expect(find.byType(InstructionsStepContent), findsOneWidget);

    await _inputFormField(
        tester, find.byType(TextFormField), 'Do the first step');
    expect(find.text('Do the first step'), findsOneWidget);

    /// then proceed
    await _proceedStep(tester);
    await tester.pumpAndSettle();

    /// now the recipe should have been created and we should have navigated to the recipe screen
    expect(find.byType(OverviewTab), findsOneWidget);

    /// then make sure the recipe got created
    var recipes = await GetIt.I.get<RecipeManager>().getAllRecipes();
    expect(recipes.length, 1);

    /// verify general properties
    expect(recipes.first.name, 'My simple recipe');
    expect(recipes.first.description, 'My Desc');
    expect(recipes.first.tags.length, 1);
    expect(recipes.first.tags.contains('vegetarian'), true);

    /// verify ingredients and instructions
    var ingredients = await recipes.first.ingredients;
    var instructions = await recipes.first.instructions;
    expect(instructions.length, 1);
    expect(instructions.first.text, 'Do the first step');
    expect(ingredients.length, 1);
    expect(ingredients.first.ingredient.name, 'Mushrooms');
    expect(ingredients.first.amount, 12);
  });
}

Future _proceedStep(WidgetTester tester) async {
  await tester.tap(find.text('CONTINUE'));
  await tester.pump();
}

_navigateToNewRecipeScreen(WidgetTester tester) async {
  final mockObserver = MockNavigatorObserver();
  await tester.pumpWidget(MockApplication(mockObserver: mockObserver));

  expect(find.byType(MainFunctionCard), findsWidgets);
  await tester.tap(find.text('functions.addRecipe'));
  await tester.pumpAndSettle();

  /// Verify that a push event happened
  verify(mockObserver.didPush(any, any));

  /// the navigation actually worked
  expect(find.byType(NewRecipeScreen), findsOneWidget);
}

_inputFormField(WidgetTester tester, Finder finder, String value) async {
  await tester.enterText(finder, value);
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pumpAndSettle();
  expect(find.text(value), findsOneWidget);
}

Future setupApplication(WidgetTester tester) async {
  await tester.pumpWidget(MaterialApp(
    routes: kRoutes,
    home: ChangeNotifierProvider<ThemeModel>(
      create: (context) => ThemeModel(),
      child: HomeScreen(),
    ),
  ));
}

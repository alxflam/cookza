import 'package:cookza/routes.dart';
import 'package:cookza/screens/home_screen.dart';
import 'package:cookza/screens/new_ingredient_screen.dart';
import 'package:cookza/screens/ocr_creation/ingredients_image_step.dart';
import 'package:cookza/screens/ocr_creation/instruction_image_step.dart';
import 'package:cookza/screens/ocr_creation/overview_image_step.dart';
import 'package:cookza/screens/recipe_modify/image_step.dart';
import 'package:cookza/screens/recipe_modify/ingredient_step.dart';
import 'package:cookza/screens/recipe_modify/instructions_step.dart';
import 'package:cookza/screens/recipe_modify/new_recipe_screen.dart';
import 'package:cookza/screens/recipe_modify/tag_step.dart';
import 'package:cookza/screens/recipe_view/overview_tab.dart';
import 'package:cookza/services/abstract/receive_intent_handler.dart';
import 'package:cookza/services/flutter/navigator_service.dart';
import 'package:cookza/services/recipe/image_manager.dart';
import 'package:cookza/services/recipe/recipe_manager.dart';
import 'package:cookza/services/shared_preferences_provider.dart';
import 'package:cookza/services/recipe/similarity_service.dart';
import 'package:cookza/services/unit_of_measure.dart';
import 'package:cookza/viewmodel/settings/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cookza/l10n/app_localizations.dart';

import '../mocks/application_mock.dart';
import '../mocks/receive_intent_handler_mock.dart';
import '../mocks/recipe_manager_mock.dart';
import '../mocks/shared_mocks.mocks.dart';
import '../mocks/uom_provider_mock.dart';
import '../utils/test_utils.dart';

void main() {
  var mock = RecipeManagerStub();
  var imageMock = MockImageManager();
  GetIt.I.registerSingleton<NavigatorService>(NavigatorService());
  GetIt.I.registerSingleton<RecipeManager>(mock);
  GetIt.I.registerSingleton<ImageManager>(imageMock);
  GetIt.I.registerSingleton<SimilarityService>(SimilarityService());

  setUp(() {
    mock.reset();
    mock.createCollection('dummy');
    when(imageMock.getRecipeImageFile(any))
        .thenAnswer((_) => Future.value(null));
  });

  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
    GetIt.I.registerSingletonAsync<SharedPreferencesProvider>(
        () async => SharedPreferencesProviderImpl().init());
    GetIt.I.registerSingleton<ReceiveIntentHandler>(ReceiveIntentHandlerMock());
    GetIt.I.registerSingleton<UnitOfMeasureProvider>(UoMMock());
  });

  testWidgets('test overview step', (WidgetTester tester) async {
    await setupApplication(tester);
    await _navigateToNewRecipeScreen(tester);

    expect(find.text('Recipe Name'), findsOneWidget);
    expect(find.text('Recipe Description'), findsOneWidget);
    expect(find.text('Duration:'), findsOneWidget);

    expect(find.text('easy'), findsOneWidget);
    expect(find.text('medium'), findsOneWidget);
    expect(find.text('hard'), findsOneWidget);
  });

  testWidgets('test create a recipe', (WidgetTester tester) async {
    await setupApplication(tester);
    await _navigateToNewRecipeScreen(tester);

    /// add name
    var nameInput = find.ancestor(
        of: find.text('Recipe Name'), matching: find.byType(TextFormField));
    await inputFormField(tester, nameInput, 'My simple recipe');

    /// add desc
    var descInput = find.ancestor(
        of: find.text('Recipe Description'),
        matching: find.byType(TextFormField));
    await inputFormField(tester, descInput, 'My Desc');

    /// navigate to next page
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    /// then verify we're on the image step
    expect(find.byType(SelectImageWidget), findsOneWidget);

    /// then proceed
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    /// then verify we're on the tag step
    expect(find.byType(TagColumn), findsOneWidget);
    expect(find.byType(SwitchListTile), findsNWidgets(4));

    // make the recipe vegetarian
    var veggie = find.text('Vegetarian');
    await tester.tap(veggie);
    await tester.pumpAndSettle();

    /// then proceed
    await _proceedStep(tester);

    /// then verify we're on the ingredient step
    expect(find.byType(IngredientStepContent), findsOneWidget);

    /// then navigate to add a new ingredient
    var addButton = find.text('Add Ingredient');
    await tester.tap(addButton);
    await tester.pumpAndSettle();

    /// verify we navigated
    expect(find.byType(NewIngredientScreen), findsOneWidget);

    /// set amount
    var amountInput = find.ancestor(
        of: find.text('Amount'), matching: find.byType(TextFormField));
    await inputFormField(tester, amountInput, '10');
    expect(find.text('10'), findsOneWidget);

    /// set ingredient
    var ingredientNameInput = find.descendant(
        of: find.byType(IngredientNameTextInput),
        matching: find.byType(TextFormField));
    await inputFormField(tester, ingredientNameInput, 'Onions');
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
    await tester.tap(find.text('Onions'));
    await tester.pumpAndSettle();

    /// verify we navigated
    expect(find.byType(NewIngredientScreen), findsOneWidget);

    /// verify ingredient is shown
    expect(find.text('Onions'), findsWidgets);
    expect(find.text('10'), findsWidgets);

    /// change ingredient name
    await inputFormField(tester, ingredientNameInput, 'Mushrooms');
    expect(find.text('Mushrooms'), findsOneWidget);

    /// change amount
    await inputFormField(tester, amountInput, '12');
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

    await inputFormField(
        tester, find.byType(TextFormField), 'Do the first step');
    expect(find.text('Do the first step'), findsOneWidget);

    /// then proceed
    await _proceedStep(tester);

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
    var ingGroups = await recipes.first.ingredientGroups;
    var instructions = await recipes.first.instructions;
    expect(instructions.length, 1);
    expect(instructions.first.text, 'Do the first step');
    expect(ingGroups.length, 1);
    expect(ingGroups.first.ingredients.length, 1);
    expect(ingGroups.first.ingredients.first.ingredient.name, 'Mushrooms');
    expect(ingGroups.first.ingredients.first.amount, 12);
  });

  testWidgets('Verify OCR buttons available', (WidgetTester tester) async {
    await setupApplication(tester);
    await _navigateToNewRecipeScreen(tester);

    /// add name
    await tester.tap(find.byIcon(Icons.image));
    await tester.pumpAndSettle();

    expect(find.byType(OCROverviewImageScreen), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.byType(OCROverviewImageScreen), findsNothing);

    /// navigate to next page
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    /// then verify we're on the image step
    expect(find.byType(SelectImageWidget), findsOneWidget);

    /// then proceed
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    /// then verify we're on the tag step
    expect(find.byType(TagColumn), findsOneWidget);

    /// then proceed
    await _proceedStep(tester);

    /// then verify we're on the ingredient step
    expect(find.byType(IngredientStepContent), findsOneWidget);

    await tester.tap(find.byIcon(Icons.image));
    await tester.pumpAndSettle();

    expect(find.byType(OCRIngredientsImageScreen), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.byType(OCRIngredientsImageScreen), findsNothing);

    /// then proceed
    await _proceedStep(tester);

    /// then verify we're on the ingredient step
    expect(find.byType(InstructionsStepContent), findsOneWidget);
    await tester.tap(find.byIcon(Icons.image));
    await tester.pumpAndSettle();

    expect(find.byType(OCRInstructionsImageScreen), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.byType(OCRInstructionsImageScreen), findsNothing);
  });
}

Future _proceedStep(WidgetTester tester) async {
  await tester.tap(find.text('Continue'));
  await tester.pumpAndSettle();
}

Future<void> _navigateToNewRecipeScreen(WidgetTester tester) async {
  final mockObserver = MockNavigatorObserver();
  await tester.pumpWidget(MockApplication(mockObserver: mockObserver));

  expect(find.byType(MainFunctionCard), findsWidgets);
  await tester.tap(find.text('New Recipe'));
  await tester.pumpAndSettle();

  /// Verify that a push event happened
  verify(mockObserver.didPush(any, any));

  /// the navigation actually worked
  expect(find.byType(NewRecipeScreen), findsOneWidget);
}

Future<void> setupApplication(WidgetTester tester) async {
  await tester.pumpWidget(MaterialApp(
    routes: kRoutes,
    localizationsDelegates: const [
      AppLocalizations.delegate,
    ],
    home: ChangeNotifierProvider<ThemeModel>(
      create: (context) => ThemeModel(),
      child: const HomeScreen(),
    ),
  ));
}

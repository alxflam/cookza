import 'package:cookza/components/recipe_list_tile.dart';
import 'package:cookza/model/entities/mutable/mutable_ingredient_group.dart';
import 'package:cookza/model/entities/mutable/mutable_instruction.dart';
import 'package:cookza/screens/home_screen.dart';
import 'package:cookza/screens/new_ingredient_screen.dart';
import 'package:cookza/screens/recipe_list_screen.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mocks/application_mock.dart';
import '../mocks/receive_intent_handler_mock.dart';
import '../mocks/recipe_manager_mock.dart';
import '../mocks/shared_mocks.mocks.dart';
import '../mocks/uom_provider_mock.dart';
import '../utils/recipe_creator.dart';
import '../utils/test_utils.dart';

void main() {
  var mock = RecipeManagerStub();
  var imageMock = MockImageManager();
  GetIt.I.registerSingleton<RecipeManager>(mock);
  GetIt.I.registerSingleton<ImageManager>(imageMock);
  GetIt.I.registerSingleton<SimilarityService>(SimilarityService());

  setUp(() {
    mock.reset();
    when(imageMock.getRecipeImageFile(any))
        .thenAnswer((_) => Future.value(null));
  });

  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
    GetIt.I.registerSingletonAsync<SharedPreferencesProvider>(
        () async => SharedPreferencesProviderImpl().init());
    GetIt.I.registerSingleton<ReceiveIntentHandler>(ReceiveIntentHandlerMock());
    GetIt.I.registerSingleton<UnitOfMeasureProvider>(UoMMock());
    GetIt.I.registerSingleton<NavigatorService>(NavigatorService());
  });

  testWidgets('Modify a recipe', (WidgetTester tester) async {
    var originalRecipeName = 'My awesome recipe';

    /// create the recipe
    var coll = await mock.createCollection('dummy');
    var recipe = RecipeCreator.createRecipe(originalRecipeName);
    recipe.recipeCollectionId = coll.id!;
    recipe.duration = 20;
    var onion = RecipeCreator.createIngredient('Onion', amount: 2, uom: 'GRM');
    var pepper =
        RecipeCreator.createIngredient('Pepper', amount: 2, uom: 'PCS');
    recipe.ingredientGroupList = [
      MutableIngredientGroup.forValues(1, 'Test', [onion, pepper])
    ];

    recipe.instructionList = [
      MutableInstruction.withValues(text: 'First step'),
      MutableInstruction.withValues(text: 'Second step')
    ];
    mock.currentCollection = recipe.recipeCollectionId;
    await mock.createOrUpdate(recipe);

    /// navigate to the recipe
    await _navigateToRecipeScreen(tester);

    /// assert the recipe name is shown
    expect(find.byType(OverviewTab), findsOneWidget);
    expect(find.text(originalRecipeName), findsWidgets);

    /// edit the recipe
    var moreFinder = find.byIcon(Icons.more_vert);
    expect(moreFinder, findsOneWidget);
    await tester.tap(moreFinder);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();

    /// should have navigated to edit recipe
    expect(find.byType(NewRecipeScreen), findsOneWidget);

    /// change the recipe name
    expect(find.text(originalRecipeName), findsWidgets);
    var nameInput = find.ancestor(
        of: find.text('Recipe Name'), matching: find.byType(TextFormField));
    expect(nameInput, findsOneWidget);
    await inputFormField(tester, nameInput, 'My simple recipe');

    /// add desc
    var descInput = find.ancestor(
        of: find.text('Recipe Description'),
        matching: find.byType(TextFormField));
    await inputFormField(tester, descInput, 'My Desc');

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
    await inputFormField(tester, ingredientNameInput, 'Flour');
    expect(find.text('Flour'), findsOneWidget);

    /// then save the ingredient
    var saveButton = find.byIcon(Icons.save);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    /// then verify we're on the ingredient step
    expect(find.byType(IngredientStepContent), findsOneWidget);

    /// then verify it got added
    expect(find.text('10'), findsOneWidget);
    expect(find.text('Flour'), findsOneWidget);

    /// then edit a already existing ingredient by tapping it
    await tester.tap(find.text('Onion'));
    await tester.pumpAndSettle();

    /// verify we navigated
    expect(find.byType(NewIngredientScreen), findsOneWidget);

    /// verify ingredient is shown
    expect(find.text('Onion'), findsWidgets);
    expect(find.text('2'), findsWidgets);

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
    expect(find.text('Onion'), findsOneWidget);

    /// then delete the pepper ingredient
    await tester.tap(find.text('Pepper'));
    await tester.pumpAndSettle();

    expect(find.text('Pepper'), findsWidgets);
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();

    /// then verify we're on the ingredient step and the ingredient is removed
    expect(find.byType(IngredientStepContent), findsOneWidget);
    expect(find.text('Pepper'), findsNothing);

    /// then proceed
    await _proceedStep(tester);

    /// then verify we're on the instruction step
    expect(find.byType(InstructionsStepContent), findsOneWidget);

    expect(find.text('First step'), findsOneWidget);
    expect(find.text('Second step'), findsOneWidget);

    /// then proceed
    await _proceedStep(tester);

    /// now the recipe should have been created and we should have navigated to the recipe screen
    expect(find.byType(OverviewTab), findsOneWidget);
    expect(find.text(originalRecipeName), findsNothing);
    expect(find.text('My simple recipe'), findsWidgets);

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
    expect(instructions.length, 2);
    expect(instructions.first.text, 'First step');
    expect(ingGroups.length, 1);
    expect(ingGroups.first.ingredients.length, 2);
    expect(ingGroups.first.ingredients.first.ingredient.name, 'Onion');
    expect(ingGroups.first.ingredients.first.amount, 12);
    expect(ingGroups.first.ingredients.last.ingredient.name, 'Flour');
    expect(ingGroups.first.ingredients.last.amount, 10);
  });
}

Future _proceedStep(WidgetTester tester) async {
  await tester.tap(find.text('CONTINUE'));
  await tester.pump();
}

Future<void> _navigateToRecipeScreen(WidgetTester tester) async {
  final mockObserver = MockNavigatorObserver();
  await tester.pumpWidget(MockApplication(mockObserver: mockObserver));

  expect(find.byType(MainFunctionCard), findsWidgets);
  await tester.tap(find.text('Recipes'));
  await tester.pumpAndSettle();

  /// Verify that a push event happened
  verify(mockObserver.didPush(any, any));

  /// the navigation actually worked
  expect(find.byType(RecipeListScreen), findsOneWidget);

  /// the recipe is shown
  expect(find.byType(RecipeListTile), findsOneWidget);

  /// navigate to the recipe
  await tester.tap(find.byType(RecipeListTile));
  await tester.pumpAndSettle();
}

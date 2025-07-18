import 'package:cookza/components/alert_dialog_title.dart';
import 'package:cookza/model/entities/mutable/mutable_ingredient_group.dart';
import 'package:cookza/model/entities/mutable/mutable_instruction.dart';
import 'package:cookza/model/entities/mutable/mutable_recipe.dart';
import 'package:cookza/routes.dart';
import 'package:cookza/screens/meal_plan/meal_plan_screen.dart';
import 'package:cookza/screens/recipe_view/recipe_screen.dart';
import 'package:cookza/services/abstract/receive_intent_handler.dart';
import 'package:cookza/services/flutter/navigator_service.dart';
import 'package:cookza/services/meal_plan_manager.dart';
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

import '../mocks/receive_intent_handler_mock.dart';
import '../mocks/recipe_manager_mock.dart';
import '../mocks/shared_mocks.mocks.dart';
import '../mocks/uom_provider_mock.dart';
import '../utils/recipe_creator.dart';

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
    GetIt.I.registerSingleton<MealPlanManager>(MockMealPlanManager());
  });

  testWidgets('Share recipe dialog', (WidgetTester tester) async {
    var originalRecipeName = 'My awesome recipe';
    final mockObserver = MockNavigatorObserver();

    /// create the recipe
    MutableRecipe recipe = await _createRecipe(mock, originalRecipeName);

    /// navigate to the recipe
    await setupWidget(tester, recipe, mockObserver);

    /// assert the recipe name is shown
    expect(find.byType(RecipeScreen), findsOneWidget);
    expect(find.text(originalRecipeName), findsWidgets);

    /// edit the recipe
    var moreFinder = find.byIcon(Icons.more_vert);
    expect(moreFinder, findsOneWidget);
    await tester.tap(moreFinder);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Share'));
    await tester.pumpAndSettle();

    /// dialog is shown to choose which share format to use
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('JSON'), findsOneWidget);
    expect(find.text('PDF'), findsOneWidget);
    expect(find.text('Text'), findsOneWidget);
  });

  testWidgets('Delete recipe dialog', (WidgetTester tester) async {
    var originalRecipeName = 'My awesome recipe';
    final mockObserver = MockNavigatorObserver();

    /// create the recipe
    MutableRecipe recipe = await _createRecipe(mock, originalRecipeName);

    /// navigate to the recipe
    await setupWidget(tester, recipe, mockObserver);

    /// assert the recipe name is shown
    expect(find.byType(RecipeScreen), findsOneWidget);
    expect(find.text(originalRecipeName), findsWidgets);

    /// edit the recipe
    var moreFinder = find.byIcon(Icons.more_vert);
    expect(moreFinder, findsOneWidget);
    await tester.tap(moreFinder);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    /// alert dialog is shown to confirm deletion
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.byType(AlertDialogTitle), findsOneWidget);
  });

  testWidgets('Add to meal plan', (WidgetTester tester) async {
    var originalRecipeName = 'My awesome recipe';
    final mockObserver = MockNavigatorObserver();

    /// create the recipe
    MutableRecipe recipe = await _createRecipe(mock, originalRecipeName);

    /// navigate to the recipe
    await setupWidget(tester, recipe, mockObserver);

    /// assert the recipe name is shown
    expect(find.byType(RecipeScreen), findsOneWidget);
    expect(find.text(originalRecipeName), findsWidgets);

    /// edit the recipe
    var moreFinder = find.byIcon(Icons.more_vert);
    expect(moreFinder, findsOneWidget);
    await tester.tap(moreFinder);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Meal Planner'));
    await tester.pump();
    await tester.pumpAndSettle();

    /// navigated to meal plan
    verify(mockObserver.didPush(any, any));
    await tester.pumpAndSettle();
    expect(find.byType(MealPlanScreen), findsOneWidget);

    // TODO: then select a day and add to meal plan
  });
}

Future<MutableRecipe> _createRecipe(
    RecipeManagerStub mock, String originalRecipeName) async {
  /// create the recipe
  var coll = await mock.createCollection('dummy');
  var recipe = RecipeCreator.createRecipe(originalRecipeName);
  recipe.recipeCollectionId = coll.id!;
  recipe.duration = 20;
  var onion = RecipeCreator.createIngredient('Onion', amount: 2, uom: 'GRM');
  var pepper = RecipeCreator.createIngredient('Pepper', amount: 2, uom: 'PCS');
  recipe.ingredientGroupList = [
    MutableIngredientGroup.forValues(1, 'Test', [onion, pepper])
  ];

  recipe.instructionList = [
    MutableInstruction.withValues(text: 'First step'),
    MutableInstruction.withValues(text: 'Second step')
  ];
  mock.currentCollection = recipe.recipeCollectionId;
  await mock.createOrUpdate(recipe);
  return recipe;
}

Future<void> setupWidget(
    WidgetTester tester, Object arg, MockNavigatorObserver mockObserver) async {
  await tester.pumpWidget(
    MaterialApp(
      navigatorObservers: [mockObserver],
      localizationsDelegates: const [
        AppLocalizations.delegate,
      ],
      routes: kRoutes,
      home: ChangeNotifierProvider<ThemeModel>(
        create: (context) => ThemeModel(),
        child: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, RecipeScreen.id, arguments: arg),
              child: const Text('DUMMY'),
            );
          },
        ),
      ),
    ),
  );

  await tester.tap(find.byType(ElevatedButton));
  await tester.pumpAndSettle();
}

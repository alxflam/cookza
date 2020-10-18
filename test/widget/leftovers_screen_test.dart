import 'package:cookza/components/recipe_list_tile.dart';
import 'package:cookza/screens/leftovers_screen.dart';
import 'package:cookza/services/abstract/receive_intent_handler.dart';
import 'package:cookza/services/recipe/recipe_manager.dart';
import 'package:cookza/services/shared_preferences_provider.dart';
import 'package:cookza/services/recipe/similarity_service.dart';
import 'package:cookza/viewmodel/settings/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mocks/receive_intent_handler_mock.dart';
import '../mocks/recipe_manager_mock.dart';
import '../utils/localization_parent.dart';
import '../utils/recipe_creator.dart';

void main() {
  var mock = RecipeManagerStub();
  GetIt.I.registerSingleton<RecipeManager>(mock);
  GetIt.I.registerSingleton<SimilarityService>(SimilarityService());

  setUp(() {
    mock.reset();
  });

  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
    GetIt.I.registerSingletonAsync<SharedPreferencesProvider>(
        () async => SharedPreferencesProviderImpl().init());
    GetIt.I.registerSingleton<ReceiveIntentHandler>(ReceiveIntentHandlerMock());
  });

  testWidgets('search with single ingredient', (WidgetTester tester) async {
    await setupScreen(tester);

    var recipe = RecipeCreator.createRecipe('dummy');
    var pepper = RecipeCreator.createIngredient('Pepper');

    recipe.ingredientList = [pepper];

    await GetIt.I.get<RecipeManager>().createOrUpdate(recipe);

    expect(find.byType(TextField), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'pepper');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    var chipFinder = find.byType(InputChip);
    expect(chipFinder, findsOneWidget);
    expect(find.text('pepper'), findsOneWidget);

    final recipeFinder = find.byType(RecipeListTile);
    expect(recipeFinder, findsOneWidget);

    final recipeName = find.text('dummy');
    expect(recipeName, findsOneWidget);
  });

  testWidgets('search with non existent ingredient',
      (WidgetTester tester) async {
    await setupScreen(tester);

    var recipe = RecipeCreator.createRecipe('dummy');
    var pepper = RecipeCreator.createIngredient('Pepper');

    recipe.ingredientList = [pepper];

    await GetIt.I.get<RecipeManager>().createOrUpdate(recipe);

    expect(find.byType(TextField), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'garlic');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    var chipFinder = find.byType(InputChip);
    expect(chipFinder, findsOneWidget);
    expect(find.text('garlic'), findsOneWidget);

    final recipeFinder = find.byType(RecipeListTile);
    expect(recipeFinder, findsNothing);

    final cardFinder = find.byType(Card);
    expect(cardFinder, findsOneWidget);

    final errorMessage = find.text('No recipes found');
    expect(errorMessage, findsOneWidget);
  });

  testWidgets('search with multiple ingredients', (WidgetTester tester) async {
    await setupScreen(tester);

    var recipe = RecipeCreator.createRecipe('dummy');
    var pepper = RecipeCreator.createIngredient('Pepper');
    var onion = RecipeCreator.createIngredient('onion');

    recipe.ingredientList = [pepper, onion];

    await GetIt.I.get<RecipeManager>().createOrUpdate(recipe);

    expect(find.byType(TextField), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'pepper');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    var chipFinder = find.byType(InputChip);
    expect(chipFinder, findsOneWidget);

    await tester.enterText(find.byType(TextField), 'onion');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(chipFinder, findsNWidgets(2));

    final recipeFinder = find.byType(RecipeListTile);
    expect(recipeFinder, findsOneWidget);

    final recipeName = find.text('dummy');
    expect(recipeName, findsOneWidget);
  });

  testWidgets('delete ingredient keyword', (WidgetTester tester) async {
    await setupScreen(tester);

    var recipe = RecipeCreator.createRecipe('dummy');
    var pepper = RecipeCreator.createIngredient('Pepper');
    var onion = RecipeCreator.createIngredient('onion');

    recipe.ingredientList = [pepper, onion];

    await GetIt.I.get<RecipeManager>().createOrUpdate(recipe);

    // enter pepper
    expect(find.byType(TextField), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'pepper');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    var chipFinder = find.byType(InputChip);
    expect(chipFinder, findsOneWidget);

    // enter onion
    await tester.enterText(find.byType(TextField), 'onion');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(chipFinder, findsNWidgets(2));

    var cancelButtonFinder = find.byType(AnimatedSwitcher);
    var onionChipFinder = find.text('onion');
    expect(onionChipFinder, findsOneWidget);

    // delete the onion InputChip
    await tester.tap(cancelButtonFinder.last);
    await tester.pump();
    await tester.pumpAndSettle();
    // onion chip is gone
    expect(onionChipFinder, findsNothing);
    // only one chip is left
    expect(chipFinder, findsOneWidget);
  });
}

Future setupScreen(WidgetTester tester) async {
  await tester.pumpWidget(MaterialApp(
    home: ChangeNotifierProvider<ThemeModel>(
      create: (context) => ThemeModel(),
      child: LocalizationParent(LeftoversScreen()),
    ),
  ));
}

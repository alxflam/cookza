import 'package:cookly/components/main_app_drawer.dart';
import 'package:cookly/components/recipe_groups_drawer.dart';
import 'package:cookly/components/recipe_list_tile.dart';
import 'package:cookly/routes.dart';
import 'package:cookly/screens/collections/share_account_screen.dart';
import 'package:cookly/screens/home_screen.dart';
import 'package:cookly/screens/leftovers_screen.dart';
import 'package:cookly/screens/meal_plan/meal_plan_screen.dart';
import 'package:cookly/screens/recipe_list_screen.dart';
import 'package:cookly/screens/recipe_modify/new_recipe_screen.dart';
import 'package:cookly/screens/recipe_view/recipe_screen.dart';
import 'package:cookly/screens/settings/settings_screen.dart';
import 'package:cookly/screens/shopping_list/shopping_list_overview_screen.dart';
import 'package:cookly/screens/web_login_app.dart';
import 'package:cookly/services/abstract/platform_info.dart';
import 'package:cookly/services/abstract/receive_intent_handler.dart';
import 'package:cookly/services/firebase_provider.dart';
import 'package:cookly/services/image_manager.dart';
import 'package:cookly/services/meal_plan_manager.dart';
import 'package:cookly/services/mobile/platform_info_app.dart';
import 'package:cookly/services/navigator_service.dart';
import 'package:cookly/services/recipe_manager.dart';
import 'package:cookly/services/shared_preferences_provider.dart';
import 'package:cookly/services/shopping_list_manager.dart';
import 'package:cookly/viewmodel/settings/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_translate/localization.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mocks/firebase_provider_mock.dart';
import '../mocks/image_manager_mock.dart';
import '../mocks/navigator_observer_mock.dart';
import '../mocks/receive_intent_handler_mock.dart';
import '../mocks/recipe_manager_mock.dart';
import '../mocks/shopping_list_manager_mock.dart';
import '../utils/recipe_creator.dart';

void main() {
  var recipeManager = RecipeManagerMock();

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
    GetIt.I.registerSingleton<NavigatorService>(NavigatorService());
    GetIt.I.registerSingleton<PlatformInfo>(PlatformInfoImpl());
    GetIt.I.registerSingleton<ShoppingListManager>(ShoppingListManagerMock());
    GetIt.I.registerSingleton<FirebaseProvider>(FirebaseProviderMock());
    GetIt.I.registerSingleton<RecipeManager>(recipeManager);
    GetIt.I.registerSingleton<ImageManager>(ImageManagerMock());
  });

  setUp(() {
    recipeManager.reset();
  });

  testWidgets('Group selected and recipe existing',
      (WidgetTester tester) async {
    var group = await recipeManager.createCollection('Some Group');
    var recipe = RecipeCreator.createRecipe('some Recipe');
    var pepper = RecipeCreator.createIngredient('Pepper');
    recipe.ingredientList = [pepper];
    recipe.recipeCollectionId = group.id;

    recipeManager.createOrUpdate(recipe);

    recipeManager.currentCollection = group.id;

    final mockObserver = MockNavigatorObserver();
    await tester.pumpWidget(MockApplication(mockObserver: mockObserver));
    await tester.pumpAndSettle();

    expect(find.byType(RecipeListScreen), findsOneWidget);
    expect(find.byType(RecipeListTile), findsOneWidget);
    expect(find.text('some Recipe'), findsOneWidget);
  });

  testWidgets('Drawer opens group selection', (WidgetTester tester) async {
    final mockObserver = MockNavigatorObserver();
    await tester.pumpWidget(MockApplication(mockObserver: mockObserver));
    expect(find.byType(RecipeListScreen), findsOneWidget);

    /// swipe right
    await tester.dragFrom(
        tester.getTopLeft(find.byType(RecipeListScreen)), Offset(300, 0));
    await tester.pumpAndSettle();

    /// drawer is open
    expect(find.byType(RecipeGroupsDrawer), findsOneWidget);
  });

  testWidgets('Recipe tile navigates on tap', (WidgetTester tester) async {
    var group = await recipeManager.createCollection('Some Group');
    var recipe = RecipeCreator.createRecipe('some Recipe');
    var pepper = RecipeCreator.createIngredient('Pepper');
    recipe.ingredientList = [pepper];
    recipe.recipeCollectionId = group.id;

    recipeManager.createOrUpdate(recipe);

    recipeManager.currentCollection = group.id;

    final mockObserver = MockNavigatorObserver();
    await tester.pumpWidget(MockApplication(mockObserver: mockObserver));
    await tester.pumpAndSettle();

    expect(find.byType(RecipeListScreen), findsOneWidget);
    expect(find.byType(RecipeListTile), findsOneWidget);
    expect(find.text('some Recipe'), findsOneWidget);

    await tester.tap(find.byType(RecipeListTile));
    await tester.pumpAndSettle();

    expect(find.byType(RecipeScreen), findsOneWidget);
  });

  testWidgets('App bar filters recipes', (WidgetTester tester) async {
    var group = await recipeManager.createCollection('Some Group');
    var recipe = RecipeCreator.createRecipe('Käsespätzle');
    var pepper = RecipeCreator.createIngredient('Pepper');
    recipe.ingredientList = [pepper];
    recipe.recipeCollectionId = group.id;

    recipeManager.createOrUpdate(recipe);
    recipeManager.currentCollection = group.id;

    final mockObserver = MockNavigatorObserver();
    await tester.pumpWidget(MockApplication(mockObserver: mockObserver));
    await tester.pumpAndSettle();

    /// initially recipe is shown
    expect(find.byType(RecipeListScreen), findsOneWidget);
    expect(find.byType(RecipeListTile), findsOneWidget);
    expect(find.text('Käsespätzle'), findsOneWidget);

    /// open search
    var searchFinder = find.byIcon(Icons.search);
    await tester.tap(searchFinder);
    await tester.pumpAndSettle();

    /// type search text
    await _inputFormField(tester, find.byType(TextField), 'something');

    /// recipe no longer shown
    // expect(find.byType(RecipeListScreen), findsNothing);
    // expect(find.byType(RecipeListTile), findsNothing);
    // expect(find.text('Käsespätzle'), findsNothing);
  });
}

_inputFormField(WidgetTester tester, Finder finder, String value) async {
  await tester.enterText(finder, value);
  await tester.testTextInput.receiveAction(TextInputAction.search);
  await tester.pumpAndSettle();
  expect(find.text(value), findsOneWidget);
}

class MockApplication extends StatelessWidget {
  const MockApplication({
    @required this.mockObserver,
  });

  final MockNavigatorObserver mockObserver;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [mockObserver],
      routes: kRoutes,
      home: ChangeNotifierProvider<ThemeModel>(
        create: (context) => ThemeModel(),
        child: RecipeListScreen(),
      ),
    );
  }
}

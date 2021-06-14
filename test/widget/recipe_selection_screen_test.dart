import 'package:cookza/model/entities/mutable/mutable_ingredient_group.dart';
import 'package:cookza/model/entities/mutable/mutable_instruction.dart';
import 'package:cookza/model/entities/mutable/mutable_recipe.dart';
import 'package:cookza/routes.dart';
import 'package:cookza/screens/recipe_selection_screen.dart';
import 'package:cookza/services/shared_preferences_provider.dart';
import 'package:cookza/viewmodel/recipe_selection_model.dart';
import 'package:cookza/viewmodel/recipe_view/recipe_view_model.dart';
import 'package:cookza/viewmodel/settings/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../mocks/shared_mocks.mocks.dart';
import '../utils/recipe_creator.dart';

void main() {
  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
    GetIt.I.registerSingletonAsync<SharedPreferencesProvider>(
        () async => SharedPreferencesProviderImpl().init());
  });

  testWidgets('Select and deselect recipe in export mode',
      (WidgetTester tester) async {
    final observer = MockNavigatorObserver();
    final model = RecipeSelectionModel.forExport(
        [RecipeViewModel.of(_createRecipe('SomeTestRecipe'))]);
    await _verifySelectDeselect(tester, observer, model);
  });

  testWidgets('Select and deselect recipe in export PDF mode',
      (WidgetTester tester) async {
    final observer = MockNavigatorObserver();
    final model = RecipeSelectionModel.forExportPDF(
        [RecipeViewModel.of(_createRecipe('SomeTestRecipe'))]);
    await _verifySelectDeselect(tester, observer, model);
  });

  testWidgets('Select and deselect recipe in reference ingredient mode',
      (WidgetTester tester) async {
    final observer = MockNavigatorObserver();
    final model = RecipeSelectionModel.forReferenceIngredient(
        [RecipeViewModel.of(_createRecipe('SomeTestRecipe'))], []);
    await _verifySelectDeselect(tester, observer, model);
  });

  testWidgets('Select and deselect recipe in reference ingredient mode',
      (WidgetTester tester) async {
    final observer = MockNavigatorObserver();
    final model = RecipeSelectionModel.forAddMealPlan(
        [RecipeViewModel.of(_createRecipe('SomeTestRecipe'))]);
    await _verifySelectDeselect(tester, observer, model);
  });

  testWidgets('Select and deselect recipe in reference ingredient mode',
      (WidgetTester tester) async {
    final observer = MockNavigatorObserver();
    final model = RecipeSelectionModel.forImport(
        [RecipeViewModel.of(_createRecipe('SomeTestRecipe'))]);
    await _verifySelectDeselect(tester, observer, model);
  });

  testWidgets('Deselect and select all for export mode',
      (WidgetTester tester) async {
    final observer = MockNavigatorObserver();
    final model = RecipeSelectionModel.forExport([
      RecipeViewModel.of(_createRecipe('SomeTestRecipe')),
      RecipeViewModel.of(_createRecipe('SomeTestRecipe2')),
      RecipeViewModel.of(_createRecipe('SomeTestRecipe3'))
    ]);
    await _initApp(tester, observer, model);

    var selectAll = find.text('Select All');
    expect(selectAll, findsOneWidget);

    var deselectAll = find.text('Deselect All');
    expect(deselectAll, findsOneWidget);

    final checked = find.byIcon(Icons.check_box);
    expect(checked, findsNWidgets(3));

    await tester.tap(deselectAll);
    await tester.pumpAndSettle();
    expect(checked, findsNothing);

    await tester.tap(selectAll);
    await tester.pumpAndSettle();
    expect(checked, findsNWidgets(3));
  });

  testWidgets('Search recipe in export mode', (WidgetTester tester) async {
    final observer = MockNavigatorObserver();
    final model = RecipeSelectionModel.forExport([
      RecipeViewModel.of(_createRecipe('SomeTestRecipe With Milk')),
      RecipeViewModel.of(_createRecipe('SomeTestRecipe With Flour')),
      RecipeViewModel.of(_createRecipe('SomeTestRecipe  With Curry'))
    ]);
    await _initApp(tester, observer, model);

    final recipeTile = find.byType(ListTile);
    expect(recipeTile, findsNWidgets(3));

    await tester.enterText(find.byType(TextField), 'rry');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(recipeTile, findsOneWidget);

    await tester.enterText(find.byType(TextField), '');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(recipeTile, findsNWidgets(3));
  });
}

Future _verifySelectDeselect(WidgetTester tester,
    MockNavigatorObserver observer, RecipeSelectionModel model) async {
  await _initApp(tester, observer, model);

  var tile = find.text('SomeTestRecipe');
  expect(tile, findsOneWidget);

  if (model.isMultiSelection) {
    final checked = find.byIcon(Icons.check_box);
    expect(checked, findsOneWidget);
  } else {
    final checked = find.byIcon(Icons.radio_button_checked);
    expect(checked, findsNothing);
  }

  await tester.tap(tile);
  await tester.pumpAndSettle();

  if (model.isMultiSelection) {
    final checked = find.byIcon(Icons.check_box);
    expect(checked, findsNothing);
  } else {
    final checked = find.byIcon(Icons.radio_button_checked);
    expect(checked, findsOneWidget);
  }
}

MutableRecipe _createRecipe(String name) {
  /// create the recipe
  var recipe = RecipeCreator.createRecipe(name);
  recipe.recipeCollectionId = '';
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
  return recipe;
}

Future<void> _initApp(WidgetTester tester, NavigatorObserver observer,
    RecipeSelectionModel arg) async {
  await tester.pumpWidget(
    ChangeNotifierProvider<ThemeModel>.value(
      value: ThemeModel(),
      builder: (context, child) {
        return MaterialApp(
          routes: kRoutes,
          navigatorObservers: [observer],
          localizationsDelegates: [
            AppLocalizations.delegate,
          ],
          home: ChangeNotifierProvider<ThemeModel>(
            create: (context) => ThemeModel(),
            child: Navigator(
              onGenerateRoute: (_) {
                return MaterialPageRoute<Widget>(
                  builder: (_) => RecipeSelectionScreen(),
                  settings: RouteSettings(arguments: arg),
                );
              },
            ),
          ),
        );
      },
    ),
  );
}

import 'package:cookza/components/round_icon_button.dart';
import 'package:cookza/screens/recipe_view/ingredients_tab.dart';
import 'package:cookza/services/recipe/image_manager.dart';
import 'package:cookza/services/shared_preferences_provider.dart';
import 'package:cookza/services/unit_of_measure.dart';
import 'package:cookza/viewmodel/recipe_view/recipe_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../mocks/image_manager_mock.dart';
import '../../mocks/uom_provider_mock.dart';
import '../../utils/localization_parent.dart';
import '../../utils/recipe_creator.dart';

void main() {
  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
    GetIt.I.registerSingleton<ImageManager>(ImageManagerMock());
    GetIt.I.registerSingleton<UnitOfMeasureProvider>(UoMMock());

    GetIt.I.registerSingletonAsync<SharedPreferencesProvider>(
        () async => SharedPreferencesProviderImpl().init());
  });

  testWidgets('ingredients tab displays ingredients',
      (WidgetTester tester) async {
    var recipe = RecipeCreator.createRecipe('My Recipe');
    var onion = RecipeCreator.createIngredient('Onion', amount: 3);
    recipe.ingredientList = [onion];
    var viewModel = RecipeViewModel.of(recipe);

    await _startWidget(tester, viewModel);

    await tester.pumpAndSettle();

    final buttons = find.byType(RoundIconButton);
    expect(buttons, findsNWidgets(2));

    final table = find.byType(DataTable);
    expect(table, findsOneWidget);

    final ingredient = find.text('Onion');
    expect(ingredient, findsOneWidget);

    final amount = find.text('3');
    expect(amount, findsOneWidget);
  });

  testWidgets('increase servings', (WidgetTester tester) async {
    var recipe = RecipeCreator.createRecipe('My Recipe');
    recipe.servings = 2;
    var onion = RecipeCreator.createIngredient('Onion', amount: 2);
    recipe.ingredientList = [onion];
    var viewModel = RecipeViewModel.of(recipe);

    await _startWidget(tester, viewModel);

    await tester.pumpAndSettle();

    final amount = find.text('2');
    expect(amount, findsOneWidget);

    final buttons = find.byType(RoundIconButton);
    await tester.tap(buttons.at(1));
    await tester.pump();

    final newAmount = find.text('3');
    expect(newAmount, findsOneWidget);
  });

  testWidgets('decrease servings', (WidgetTester tester) async {
    var recipe = RecipeCreator.createRecipe('My Recipe');
    recipe.servings = 2;
    var onion = RecipeCreator.createIngredient('Onion', amount: 2);
    recipe.ingredientList = [onion];
    var viewModel = RecipeViewModel.of(recipe);

    await _startWidget(tester, viewModel);

    await tester.pumpAndSettle();

    final amount = find.text('2');
    expect(amount, findsOneWidget);

    final buttons = find.byType(RoundIconButton);
    await tester.tap(buttons.first);
    await tester.pump();

    final newAmount = find.text('1');
    expect(newAmount, findsOneWidget);
  });
}

Future _startWidget(WidgetTester tester, RecipeViewModel viewModel) async {
  await tester.pumpWidget(MaterialApp(
    home: Material(
      child: ChangeNotifierProvider<RecipeViewModel>.value(
        value: viewModel,
        child: LocalizationParent(IngredientsTab()),
      ),
    ),
  ));
}

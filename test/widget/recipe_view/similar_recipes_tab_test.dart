import 'package:cookza/components/nothing_found.dart';
import 'package:cookza/components/recipe_list_tile.dart';
import 'package:cookza/model/entities/mutable/mutable_instruction.dart';
import 'package:cookza/screens/recipe_view/similar_recipes_tab.dart';
import 'package:cookza/services/recipe/recipe_manager.dart';
import 'package:cookza/services/recipe/similarity_service.dart';
import 'package:cookza/services/shared_preferences_provider.dart';
import 'package:cookza/viewmodel/recipe_view/recipe_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../mocks/recipe_manager_mock.dart';
import '../../mocks/shared_mocks.mocks.dart';
import '../../utils/localization_parent.dart';
import '../../utils/recipe_creator.dart';

void main() {
  final smMock = MockSimilarityService();
  final recipeManager = RecipeManagerStub();

  setUpAll(() {
    SharedPreferences.setMockInitialValues({});

    GetIt.I.registerSingletonAsync<SharedPreferencesProvider>(
        () async => SharedPreferencesProviderImpl().init());
    GetIt.I.registerSingleton<SimilarityService>(smMock);
    GetIt.I.registerSingleton<RecipeManager>(recipeManager);
  });

  testWidgets('no similar recipes', (WidgetTester tester) async {
    var recipe = RecipeCreator.createRecipe('My Recipe');
    recipe.instructionList = [
      MutableInstruction.withValues(text: 'the first one'),
      MutableInstruction.withValues(text: 'the second one')
    ];
    var viewModel = RecipeViewModel.of(recipe);
    when(smMock.getSimilarRecipes(any)).thenAnswer((_) => Future.value([]));

    await _startWidget(tester, viewModel);
    await tester.pumpAndSettle();

    expect(find.byType(SimilarRecipesScreen), findsOneWidget);
    expect(find.byType(NothingFound), findsOneWidget);
  });

  testWidgets('one similar recipes', (WidgetTester tester) async {
    var recipe = RecipeCreator.createRecipe('My Recipe');
    recipe.instructionList = [
      MutableInstruction.withValues(text: 'the first one'),
      MutableInstruction.withValues(text: 'the second one')
    ];
    var viewModel = RecipeViewModel.of(recipe);
    when(smMock.getSimilarRecipes(any))
        .thenAnswer((_) => Future.value([recipe]));

    await _startWidget(tester, viewModel);
    await tester.pumpAndSettle();

    expect(find.byType(SimilarRecipesScreen), findsOneWidget);
    expect(find.byType(RecipeListTile), findsOneWidget);
    expect(find.byType(NothingFound), findsNothing);
  });
}

Future _startWidget(WidgetTester tester, RecipeViewModel viewModel) async {
  await tester.pumpWidget(MaterialApp(
    home: Material(
      child: ChangeNotifierProvider<RecipeViewModel>.value(
        value: viewModel,
        child: const LocalizationParent(SimilarRecipesScreen()),
      ),
    ),
  ));
}

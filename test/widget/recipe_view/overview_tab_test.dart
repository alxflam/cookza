import 'package:cookza/model/entities/abstract/recipe_entity.dart';
import 'package:cookza/screens/recipe_view/overview_tab.dart';
import 'package:cookza/services/recipe/image_manager.dart';
import 'package:cookza/services/recipe/recipe_manager.dart';
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
import '../../utils/recipe_creator.dart';

void main() {
  final imageManager = MockImageManager();
  final recipeManager = RecipeManagerStub();

  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
    GetIt.I.registerSingleton<RecipeManager>(recipeManager);
    GetIt.I.registerSingleton<ImageManager>(imageManager);
    GetIt.I.registerSingletonAsync<SharedPreferencesProvider>(
        () async => SharedPreferencesProviderImpl().init());
    when(imageManager.getRecipeImageFile(any))
        .thenAnswer((_) => Future.value(null));
  });

  testWidgets('Overview tab displays general recipe information',
      (WidgetTester tester) async {
    var recipe = RecipeCreator.createRecipe('My Recipe');
    recipe.description = 'My description';
    recipe.duration = 65;
    recipe.difficulty = DIFFICULTY.HARD;
    recipe.addTag('vegetarian');

    await tester.pumpWidget(MaterialApp(
      home: Material(
        child: ChangeNotifierProvider<RecipeViewModel>(
          create: (context) => RecipeViewModel.of(recipe),
          child: OverviewTab(),
        ),
      ),
    ));

    final name = find.text('My Recipe');
    expect(name, findsOneWidget);

    final desc = find.text('My description');
    expect(desc, findsOneWidget);

    final duration = find.text('65min');
    expect(duration, findsOneWidget);

    final veggie = find.text('vegetarian');
    expect(veggie, findsOneWidget);

    final rating = find.byIcon(Icons.star);
    expect(rating, findsNWidgets(5));
  });
}

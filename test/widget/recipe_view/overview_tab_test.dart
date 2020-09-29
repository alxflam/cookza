import 'package:cookza/model/entities/abstract/recipe_entity.dart';
import 'package:cookza/screens/recipe_view/overview_tab.dart';
import 'package:cookza/services/recipe/image_manager.dart';
import 'package:cookza/services/shared_preferences_provider.dart';
import 'package:cookza/viewmodel/recipe_view/recipe_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_translate/localization.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../mocks/image_manager_mock.dart';
import '../../utils/recipe_creator.dart';

void main() {
  setUpAll(() {
    Map<String, dynamic> translations = {};
    Localization.load(translations);
    SharedPreferences.setMockInitialValues({});
    GetIt.I.registerSingleton<ImageManager>(ImageManagerMock());
    GetIt.I.registerSingletonAsync<SharedPreferencesProvider>(
        () async => SharedPreferencesProviderImpl().init());
  });

  testWidgets('Overview tab displays general recipe information',
      (WidgetTester tester) async {
    var recipe = RecipeCreator.createRecipe('My Recipe');
    recipe.description = 'My description';
    recipe.duration = 65;
    recipe.rating = 3;
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

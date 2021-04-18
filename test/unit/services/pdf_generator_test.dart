import 'package:cookza/model/entities/abstract/recipe_entity.dart';
import 'package:cookza/services/flutter/navigator_service.dart';
import 'package:cookza/services/pdf_generator.dart';
import 'package:cookza/services/recipe/image_manager.dart';
import 'package:cookza/viewmodel/recipe_view/recipe_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../mocks/shared_mocks.mocks.dart';
import '../../utils/recipe_creator.dart';

var imageManager = MockImageManager();
var navigatorService = NavigatorService();

void main() {
  setUpAll(() async {
    GetIt.I.registerSingleton<NavigatorService>(navigatorService);
    GetIt.I.registerSingleton<ImageManager>(imageManager);
  });

  setUp(() {});

  testWidgets('Create PDF', (WidgetTester tester) async {
    await _initApp(tester, navigatorService.navigatorKey);

    var recipe = RecipeCreator.createRecipe('My Recipe');
    recipe.description = 'My description';
    recipe.duration = 65;
    recipe.rating = 3;
    recipe.difficulty = DIFFICULTY.HARD;
    recipe.addTag('vegetarian');

    var recipeViewModel = RecipeViewModel.of(recipe);

    when(imageManager.getRecipeImageFile(any))
        .thenAnswer((_) => Future.value(null));
    var cut = PDFGeneratorImpl();
    var doc = await cut.generatePDF([recipeViewModel]);

    // TODO: improve testcase
    expect(doc, isNotNull);
  });
}

Future<void> _initApp(
    WidgetTester tester, GlobalKey<NavigatorState> navKey) async {
  await tester.pumpWidget(MaterialApp(
    localizationsDelegates: [
      AppLocalizations.delegate,
    ],
    navigatorKey: navKey,
    home: Container(),
  ));
}

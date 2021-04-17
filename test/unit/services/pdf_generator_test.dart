import 'package:cookza/model/entities/abstract/recipe_entity.dart';
import 'package:cookza/services/flutter/navigator_service.dart';
import 'package:cookza/services/pdf_generator.dart';
import 'package:cookza/services/recipe/image_manager.dart';
import 'package:cookza/viewmodel/recipe_view/recipe_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/shared_mocks.mocks.dart';
import '../../utils/recipe_creator.dart';

var imageManager = MockImageManager();

void main() {
  setUpAll(() async {
    // TODO: needs to run as a widget test as a build context is needed...
    GetIt.I.registerSingleton<NavigatorService>(MockNavigatorService());
    GetIt.I.registerSingleton<ImageManager>(imageManager);
  });

  setUp(() {});

  test('Create PDF', () async {
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

    expect(doc, isNotNull);
  });
}

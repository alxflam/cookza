import 'package:cookza/components/recipe_list_tile.dart';
import 'package:cookza/components/recipe_rating_bar.dart';
import 'package:cookza/model/entities/mutable/mutable_ingredient_group.dart';
import 'package:cookza/model/entities/mutable/mutable_ingredient_note.dart';
import 'package:cookza/model/entities/mutable/mutable_instruction.dart';
import 'package:cookza/model/entities/mutable/mutable_recipe.dart';
import 'package:cookza/screens/favorites/favorites_screen.dart';
import 'package:cookza/services/recipe/recipe_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../utils/firebase.dart';

void main() {
  setUp(() async {
    await mockFirestore();
  });

  testWidgets('favorites are shown ordered', (WidgetTester tester) async {
    await _addRecipe('Salad', 3);
    await _addRecipe('Cheese', 5);
    await _addRecipe('Pasta', 0);
    await _addRecipe('Onions', 2);

    await _openFavoritesScreen(tester);
    await tester.pumpAndSettle();

    final tiles = find.byType(RecipeListTile);
    expect(tiles, findsNWidgets(1));

    final stars = find.descendant(
        of: find.byType(RecipeRatingBar), matching: find.byIcon(Icons.star));
    expect(stars.evaluate().length, 5);

    // select fourth star
    await tester.tap(stars.at(3));
    await tester.pumpAndSettle();
    expect(tiles, findsNWidgets(1));

    // select third star
    await tester.tap(stars.at(2));
    await tester.pumpAndSettle();
    expect(tiles, findsNWidgets(2));

    // select second star
    await tester.tap(stars.at(1));
    await tester.pumpAndSettle();
    expect(tiles, findsNWidgets(3));

    // select fifth star
    await tester.tap(stars.at(4));
    await tester.pumpAndSettle();
    expect(tiles, findsNWidgets(1));
  });

  testWidgets('no favorite recipe', (WidgetTester tester) async {
    await _addRecipe('Salad', 0);
    await _addRecipe('Cheese', 0);
    await _addRecipe('Pasta', 0);
    await _addRecipe('Onions', 0);

    await _openFavoritesScreen(tester);
    await tester.pumpAndSettle();

    final tiles = find.byType(RecipeListTile);
    expect(tiles, findsNothing);
  });
}

Future<void> _openFavoritesScreen(WidgetTester tester) async {
  await tester.pumpWidget(const MaterialApp(
    localizationsDelegates: [
      AppLocalizations.delegate,
    ],
    home: Material(
      child: FavoriteRecipesScreen(),
    ),
  ));
}

Future<void> _addRecipe(String name, int rating) async {
  var manager = GetIt.I.get<RecipeManager>();
  MutableRecipe recipe = createMutableRecipe(name, '1');
  var recipeId = await manager.createOrUpdate(recipe);
  recipe.id = recipeId;
  if (rating > 0) {
    await manager.updateRating(recipe, rating);
  }
}

MutableRecipe createMutableRecipe(String name, String group) {
  var recipe = MutableRecipe.empty();
  recipe.recipeCollectionId = group;
  recipe.name = name;
  recipe.tags = ['cool'];
  recipe.instructionList = [
    MutableInstruction.withValues(text: 'Some instruction')
  ];
  recipe.ingredientGroupList = [
    MutableIngredientGroup.forValues(
        1, 'Test', [MutableIngredientNote.empty()..name = 'Onions'])
  ];

  return recipe;
}

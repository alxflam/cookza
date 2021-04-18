import 'package:cookza/model/entities/firebase/user_entity.dart';
import 'package:cookza/model/entities/mutable/mutable_ingredient_note.dart';
import 'package:cookza/model/entities/mutable/mutable_instruction.dart';
import 'package:cookza/model/entities/mutable/mutable_recipe.dart';
import 'package:cookza/model/firebase/general/firebase_user.dart';
import 'package:cookza/services/recipe/recipe_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../utils/firebase.dart';

void main() {
  setUp(() async {
    await mockFirestore();
  });

  test('Create collection', () async {
    var cut = RecipeManagerFirebase();

    await cut.createCollection('Test');

    var collections = await cut.collections;

    expect(collections.first.name, 'Test');
  });

  test('Delete collection', () async {
    var cut = RecipeManagerFirebase();

    var group = await cut.createCollection('Test');

    await cut.deleteCollection(group);

    var collections = await cut.collections;

    expect(collections, isEmpty);
  });

  test('Delete collection resets current collection if current got deleted',
      () async {
    var cut = RecipeManagerFirebase();

    var group = await cut.createCollection('Test');
    cut.currentCollection = group.id!;

    await cut.deleteCollection(group);
    var collections = await cut.collections;

    expect(collections, isEmpty);
    expect(cut.currentCollection, isNull);
  });

  test('Rename collection', () async {
    var cut = RecipeManagerFirebase();

    var group = await cut.createCollection('Test');

    await cut.renameCollection('Cheese', group);

    var collections = await cut.collections;

    expect(collections.first.name, 'Cheese');
    expect(collections.length, 1);
  });

  test('Collections as stream', () async {
    var cut = RecipeManagerFirebase();

    await cut.createCollection('Test');

    var collections = await cut.collectionsAsStream;

    expect(collections, isNotNull);
  });

  test('Set and get current collection', () async {
    var cut = RecipeManagerFirebase();

    var group = cut.currentCollection;
    expect(group, isNull);

    cut.currentCollection = '1';
    group = cut.currentCollection;
    expect(group, '1');
  });

  test('Add user to group', () async {
    var cut = RecipeManagerFirebase();

    var group = await cut.createCollection('Test');

    await cut.addUserToCollection(group, '42', 'Tux');

    var collection = await cut.collectionByID(group.id!);

    expect(collection.users.last.name, 'Tux');
  });

  test('Remove user from group', () async {
    var cut = RecipeManagerFirebase();

    var group = await cut.createCollection('Test');

    await cut.addUserToCollection(group, '42', 'Tux');
    var collection = await cut.collectionByID(group.id!);
    expect(collection.users.last.name, 'Tux');

    await cut.removeMember(
        UserEntityFirebase.from(FirebaseRecipeUser(name: 'Tux', id: '42')),
        group.id!);
    collection = await cut.collectionByID(group.id!);

    /// only the auto generated owner entry is now present
    expect(collection.users.last.name, 'owner');
  });

  test('Leave group', () async {
    var cut = RecipeManagerFirebase();

    var group = await cut.createCollection('Test');

    await cut.leaveRecipeGroup(group);
    var collections = await cut.collections;

    expect(collections, isEmpty);
    var currentCollection = await cut.currentCollection;
    expect(currentCollection, isNull);
  });

  test('Create a recipe', () async {
    var cut = RecipeManagerFirebase();
    MutableRecipe recipe = createMutableRecipe('Test', '1');

    var id = await cut.createOrUpdate(recipe);
    expect(id, isNotNull);
    expect(id, isNotEmpty);

    var recipes = await cut.getRecipeById([id]);
    expect(recipes.first.name, 'Test');
  });

  test('Delete a recipe', () async {
    var cut = RecipeManagerFirebase();

    MutableRecipe recipe = createMutableRecipe('Test', '1');

    var id = await cut.createOrUpdate(recipe);
    expect(id, isNotNull);
    expect(id, isNotEmpty);
    recipe.id = id;

    await cut.deleteRecipe(recipe);
    var recipes = await cut.getRecipeById([id]);
    expect(recipes, isEmpty);
  });

  test('Update a recipe', () async {
    var cut = RecipeManagerFirebase();

    MutableRecipe recipe = createMutableRecipe('Test', '1');

    var id = await cut.createOrUpdate(recipe);
    expect(id, isNotNull);
    expect(id, isNotEmpty);
    recipe.id = id;

    await cut.createOrUpdate(MutableRecipe.of(recipe)..name = 'Cheese');

    var recipes = await cut.getRecipeById([id]);
    expect(recipes.first.name, 'Cheese');
  });

  test('Set recipe rating', () async {
    var cut = RecipeManagerFirebase();

    MutableRecipe recipe = createMutableRecipe('Test', '1');

    var id = await cut.createOrUpdate(recipe);
    expect(id, isNotNull);
    expect(id, isNotEmpty);
    recipe.id = id;

    await cut.updateRating(recipe, 4);

    var recipes = await cut.getRecipeById([id]);
    expect(recipes.first.rating, 4);
  });

  test('Get all recipes - no matter which collection', () async {
    var cut = RecipeManagerFirebase();
    var firstGroup = await cut.createCollection('1');
    var secondGroup = await cut.createCollection('2');

    MutableRecipe first = createMutableRecipe('Test', firstGroup.id!);
    MutableRecipe second = createMutableRecipe('Test', secondGroup.id!);

    await cut.createOrUpdate(first);
    await cut.createOrUpdate(second);

    var recipes = await cut.getAllRecipes();

    expect(recipes.length, 2);
  });

  test('Get next recipe id', () async {
    var cut = RecipeManagerFirebase();
    var group = await cut.createCollection('1');

    var nextId = await cut.getNextRecipeDocumentId(group.id!);

    expect(nextId, isNotEmpty);
    expect(nextId == group.id!, false);
  });

  test('Import recipes', () async {
    var cut = RecipeManagerFirebase();
    var group = await cut.createCollection('1');
    cut.currentCollection = group.id!;

    MutableRecipe first = createMutableRecipe('Test', group.id!);
    MutableRecipe second = createMutableRecipe('Test', group.id!);

    await cut.importRecipes([first, second]);

    var recipes = await cut.getAllRecipes();

    expect(recipes.length, 2);
  });

  test('Recipes for current collection', () async {
    var cut = RecipeManagerFirebase();
    var firstGroup = await cut.createCollection('1');
    var secondGroup = await cut.createCollection('2');
    cut.currentCollection = firstGroup.id!;

    MutableRecipe first = createMutableRecipe('Test', firstGroup.id!);
    MutableRecipe second = createMutableRecipe('Test', secondGroup.id!);

    await cut.createOrUpdate(first);
    await cut.createOrUpdate(second);

    var recipes = await cut.recipes;

    expect(recipes, isNotNull);
  });

  test('Recipes returns empty stream if current collection is not set',
      () async {
    var cut = RecipeManagerFirebase();
    var firstGroup = await cut.createCollection('1');
    cut.currentCollection = null;

    MutableRecipe first = createMutableRecipe('Test', firstGroup.id!);

    await cut.createOrUpdate(first);

    var recipes = await cut.recipes;

    expect(await recipes.isEmpty, true);
  });
}

MutableRecipe createMutableRecipe(String name, String group) {
  var recipe = MutableRecipe.empty();
  recipe.recipeCollectionId = group;
  recipe.name = name;
  recipe.tags = ['cool'];
  recipe.instructionList = [
    MutableInstruction.withValues(text: 'Some instruction')
  ];
  recipe.ingredientList = [MutableIngredientNote.empty()..name = 'Onions'];
  return recipe;
}

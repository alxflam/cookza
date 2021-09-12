import 'package:cookza/model/entities/mutable/mutable_ingredient_note.dart';
import 'package:cookza/model/entities/mutable/mutable_recipe.dart';
import 'package:cookza/model/entities/mutable/mutable_shopping_list.dart';
import 'package:cookza/model/entities/mutable/mutable_shopping_list_item.dart';
import 'package:cookza/services/meal_plan_manager.dart';
import 'package:cookza/services/profile_deleter.dart';
import 'package:cookza/services/recipe/image_manager.dart';
import 'package:cookza/services/recipe/recipe_manager.dart';
import 'package:cookza/services/shopping_list/shopping_list_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import '../../mocks/shared_mocks.mocks.dart';
import '../../utils/firebase.dart';
import 'recipe/recipe_manager_test.dart';

void main() {
  setUp(() async {
    await mockFirestore();
    GetIt.I.registerSingleton<ImageManager>(MockImageManager());
  });

  test('Delete profile', () async {
    var shoppingListManager = ShoppingListManagerImpl();
    var mealPlanManager = MealPlanManagerFirebase();

    var recipeManager = RecipeManagerFirebase();
    var firstGroup = await recipeManager.createCollection('1');

    MutableRecipe first = createMutableRecipe('Test', firstGroup.id!);

    await recipeManager.createOrUpdate(first);
    var recipes = await recipeManager.getAllRecipes();
    expect(recipes.length, 1);
    var group = await mealPlanManager.createCollection('Test');

    var retrievedLists = await shoppingListManager.shoppingListsAsList;
    expect(retrievedLists, isEmpty);

    var item = MutableShoppingListItem.ofIngredientNote(
        MutableIngredientNote.empty()..name = 'Test', false, true);
    var list = MutableShoppingList.ofValues(DateTime.now(),
        DateTime.now().add(const Duration(days: 2)), group.id!, [item]);
    var createdList = await shoppingListManager.createOrUpdate(list);
    expect(createdList, isNotNull);

    retrievedLists = await shoppingListManager.shoppingListsAsList;
    expect(retrievedLists, isNotEmpty);

    await ProfileDeleterImpl().delete();

    expect(await recipeManager.collections, isEmpty);
    expect(await mealPlanManager.collections, isEmpty);
    expect(await shoppingListManager.shoppingListsAsList, isEmpty);
  });
}

import 'dart:convert';

import 'package:cookza/model/entities/abstract/recipe_entity.dart';
import 'package:cookza/model/entities/json/recipe_collection_entity.dart';
import 'package:cookza/model/entities/mutable/mutable_recipe.dart';
import 'package:cookza/model/json/recipe.dart';
import 'package:cookza/model/json/recipe_collection.dart';
import 'package:cookza/model/json/recipe_list.dart';
import 'package:cookza/routes.dart';
import 'package:cookza/screens/recipe_modify/new_recipe_screen.dart';
import 'package:cookza/screens/recipe_selection_screen.dart';
import 'package:cookza/services/api/chefkoch.dart';
import 'package:cookza/services/flutter/navigator_service.dart';
import 'package:cookza/services/recipe/image_manager.dart';
import 'package:cookza/services/recipe/recipe_manager.dart';
import 'package:cookza/services/share_receive_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/shared_mocks.mocks.dart';

var imageManager = MockImageManager();
var navigatorService = NavigatorService();
var chefkoch = MockChefkochAccessor();
var recipeManager = MockRecipeManager();
final cut = ShareReceiveHandler();

void main() {
  setUpAll(() async {
    GetIt.I.registerSingleton<NavigatorService>(navigatorService);
    GetIt.I.registerSingleton<ImageManager>(imageManager);
    GetIt.I.registerSingleton<ChefkochAccessor>(chefkoch);
    GetIt.I.registerSingleton<RecipeManager>(recipeManager);
  });

  setUp(() {
    when(imageManager.getRecipeImageFile(any))
        .thenAnswer((_) => Future.value(null));
    when(chefkoch.getRecipe(any))
        .thenAnswer((_) => Future.value(_fakeRecipe()));
  });

  testWidgets('handle shared text', (WidgetTester tester) async {
    const url =
        'https://www.chefkoch.de/rezepte/922651197624364/Philadelphia-Haehnchen.html';
    final observer = MockNavigatorObserver();

    var collection =
        RecipeCollectionEntityJson.of(RecipeCollection(id: 'ID', name: 'Test'));
    when(recipeManager.collectionByID('1'))
        .thenAnswer((_) => Future.value(collection));
    when(recipeManager.collections)
        .thenAnswer((realInvocation) => Future.value([]));

    await _initApp(tester, navigatorService.navigatorKey, observer);
    await tester.pumpAndSettle();

    cut.handleReceivedText(url, Navigator.of(navigatorService.currentContext!));
    verify(observer.didPush(any, any));
    await tester.pumpAndSettle();
    expect(find.byType(NewRecipeScreen), findsOneWidget);
  });

  testWidgets('handle shared json', (WidgetTester tester) async {
    final observer = MockNavigatorObserver();
    await _initApp(tester, navigatorService.navigatorKey, observer);
    await tester.pumpAndSettle();

    var list = RecipeList(recipes: [await Recipe.applyFrom(_fakeRecipe())]);
    var json = jsonEncode(list.toJson());

    cut.handleReceivedJson(
        json, Navigator.of(navigatorService.currentContext!));

    await tester.pumpAndSettle();
    expect(find.byType(RecipeSelectionScreen), findsOneWidget);
  });
}

RecipeEntity _fakeRecipe() {
  var recipe = MutableRecipe.empty();
  recipe.name = 'Noodles';
  recipe.recipeCollectionId = '1';
  recipe.id = '1234';
  recipe.image = '/dummy/';
  return recipe;
}

Future<void> _initApp(WidgetTester tester, GlobalKey<NavigatorState> navKey,
    NavigatorObserver observer) async {
  await tester.pumpWidget(MaterialApp(
    navigatorObservers: [observer],
    localizationsDelegates: const [
      AppLocalizations.delegate,
    ],
    navigatorKey: navKey,
    routes: kRoutes,
    home: Container(),
  ));
}

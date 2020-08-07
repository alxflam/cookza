import 'package:cookly/model/entities/mutable/mutable_instruction.dart';
import 'package:cookly/screens/recipe_view/instructions_tab.dart';
import 'package:cookly/services/shared_preferences_provider.dart';
import 'package:cookly/viewmodel/recipe_view/recipe_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_translate/localization.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/recipe_creator.dart';

void main() {
  setUpAll(() {
    Map<String, dynamic> translations = {};

    Localization.load(translations);
    SharedPreferences.setMockInitialValues({});

    GetIt.I.registerSingletonAsync<SharedPreferencesProvider>(
        () async => SharedPreferencesProviderImpl().init());
  });

  testWidgets('instructions are shown', (WidgetTester tester) async {
    var recipe = RecipeCreator.createRecipe('My Recipe');
    recipe.instructionList = [
      MutableInstruction.withValues(text: 'the first one'),
      MutableInstruction.withValues(text: 'the second one')
    ];
    var viewModel = RecipeViewModel.of(recipe);

    await _startWidget(tester, viewModel);

    final instructions = find.byType(InstructionRow);
    expect(instructions, findsNWidgets(2));
  });
}

Future _startWidget(WidgetTester tester, RecipeViewModel viewModel) async {
  await tester.pumpWidget(MaterialApp(
    home: Material(
      child: ChangeNotifierProvider<RecipeViewModel>.value(
        value: viewModel,
        child: InstructionsTab(),
      ),
    ),
  ));
}

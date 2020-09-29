import 'package:cookza/model/entities/mutable/mutable_instruction.dart';
import 'package:cookza/model/entities/mutable/mutable_recipe.dart';
import 'package:cookza/model/firebase/recipe/firebase_instruction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'Parse instruction from JSON',
    () async {
      var json = {
        'text': 'Some Instruction',
        'step': 2,
        'imagePath': '/some/path',
      };

      var cut = FirebaseInstruction.fromJson(json);

      expect(cut.step, 2);
      expect(cut.text, 'Some Instruction');
      expect(cut.imagePath, '/some/path');
    },
  );

  test(
    'Instruction from Recipe',
    () async {
      var recipe = MutableRecipe.empty();
      var first = MutableInstruction.empty();
      first.text = 'Something';
      first.step = 3;
      first.image = '/some/';

      var second = MutableInstruction.empty();
      second.text = 'Something 2';

      recipe.instructionList = [first, second];

      var cut = await FirebaseInstruction.from(recipe);

      expect(cut.length, 2);
      expect(cut.first.text, 'Something');
      expect(cut.first.step, 3);
      expect(cut.first.imagePath, '/some/');
      expect(cut.last.text, 'Something 2');
      expect(cut.last.step, null);
      expect(cut.last.imagePath, null);
    },
  );

  test(
    'Instruction to JSON',
    () async {
      var json = {
        'text': 'Some Instruction',
        'step': 2,
        'imagePath': '/some/path',
      };

      var cut = FirebaseInstruction.fromJson(json);
      var generatedJson = cut.toJson();

      expect(generatedJson, json);
    },
  );

  test(
    'Document from and to JSON',
    () async {
      var json = {
        'recipeID': '1234',
        'instructions': [
          {'text': 'Some Instruction 1', 'step': null},
          {'text': 'Some Instruction 2', 'step': null}
        ]
      };

      var cut = FirebaseInstructionDocument.fromJson(json, '4567');
      var generatedJson = cut.toJson();

      expect(generatedJson, json);
    },
  );
}

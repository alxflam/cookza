import 'package:cookly/model/entities/firebase/instruction_entity.dart';
import 'package:cookly/model/entities/mutable/mutable_instruction.dart';
import 'package:cookly/model/firebase/recipe/firebase_instruction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'step',
    () async {
      var instruction = FirebaseInstruction.fromInstructionEntity(
          MutableInstruction.withValues(step: 7));
      var cut = InstructionEntityFirebase.of(instruction);
      expect(cut.step, 7);
    },
  );

  test(
    'text',
    () async {
      var instruction = FirebaseInstruction.fromInstructionEntity(
          MutableInstruction.withValues(text: 'dummy'));
      var cut = InstructionEntityFirebase.of(instruction);
      expect(cut.text, 'dummy');
    },
  );

  test(
    'image',
    () async {
      var instruction = FirebaseInstruction.fromInstructionEntity(
          MutableInstruction.withValues(image: '/path/'));
      var cut = InstructionEntityFirebase.of(instruction);
      expect(cut.image, '/path/');
    },
  );
}

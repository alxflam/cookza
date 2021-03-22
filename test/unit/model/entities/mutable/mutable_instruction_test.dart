import 'package:cookza/model/entities/json/instruction_entity.dart';
import 'package:cookza/model/entities/mutable/mutable_instruction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'empty instruction',
    () async {
      var cut = MutableInstruction.empty();

      expect(cut.text, '');
      expect(cut.image, null);
      expect(cut.step, null);
    },
  );

  test(
    'set test',
    () async {
      var cut = MutableInstruction.empty();
      cut.text = 'My Text';
      expect(cut.text, 'My Text');
    },
  );

  test(
    'set step',
    () async {
      var cut = MutableInstruction.empty();
      cut.step = 2;
      expect(cut.step, 2);
    },
  );

  test(
    'set image',
    () async {
      var cut = MutableInstruction.empty();
      cut.image = 'dummy/image/path';
      expect(cut.image, 'dummy/image/path');
    },
  );

  test(
    'with values constructor',
    () async {
      var cut = MutableInstruction.withValues(
          image: 'dummy/image/path', text: 'My Text', step: 1);
      expect(cut.text, 'My Text');
      expect(cut.step, 1);
      expect(cut.image, 'dummy/image/path');
    },
  );

  test(
    'of constructor',
    () async {
      var cut = MutableInstruction.of(InstructionEntityJson.of('My Text'));
      expect(cut.text, 'My Text');
      expect(cut.step, 1);
      expect(cut.image, null);
    },
  );
}

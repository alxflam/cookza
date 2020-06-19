import 'package:cookly/model/entities/abstract/instruction_entity.dart';

class InstructionEntityJson implements InstructionEntity {
  String _instruction;

  InstructionEntityJson.of(String instruction) {
    this._instruction = instruction;
  }

  @override
  String get image => throw UnsupportedError('image is not implemented');

  @override
  int get step => throw UnsupportedError('step is not supported');

  @override
  String get text => this._instruction;
}

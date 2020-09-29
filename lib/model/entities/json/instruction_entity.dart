import 'package:cookza/model/entities/abstract/instruction_entity.dart';

class InstructionEntityJson implements InstructionEntity {
  String _instruction;

  InstructionEntityJson.of(String instruction) {
    this._instruction = instruction;
  }

  @override
  String get image => null;

  @override
  int get step => null;

  @override
  String get text => this._instruction;
}

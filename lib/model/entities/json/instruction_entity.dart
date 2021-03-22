import 'package:cookza/model/entities/abstract/instruction_entity.dart';

class InstructionEntityJson implements InstructionEntity {
  final String _instruction;

  InstructionEntityJson.of(this._instruction);
  @override
  String? get image => null;

  @override
  int get step => 1;

  @override
  String get text => this._instruction;
}

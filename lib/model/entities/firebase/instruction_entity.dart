import 'package:cookza/model/entities/abstract/instruction_entity.dart';
import 'package:cookza/model/firebase/recipe/firebase_instruction.dart';

class InstructionEntityFirebase implements InstructionEntity {
  final FirebaseInstruction _instruction;

  InstructionEntityFirebase.of(this._instruction);

  @override
  String? get image => this._instruction.imagePath;

  @override
  int? get step => this._instruction.step;

  @override
  String get text => this._instruction.text;
}

import 'package:cookly/model/entities/abstract/instruction_entity.dart';

class MutableInstruction implements InstructionEntity {
  int _step;
  String _image;
  String _text;

  MutableInstruction.of(InstructionEntity entity) {
    this._step = entity.step;
    this._image = entity.image;
    this._text = entity.text;
  }

  MutableInstruction.empty() {
    _step = null;
    _image = '';
    _text = '';
  }

  MutableInstruction.withValues({String text, int step, String image}) {
    _step = step;
    _image = image == null ? '' : image;
    _text = text == null ? '' : text;
  }

  @override
  String get image => _image;

  set image(String value) {
    this._image = value;
  }

  @override
  int get step => _step;

  set step(int value) {
    this._step = value;
  }

  @override
  String get text => _text;

  set text(String value) {
    this._text = value;
  }
}
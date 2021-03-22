import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:mockito/mockito.dart';

class FakeFile extends Fake implements File {
  bool _exists = false;
  String _content = '';
  Uint8List _byteContent = Uint8List.fromList([]);

  void stubExists(bool value) => this._exists = value;

  void stubByteContent(Uint8List value) => this._byteContent = value;

  void stubContent(String value) => this._content = value;

  @override
  Uint8List readAsBytesSync() => this._byteContent;

  @override
  Future<Uint8List> readAsBytes() => Future.value(this._byteContent);

  @override
  bool existsSync() => this._exists;

  @override
  Future<bool> exists() => Future.value(this._exists);

  @override
  String readAsStringSync({Encoding encoding = utf8}) => this._content;

  @override
  Future<String> readAsString({Encoding encoding = utf8}) =>
      Future.value(this._content);
}

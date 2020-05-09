import 'package:flutter/cupertino.dart';

abstract class RecipeFileImport {
  void parseAndImport(BuildContext context, {bool selectionDialog = true});
}

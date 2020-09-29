import 'package:cookza/model/entities/abstract/ingredient_entity.dart';

abstract class IngredientNoteEntity {
  IngredientEntity get ingredient;
  String get unitOfMeasure;
  double get amount;
}

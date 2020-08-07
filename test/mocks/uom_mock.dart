import 'package:cookly/services/unit_of_measure.dart';
import 'package:mockito/mockito.dart';

class UoMMock extends Mock implements UnitOfMeasureProvider {
  @override
  List<UnitOfMeasure> getAll() {
    return [];
  }

  @override
  List<UnitOfMeasure> getVisible() {
    return [];
  }
}

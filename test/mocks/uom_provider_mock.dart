import 'package:cookza/services/unit_of_measure.dart';
import 'package:mockito/mockito.dart';

import 'unit_of_measure_mock.dart';

class UoMMock extends Mock implements UnitOfMeasureProvider {
  @override
  List<UnitOfMeasure> getAll() {
    return [];
  }

  @override
  List<UnitOfMeasure> getVisible() {
    return [];
  }

  @override
  UnitOfMeasure getUnitOfMeasureById(String id) {
    return UnitOfMeasureMock(id);
  }
}

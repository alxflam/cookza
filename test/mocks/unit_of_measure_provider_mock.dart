import 'package:cookza/services/unit_of_measure.dart';
import 'package:mockito/mockito.dart';

class UnitOfMeasureProviderMock extends Mock implements UnitOfMeasureProvider {
  @override
  List<UnitOfMeasure> getAll() {
    return [];
  }
}

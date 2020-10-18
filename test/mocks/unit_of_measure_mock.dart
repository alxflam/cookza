import 'package:cookza/services/unit_of_measure.dart';
import 'package:mockito/mockito.dart';

class UnitOfMeasureMock extends Mock implements UnitOfMeasure {
  @override
  final String id;

  UnitOfMeasureMock(this.id);

  @override
  String getDisplayName(int amount) {
    return id;
  }

  @override
  String get displayName => id;
}

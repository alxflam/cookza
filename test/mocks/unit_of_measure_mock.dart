import 'package:cookly/services/unit_of_measure.dart';
import 'package:mockito/mockito.dart';

class UnitOfMeasureMock extends Mock implements UnitOfMeasure {
  final String id;

  UnitOfMeasureMock(this.id);

  @override
  String getDisplayName(int amount) {
    return id;
  }

  @override
  String get displayName => id;
}

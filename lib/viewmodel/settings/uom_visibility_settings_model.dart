import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/services/shared_preferences_provider.dart';
import 'package:cookza/services/unit_of_measure.dart';
import 'package:flutter/material.dart';

class UoMVisibilitySettingsModel extends ChangeNotifier {
  final List<UnitOfMeasure> _allUoMs = sl.get<UnitOfMeasureProvider>().getAll();
  final SharedPreferencesProvider _prefs = sl.get<SharedPreferencesProvider>();

  UoMVisibilitySettingsModel.create();

  int get countAll => _allUoMs.length;

  bool isVisible(UnitOfMeasure uom) {
    return _prefs.isUnitOfMeasureVisible(uom.id);
  }

  void setVisible(UnitOfMeasure uom, bool value) async {
    _prefs.setUnitOfMeasureVisibility(uom.id, value);
    notifyListeners();
  }

  UnitOfMeasure getByIndex(int index) {
    return _allUoMs[index];
  }
}

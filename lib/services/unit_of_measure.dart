import 'package:cookly/services/flutter/service_locator.dart';
import 'package:cookly/services/shared_preferences_provider.dart';
import 'package:flutter_translate/flutter_translate.dart';

/// metric unit of measures supporting conversion
var metricUoM = [
  // codes standardized by UNECE/CEFACT Trade Facilitation Recommendation No.20
  MetricUnitOfMeasure('MMT', 'MTR', 10e-4), // millimetre
  MetricUnitOfMeasure('CMT', 'MTR', 10e-3), // centimetre
  MetricUnitOfMeasure('MTR', 'MTR', 1), // metre
  MetricUnitOfMeasure('GRM', 'KGM', 10e-4), // gram
  MetricUnitOfMeasure('KGM', 'KGM', 1), // kilogram
  MetricUnitOfMeasure('MLT', 'LTR', 10e-4), // millilitre
  MetricUnitOfMeasure('CLT', 'LTR', 10e-3), // centilitre
  MetricUnitOfMeasure('DLT', 'LTR', 10e-2), // decilitre
  MetricUnitOfMeasure('LTR', 'LTR', 1), // litre
].toSet();

/// non metric unit of measures
Set<String> nonMetricUoMIds = [
  // codes standardized by UNECE/CEFACT Trade Facilitation Recommendation No.20
  'H87', // piece
  'G21', // cup
  'G24', // tablespoon
  'G25', // teaspoon
  'BG', // bag
  'LEF', // leaf
  'X2', // bunch
  'X4', // drop
  'CA', // can
  'BO', // bottle
  'STC', // stick
  'PR', // pair
  'PA', // packet
  'PTN', // portion
  'BR', // bar
  'RO', // roll
  '14', // shot
  'SR', // strip
  'TU', // tube
  // from here on non standardized unit codes
  'SLI', // slice
  'GLA', // glass
  'HAN', // handful
  'PIN', // pinch
  'BOW', // bowl
  'STE', // stem
  'CUB', // cubes
  'CLO', // clove
  'ROT', // root
  'TWG', // twig
].toSet();

Set<UnitOfMeasure> nonMetricUoM =
    nonMetricUoMIds.map((e) => UnitOfMeasure(e)).toSet();

abstract class UnitOfMeasureProvider {
  List<UnitOfMeasure> getAll();
  List<UnitOfMeasure> getVisible();
  UnitOfMeasure getUnitOfMeasureById(final String id);
}

class UnitOfMeasure {
  String _id;

  UnitOfMeasure(this._id);

  /// returns the display name
  String get displayName {
    return translatePlural('unitOfMeasure.$_id', 1);
  }

  /// returns the display name depending on the count of items referenced
  String getDisplayName(int amount) {
    return translatePlural('unitOfMeasure.$_id', amount);
  }

  /// returns the internal identifier for this unit of measure
  String get id {
    return this._id;
  }

  bool canBeConvertedTo(UnitOfMeasure uom) {
    return uom.id == this.id;
  }
}

class MetricUnitOfMeasure extends UnitOfMeasure {
  String _baseUnit;
  double _conversionFactor;

  MetricUnitOfMeasure(String id, this._baseUnit, this._conversionFactor)
      : super(id);

  String get baseUnit => _baseUnit;

  double get conversionFactor => _conversionFactor;

  @override
  bool canBeConvertedTo(UnitOfMeasure uom) {
    if (uom is MetricUnitOfMeasure) {
      return uom.baseUnit == this.baseUnit;
    }
    return false;
  }
}

class AmountedUnitOfMeasure {
  UnitOfMeasure _uom;
  double _amount;

  double get amount => _amount;
  UnitOfMeasure get uom => _uom;

  AmountedUnitOfMeasure(this._uom, this._amount);

  AmountedUnitOfMeasure nextBiggerUoM() {
    if (_uom is MetricUnitOfMeasure) {
      var uom = _uom as MetricUnitOfMeasure;

      // directly return if there's no next bigger dimension
      if (uom.conversionFactor == 1) {
        return this;
      }
      // retrieve next bigger uom => uom with same base unit but lower conversion factor
      List<MetricUnitOfMeasure> sameBaseUnit = _getSameBaseUnit(uom);
      var targetUoM = sameBaseUnit.first;
      // then convert to base unit
      var targetAmount = _amount * uom._conversionFactor;

      // then convert to fetched next base unit
      var result = targetAmount / targetUoM.conversionFactor;

      return AmountedUnitOfMeasure(targetUoM, result);
    }
    return this;
  }

  List<MetricUnitOfMeasure> _getSameBaseUnit(MetricUnitOfMeasure uom,
      {bool descending = false}) {
    var sameBaseUnit = metricUoM
        .where((element) =>
            element.baseUnit == uom.baseUnit && element._id != uom._id)
        .toList();
    if (descending) {
      sameBaseUnit
          .sort((a, b) => b._conversionFactor.compareTo(a._conversionFactor));
    } else {
      sameBaseUnit
          .sort((a, b) => a._conversionFactor.compareTo(b._conversionFactor));
    }
    return sameBaseUnit;
  }

  AmountedUnitOfMeasure nextLowerUoM() {
    if (_uom is MetricUnitOfMeasure) {
      var uom = _uom as MetricUnitOfMeasure;

      // retrieve next lower uom => uom with same base unit but higher conversion factor
      List<MetricUnitOfMeasure> sameBaseUnit =
          _getSameBaseUnit(uom, descending: true);

      // get descending!
      var targetUoM = sameBaseUnit
          .firstWhere((e) => e.conversionFactor < uom.conversionFactor);

      // directly return if there's no next lower dimension
      if (targetUoM == null) {
        return this;
      }

      // then convert to base unit
      var targetAmount = _amount * uom._conversionFactor;

      // then convert to fetched next base unit
      var result = targetAmount / targetUoM.conversionFactor;

      return AmountedUnitOfMeasure(targetUoM, result);
    }
    return this;
  }

  AmountedUnitOfMeasure add(AmountedUnitOfMeasure sourceAmountedUoM) {
    MetricUnitOfMeasure uom = this.uom;
    MetricUnitOfMeasure uomSource = sourceAmountedUoM.uom;

    assert(uom.baseUnit == uomSource.baseUnit);

    var target = this;
    var amounted = sourceAmountedUoM;
    if (uom.id != uomSource.id) {
      // convert to biggest uom
      while (uom.conversionFactor != 1) {
        target = target.nextBiggerUoM();
        uom = target.uom;
      }

      // convert also to biggest uom
      if (uom.conversionFactor == 1) {
        var metricUoM = amounted.uom as MetricUnitOfMeasure;
        while (metricUoM.conversionFactor != 1) {
          amounted = sourceAmountedUoM.nextBiggerUoM();
        }
      }

      return AmountedUnitOfMeasure(target.uom, target.amount + amounted.amount);
    }

    return AmountedUnitOfMeasure(uom, this.amount + sourceAmountedUoM.amount);
  }
}

class StaticUnitOfMeasure implements UnitOfMeasureProvider {
  @override
  UnitOfMeasure getUnitOfMeasureById(final String id) {
    if (id == null) {
      return null; // call with null may occur from the UI if used inside a DropDown
    }
    var targetId = id.toUpperCase();
    var metric =
        metricUoM.firstWhere((e) => targetId == e._id, orElse: () => null);
    if (metric != null) {
      return metric;
    }
    var nonMetric =
        nonMetricUoM.firstWhere((e) => targetId == e._id, orElse: () => null);
    return nonMetric;
  }

  @override
  List<UnitOfMeasure> getAll() {
    List<UnitOfMeasure> uoms = [];
    metricUoM.forEach((i) => uoms.add(i));
    uoms.addAll(nonMetricUoM.toList());
    return uoms;
  }

  @override
  List<UnitOfMeasure> getVisible() {
    var result = this.getAll();
    var prefs = sl.get<SharedPreferencesProvider>();

    return result
        .where((element) => prefs.isUnitOfMeasureVisible(element.id))
        .toList();
  }
}

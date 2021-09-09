import 'package:cookza/services/flutter/navigator_service.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/services/shared_preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:collection/collection.dart';

final uomDisplayTexts = {
  'MMT': (BuildContext context, int count) =>
      AppLocalizations.of(context).uomMMT(count),
  'CMT': (BuildContext context, int count) =>
      AppLocalizations.of(context).uomCMT(count),
  'MTR': (BuildContext context, int count) =>
      AppLocalizations.of(context).uomMTR(count),
  'GRM': (BuildContext context, int count) =>
      AppLocalizations.of(context).uomGRM(count),
  'KGM': (BuildContext context, int count) =>
      AppLocalizations.of(context).uomKGM(count),
  'MLT': (BuildContext context, int count) =>
      AppLocalizations.of(context).uomMLT(count),
  'CLT': (BuildContext context, int count) =>
      AppLocalizations.of(context).uomCLT(count),
  'DLT': (BuildContext context, int count) =>
      AppLocalizations.of(context).uomDLT(count),
  'LTR': (BuildContext context, int count) =>
      AppLocalizations.of(context).uomLTR(count),
  'H87': (BuildContext context, int count) =>
      AppLocalizations.of(context).uomH87(count),
  'G21': (BuildContext context, int count) =>
      AppLocalizations.of(context).uomG21(count),
  'G24': (BuildContext context, int count) =>
      AppLocalizations.of(context).uomG24(count),
  'G25': (BuildContext context, int count) =>
      AppLocalizations.of(context).uomG25(count),
  'BG': (BuildContext context, int count) =>
      AppLocalizations.of(context).uomBG(count),
  'LEF': (BuildContext context, int count) =>
      AppLocalizations.of(context).uomLEF(count),
  'X2': (BuildContext context, int count) =>
      AppLocalizations.of(context).uomX2(count),
  'X4': (BuildContext context, int count) =>
      AppLocalizations.of(context).uomX4(count),
  'CA': (BuildContext context, int count) =>
      AppLocalizations.of(context).uomCA(count),
  'BO': (BuildContext context, int count) =>
      AppLocalizations.of(context).uomBO(count),
  'STC': (BuildContext context, int count) =>
      AppLocalizations.of(context).uomSTC(count),
  'PR': (BuildContext context, int count) =>
      AppLocalizations.of(context).uomPR(count),
  'PA': (BuildContext context, int count) =>
      AppLocalizations.of(context).uomPA(count),
  'PTN': (BuildContext context, int count) =>
      AppLocalizations.of(context).uomPTN(count),
  'BR': (BuildContext context, int count) =>
      AppLocalizations.of(context).uomBR(count),
  'RO': (BuildContext context, int count) =>
      AppLocalizations.of(context).uomRO(count),
  '14': (BuildContext context, int count) =>
      AppLocalizations.of(context).uom14(count),
  'SR': (BuildContext context, int count) =>
      AppLocalizations.of(context).uomSR(count),
  'TU': (BuildContext context, int count) =>
      AppLocalizations.of(context).uomTU(count),
  'SLI': (BuildContext context, int count) =>
      AppLocalizations.of(context).uomSLI(count),
  'GLA': (BuildContext context, int count) =>
      AppLocalizations.of(context).uomGLA(count),
  'HAN': (BuildContext context, int count) =>
      AppLocalizations.of(context).uomHAN(count),
  'PIN': (BuildContext context, int count) =>
      AppLocalizations.of(context).uomPIN(count),
  'BOW': (BuildContext context, int count) =>
      AppLocalizations.of(context).uomBOW(count),
  'STE': (BuildContext context, int count) =>
      AppLocalizations.of(context).uomSTE(count),
  'CUB': (BuildContext context, int count) =>
      AppLocalizations.of(context).uomCUB(count),
  'CLO': (BuildContext context, int count) =>
      AppLocalizations.of(context).uomCLO(count),
  'ROT': (BuildContext context, int count) =>
      AppLocalizations.of(context).uomROT(count),
  'TWG': (BuildContext context, int count) =>
      AppLocalizations.of(context).uomTWG(count),
};

/// metric unit of measures supporting conversion
var metricUoM = <MetricUnitOfMeasure>{
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
};

/// non metric unit of measures
Set<String> nonMetricUoMIds = <String>{
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
};

Set<UnitOfMeasure> nonMetricUoM =
    nonMetricUoMIds.map((e) => UnitOfMeasure(e)).toSet();

abstract class UnitOfMeasureProvider {
  List<UnitOfMeasure> getAll();
  List<UnitOfMeasure> getVisible();
  UnitOfMeasure getUnitOfMeasureById(final String id);
}

class UnitOfMeasure {
  final String _id;

  UnitOfMeasure(this._id);

  /// returns the display name
  String get displayName {
    var context = sl.get<NavigatorService>().currentContext;
    if (context != null) {
      return uomDisplayTexts[this._id]!.call(context, 1);
    }
    // fallback only used in tests
    return _id;
  }

  /// returns the display name depending on the count of items referenced
  String getDisplayName(int amount) {
    var context = sl.get<NavigatorService>().currentContext;
    final consumer = uomDisplayTexts[this._id];
    if (context != null) {
      return consumer!.call(context, amount);
    }
    return _id;
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
  final String _baseUnit;
  final double _conversionFactor;

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
  final UnitOfMeasure _uom;
  final double _amount;

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
          .firstWhereOrNull((e) => e.conversionFactor < uom.conversionFactor);

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
    MetricUnitOfMeasure uom = this.uom as MetricUnitOfMeasure;
    MetricUnitOfMeasure uomSource =
        sourceAmountedUoM.uom as MetricUnitOfMeasure;

    assert(uom.baseUnit == uomSource.baseUnit);

    var target = this;
    var amounted = sourceAmountedUoM;
    if (uom.id != uomSource.id) {
      // convert to biggest uom
      while (uom.conversionFactor != 1) {
        target = target.nextBiggerUoM();
        uom = target.uom as MetricUnitOfMeasure;
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
    // if (id == null) {
    //   return null; // call with null may occur from the UI if used inside a DropDown
    // }
    var targetId = id.toUpperCase();
    var metric = metricUoM.firstWhereOrNull((e) => targetId == e._id);
    if (metric != null) {
      return metric;
    }
    var nonMetric = nonMetricUoM.firstWhereOrNull((e) => targetId == e._id);
    if (nonMetric != null) {
      return nonMetric;
    }
    throw 'UoM with id $id does not exist';
  }

  @override
  List<UnitOfMeasure> getAll() {
    List<UnitOfMeasure> uoms = [];
    for (var i in metricUoM) {
      uoms.add(i);
    }
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

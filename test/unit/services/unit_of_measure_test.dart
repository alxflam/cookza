import 'package:cookza/services/flutter/navigator_service.dart';
import 'package:cookza/services/shared_preferences_provider.dart';
import 'package:cookza/services/unit_of_measure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
    GetIt.I.registerSingletonAsync<SharedPreferencesProvider>(
        () async => SharedPreferencesProviderImpl().init());
  });

  test(
    'Convert Volume next Bigger',
    () {
      var provider = StaticUnitOfMeasure();

      var mlt = provider.getUnitOfMeasureById('MLT');
      var mlt_10 = AmountedUnitOfMeasure(mlt, 10);
      var clt_01 = mlt_10.nextBiggerUoM();

      expect(clt_01.amount, 1);
      expect(clt_01.uom.id, 'CLT');
    },
  );

  test(
    'Convert Length next Bigger',
    () {
      var provider = StaticUnitOfMeasure();

      var mmt = provider.getUnitOfMeasureById('MMT');
      var mmt_10 = AmountedUnitOfMeasure(mmt, 10);
      var cmt_01 = mmt_10.nextBiggerUoM();

      expect(cmt_01.amount, 1);
      expect(cmt_01.uom.id, 'CMT');
    },
  );

  test(
    'Convert Volume next Lower',
    () {
      var provider = StaticUnitOfMeasure();

      var ltr = provider.getUnitOfMeasureById('LTR');
      var ltr_10 = AmountedUnitOfMeasure(ltr, 50);
      var dlt_01 = ltr_10.nextLowerUoM();

      expect(dlt_01.amount, 500);
      expect(dlt_01.uom.id, 'DLT');
    },
  );

  test(
    'Convert Length next Lower',
    () {
      var provider = StaticUnitOfMeasure();

      var mtr = provider.getUnitOfMeasureById('MTR');
      var mtr_10 = AmountedUnitOfMeasure(mtr, 1);
      var cmt_01 = mtr_10.nextLowerUoM();

      expect(cmt_01.amount, 100);
      expect(cmt_01.uom.id, 'CMT');
    },
  );

  test(
    'Convert Weight next Bigger',
    () {
      var provider = StaticUnitOfMeasure();

      var grm = provider.getUnitOfMeasureById('GRM');
      var grm_750 = AmountedUnitOfMeasure(grm, 750);
      var kgm = grm_750.nextBiggerUoM();

      expect(kgm.amount, 0.750);
      expect(kgm.uom.id, 'KGM');
    },
  );

  test(
    'Convert Weight next Lower',
    () {
      var provider = StaticUnitOfMeasure();

      var kgm = provider.getUnitOfMeasureById('KGM');
      var kgm_2_75 = AmountedUnitOfMeasure(kgm, 2.75);
      var grm = kgm_2_75.nextLowerUoM();

      expect(grm.amount, 2750);
      expect(grm.uom.id, 'GRM');
    },
  );

  test(
    'Get visible UoMs',
    () {
      var provider = StaticUnitOfMeasure();

      var visible = provider.getVisible();
      var all = provider.getAll();

      expect(visible, all);
    },
  );

  test(
    'Check KGM can be converted to GRM',
    () {
      var provider = StaticUnitOfMeasure();
      final kgm = provider.getUnitOfMeasureById('KGM');
      final grm = provider.getUnitOfMeasureById('GRM');
      final convertable = kgm.canBeConvertedTo(grm);

      expect(convertable, true);
    },
  );

  test(
    'Check KGM can not be converted to LTR',
    () {
      var provider = StaticUnitOfMeasure();
      final kgm = provider.getUnitOfMeasureById('KGM');
      final ltr = provider.getUnitOfMeasureById('LTR');
      final convertable = kgm.canBeConvertedTo(ltr);

      expect(convertable, false);
    },
  );

  test(
    'Check non metric UoM can be converted to itself',
    () {
      var provider = StaticUnitOfMeasure();
      final first = provider.getUnitOfMeasureById('H87');
      final second = provider.getUnitOfMeasureById('H87');
      final convertable = first.canBeConvertedTo(second);

      expect(convertable, true);
    },
  );

  test(
    'Check non metric UoM can not be converted to other UoM',
    () {
      var provider = StaticUnitOfMeasure();
      final first = provider.getUnitOfMeasureById('H87');
      final second = provider.getUnitOfMeasureById('HAN');
      final convertable = first.canBeConvertedTo(second);

      expect(convertable, false);
    },
  );
}

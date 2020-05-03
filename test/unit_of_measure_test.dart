import 'package:cookly/services/unit_of_measure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

void main() {
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
}

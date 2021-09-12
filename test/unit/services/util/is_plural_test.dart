import 'package:cookza/services/util/is_plural.dart';
import 'package:flutter_test/flutter_test.dart';

const plurals = {
  'Zitronen': 'Zitrone',
  'Äpfel': 'Apfel',
  'Töpfe': 'Topf',
  'Tassen': 'Tasse',
  'Häuser': 'Haus',
  'Zwiebeln': 'Zwiebel',
  'Maden': 'Made',
};

const nonPlurals = {
  'Eis': 'Ei',
  'Eimer': 'Eier',
};

void main() {
  test(
    'Plural test',
    () async {
      for (var plural in plurals.entries) {
        expect(isPlural(plural.key, plural.value), true, reason: plural.key);
        expect(isPlural(plural.value, plural.key), true);
      }
    },
  );

  test(
    'Non-plural test',
    () async {
      for (var plural in nonPlurals.entries) {
        expect(isPlural(plural.key, plural.value), false);
        expect(isPlural(plural.value, plural.key), false);
      }
    },
  );
}

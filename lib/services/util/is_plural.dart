import 'dart:collection';

/// german umlauts
const germanDiacritics = 'ÄÖÜäöü';

/// replacement characters for german umlauts
const germanNonDiacritics = 'AOUaou';

/// suffixes used for plural nouns
final knownPluralSuffixes = HashSet.of([
  // german
  'n', 'en', 'e', 'r', 'er',
  // both
  's',
  // english
  'x', 'z', 'sh', 'ch', 'es'
]);

/// checks whether two strings are potentially singular and plural of the same noun
bool isPlural(final String first, final String second) {
  final firstWithoutDiacritics = removeDiacritics(first);
  final secondWithoutDiacritics = removeDiacritics(second);

  if (firstWithoutDiacritics == secondWithoutDiacritics) {
    return true;
  }

  int lengthFirst = firstWithoutDiacritics.length;
  int lengthSecond = secondWithoutDiacritics.length;

  if (lengthFirst > lengthSecond) {
    return isSamePrefixAndSuffix(
        firstWithoutDiacritics, secondWithoutDiacritics);
  } else if (lengthSecond > lengthFirst) {
    return isSamePrefixAndSuffix(
        secondWithoutDiacritics, firstWithoutDiacritics);
  } else {
    return false;
  }
}

bool isSamePrefixAndSuffix(String long, String prefix) {
  if (long.length <= 3) {
    return false;
  }

  bool sameStart = long.startsWith(prefix);
  if (sameStart) {
    String suffix = long.substring(prefix.length);
    return knownPluralSuffixes.contains(suffix);
  }
  return false;
}

String removeDiacritics(String value) => value.splitMapJoin('',
    onNonMatch: (char) => germanDiacritics.contains(char)
        ? germanNonDiacritics[germanDiacritics.indexOf(char)]
        : char);

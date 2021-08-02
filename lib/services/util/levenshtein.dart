import 'dart:math';

// see http://rosettacode.org/wiki/Levenshtein_distance#Java & https://en.wikipedia.org/wiki/Levenshtein_distance#Iterative_with_two_matrix_rows
int levenshtein(final String s1, final String s2) {
  final a = s1.toLowerCase();
  final b = s2.toLowerCase();

  if (a == b) {
    return 0;
  }
  if (a.isEmpty) {
    return b.length;
  }
  if (b.isEmpty) {
    return a.length;
  }

  List<int> v0 = List<int>.filled(b.length + 1, 0);
  List<int> v1 = List<int>.filled(b.length + 1, 0);

  for (int i = 0; i < b.length + 1; i < i++) {
    v0[i] = i;
  }

  for (int i = 0; i < a.length; i++) {
    v1[0] = i + 1;

    for (int j = 0; j < b.length; j++) {
      int cost = (a[i] == b[j]) ? 0 : 1;
      v1[j + 1] = min(v1[j] + 1, min(v0[j + 1] + 1, v0[j] + cost));
    }

    for (int j = 0; j < b.length + 1; j++) {
      v0[j] = v1[j];
    }
  }

  return v1[b.length];
}

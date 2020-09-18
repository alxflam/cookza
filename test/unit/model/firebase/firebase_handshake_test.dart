import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookly/model/firebase/general/firebase_handshake.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'Parse Handshake from JSON',
    () async {
      var now = Timestamp.now();
      var json = {
        'requestor': '1234',
        'owner': '4567',
        'creationTimestamp': now,
        'operatingSystem': 'Linux',
        'browser': 'Mozilla',
      } as Map<String, dynamic>;

      var cut = FirebaseHandshake.fromJson(json, '1234');

      expect(cut.documentID, '1234');
      expect(cut.requestor, '1234');
      expect(cut.owner, '4567');
      expect(cut.operatingSystem, 'Linux');
      expect(cut.browser, 'Mozilla');
    },
  );

  test(
    'Handshake to JSON',
    () async {
      var now = Timestamp.now();
      var json = {
        'requestor': '1234',
        'owner': '4567',
        'creationTimestamp': now,
        'operatingSystem': 'Linux',
        'browser': 'Mozilla',
      } as Map<String, dynamic>;

      var cut = FirebaseHandshake.fromJson(json, '1234');
      var actual = cut.toJson();
      expect(json, actual);
    },
  );
}

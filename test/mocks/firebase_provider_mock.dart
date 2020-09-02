import 'package:cookly/model/firebase/general/firebase_handshake.dart';
import 'package:cookly/services/firebase_provider.dart';
import 'package:mockito/mockito.dart';

class FirebaseProviderMock extends Mock implements FirebaseProvider {
  @override
  Stream<List<FirebaseHandshake>> webAppSessions() {
    return Stream.fromFuture(Future.value([]));
  }
}

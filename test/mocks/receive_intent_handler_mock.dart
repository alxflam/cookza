import 'package:cookza/services/abstract/receive_intent_handler.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mockito/mockito.dart';

class ReceiveIntentHandlerMock extends Mock implements ReceiveIntentHandler {
  @override
  void handleSharedJson(BuildContext context) {
    // not needed
  }

  @override
  void handleSharedText(BuildContext context) {
    // not needed
  }
}

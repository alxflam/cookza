import 'package:flutter/material.dart';

abstract class ReceiveIntentHandler {
  void handleSharedText(BuildContext context);
  void handleSharedJson(BuildContext context);
}

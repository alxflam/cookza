import 'package:cookza/services/abstract/receive_intent_handler.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/services/share_receive_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReceiveIntentHandlerImpl implements ReceiveIntentHandler {
  static const platform = MethodChannel('app.channel.shared.data');

  final handler = sl.get<ShareReceiveHandler>();

  /// read shared text
  Future<String> _getSharedText() async =>
      await platform.invokeMethod('getSharedText');

  /// read shared json
  Future<String> _getSharedJson() async =>
      await platform.invokeMethod('getSharedJson');

  @override
  void handleSharedJson(BuildContext context) async {
    var jsonData = await _getSharedJson();
    handler.handleReceivedJson(jsonData, context);
  }

  @override
  void handleSharedText(BuildContext context) async {
    var data = await _getSharedText();
    handler.handleReceivedText(data, context);
  }
}

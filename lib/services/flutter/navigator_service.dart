import 'package:flutter/material.dart';

class NavigatorService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Future<dynamic> navigateToNewInitialRoute(String routeName) {
  //   return navigatorKey.currentState!
  //       .pushNamedAndRemoveUntil(routeName, (route) => false);
  // }

  BuildContext? get currentContext => navigatorKey.currentContext;
}

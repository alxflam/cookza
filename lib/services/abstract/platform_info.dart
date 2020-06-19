import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Map<String, IconData> osIcons = {
  'windows': FontAwesomeIcons.windows,
  'mac': FontAwesomeIcons.apple,
  'linux': FontAwesomeIcons.linux,
  'android': FontAwesomeIcons.android,
  'ios': FontAwesomeIcons.apple
};

abstract class PlatformInfo {
  String get browser;
  String get os;
  bool get isBrowser;
  bool get isMobileApp;
  bool get isDesktopApp;

  IconData getOSIcon(String osName);
}

class BasePlatformInfo implements PlatformInfo {
  @override
  String get browser => throw UnimplementedError();

  @override
  bool get isBrowser => kIsWeb;

  @override
  bool get isDesktopApp => false;

  @override
  bool get isMobileApp => !kIsWeb;

  @override
  String get os => Platform.operatingSystem;

  @override
  IconData getOSIcon(String osName) {
    if (osIcons.containsKey(osName.toLowerCase())) {
      return osIcons[osName.toLowerCase()];
    }
    return Icons.device_unknown;
  }
}

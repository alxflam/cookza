import 'dart:html' as html;

import 'package:cookza/services/abstract/platform_info.dart';

class PlatformInfoImpl extends BasePlatformInfo {
  @override
  String get browser {
    var vendor = html.window.navigator.vendor.toLowerCase();
    if (vendor.contains('google') || vendor.contains('chrome')) {
      return 'Chrome';
    }
    if (vendor.contains('mozilla') || vendor.contains('firefox')) {
      return 'Firefox';
    }
    if (vendor.contains('microsoft')) {
      return 'Internet Explorer';
    }
    if (vendor.contains('edge')) {
      return 'Edge';
    }
    if (vendor.contains('apple')) {
      return 'Safari';
    }
    return html.window.navigator.vendor;
  }

  @override
  String get os {
    var platform = html.window.navigator.platform?.toLowerCase() ?? '';
    var appVersion = html.window.navigator.appVersion.toLowerCase();

    if (platform.contains('win')) {
      return 'Windows';
    }
    if (platform.contains('X11') || platform.contains('unix')) {
      return 'Unix';
    }
    if (platform.contains('linux') || appVersion.contains('linux')) {
      return 'Linux';
    }
    if (platform.contains('mac') || appVersion.contains('mac')) {
      return 'Mac';
    }

    return html.window.navigator.platform ?? 'unknown';
  }
}

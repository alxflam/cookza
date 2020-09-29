import 'dart:io';

import 'package:cookza/services/abstract/platform_info.dart';

class PlatformInfoImpl extends BasePlatformInfo {
  @override
  String get browser {
    return '';
  }

  @override
  String get os {
    return Platform.operatingSystem;
  }
}

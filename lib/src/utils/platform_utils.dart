import 'package:flutter/foundation.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:universal_platform/universal_platform.dart';

sealed class PlatformUtils {
  ///获取当前默认的平台 id
  static IMPlatform get currentPlatform {
    if (kIsWeb) {
      return IMPlatform.web;
    } else if (UniversalPlatform.isAndroid) {
      return IMPlatform.android;
    } else if (UniversalPlatform.isIOS) {
      return IMPlatform.ios;
    } else if (UniversalPlatform.isWindows) {
      return IMPlatform.windows;
    } else if (UniversalPlatform.isMacOS) {
      return IMPlatform.xos;
    } else if (UniversalPlatform.isLinux) {
      return IMPlatform.linux;
    } else {
      return IMPlatform.miniWeb;
    }
  }

  static int get platformID => currentPlatform.value;
}

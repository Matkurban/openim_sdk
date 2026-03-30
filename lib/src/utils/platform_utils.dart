import 'package:flutter/foundation.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:universal_platform/universal_platform.dart';

sealed class PlatformUtils {
  // 平台在运行时不会改变，缓存一次避免每次重复检测
  static final IMPlatform currentPlatform = _detectPlatform();

  static IMPlatform _detectPlatform() {
    if (kIsWeb) {
      if (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS) {
        return IMPlatform.miniWeb;
      }
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
      return IMPlatform.androidPad;
    }
  }

  static int get platformID => currentPlatform.value;
}

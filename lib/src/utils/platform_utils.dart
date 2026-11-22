import 'package:flutter/foundation.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:universal_platform/universal_platform.dart';

/// 运行平台检测工具类，提供当前宿主的 OpenIM 平台枚举与整数 ID。
///
/// Runtime platform detection utility providing the current OpenIM platform enum and numeric ID.
sealed class PlatformUtils {
  /// 当前运行平台枚举缓存（运行时不变）。
  ///
  /// Cached [IMPlatform] detected once for the current runtime environment.
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

  /// 当前运行平台对应的 OpenIM 整数平台 ID。
  ///
  /// Numeric OpenIM platform ID corresponding to [currentPlatform].
  ///
  /// - Returns: 平台整数 ID / Numeric platform ID.
  static int get platformID => currentPlatform.value;
}

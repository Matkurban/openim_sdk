import 'dart:developer' as developer;

import 'package:meta/meta.dart';

import 'im_log_level.dart';

/// 全局日志管理器（单例）
@internal
class ImLogConfig {
  ImLogConfig._internal();

  static final ImLogConfig _instance = ImLogConfig._internal();

  factory ImLogConfig() => _instance;

  // 当前全局日志级别
  ImLogLevel currentLevel = ImLogLevel.all;

  /// 一次性设置级别
  void setLevel(ImLogLevel level) {
    currentLevel = level;
    developer.log('全局日志级别已更新为: $level', name: 'openim_sdk | LogConfig');
  }

  bool get enableLog => currentLevel != ImLogLevel.off;
}

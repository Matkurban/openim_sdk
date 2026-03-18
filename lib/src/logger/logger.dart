import 'dart:developer' as developer;

import 'package:meta/meta.dart';
import 'package:openim_sdk/src/logger/im_log_config.dart';
import 'package:openim_sdk/src/logger/im_log_level.dart';

@internal
class Logger {
  final String className;

  Logger(this.className);

  final ImLogConfig _logConfig = ImLogConfig();

  // 定义颜色常量
  static const String _resetColor = '\x1B[0m';
  // 蓝色
  static const String _infoColor = '\x1B[34m';
  // 黄色
  static const String _warningColor = '\x1B[33m';
  // 红色
  static const String _errorColor = '\x1B[31m';

  // 根据日志级别获取对应的颜色码
  String _getColorCode(ImLogLevel level) {
    if (level == ImLogLevel.info) return _infoColor;
    if (level == ImLogLevel.warning) return _warningColor;
    if (level == ImLogLevel.error) return _errorColor;
    return _resetColor;
  }

  void _log({
    required ImLogLevel level,
    required String message,
    required String methodName,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (_logConfig.enableLog && level >= _logConfig.currentLevel) {
      final String colorPrefix = _getColorCode(level);
      final String coloredMessage = '$colorPrefix$message$_resetColor';
      developer.log(
        coloredMessage,
        time: DateTime.now(),
        sequenceNumber: level.value,
        name: '$colorPrefix openim_sdk | ${level.name} | $className.$methodName $_resetColor',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  void info(String message, {String methodName = '', Object? error, StackTrace? stackTrace}) {
    _log(
      level: ImLogLevel.info,
      message: message,
      methodName: methodName,
      error: error,
      stackTrace: stackTrace,
    );
  }

  void warning(String message, {String methodName = '', Object? error, StackTrace? stackTrace}) {
    _log(
      level: ImLogLevel.warning,
      message: message,
      methodName: methodName,
      error: error,
      stackTrace: stackTrace,
    );
  }

  void error(String message, {String methodName = '', Object? error, StackTrace? stackTrace}) {
    _log(
      level: ImLogLevel.error,
      message: message,
      methodName: methodName,
      error: error,
      stackTrace: stackTrace,
    );
  }
}

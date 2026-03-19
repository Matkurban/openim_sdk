import 'dart:developer' as developer;

import 'package:meta/meta.dart';
import 'package:openim_sdk/src/logger/im_log_config.dart';
import 'package:openim_sdk/src/logger/im_log_level.dart';

@internal
class Logger {
  final String className;

  Logger(this.className);

  final ImLogConfig _logConfig = ImLogConfig();

  void _log({
    required ImLogLevel level,
    required String message,
    required String methodName,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (_logConfig.enableLog && level >= _logConfig.currentLevel) {
      developer.log(
        message,
        time: DateTime.now(),
        sequenceNumber: level.value,
        name: ' openim_sdk | ${level.name} | $className.$methodName ',
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

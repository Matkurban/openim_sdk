import '../enums/sdk_error_code.dart';

/// OpenIM SDK 异常
///
/// 当 SDK 操作失败时抛出此异常，携带服务端返回的错误码和错误信息。
/// 前端可以通过 [code] 判断具体错误类型，参考 [SDKErrorCode] 枚举。
class OpenIMException implements Exception {
  /// 服务端返回的错误码
  ///
  /// Code.
  final int code;

  /// 服务端返回的错误信息
  ///
  /// Message.
  final String message;

  /// 创建 `OpenIMException` 实例。
  ///
  /// Creates a `OpenIMException` instance.
  ///
  /// - [code] 代码 / Code.
  /// - [message] 消息 / Message.
  const OpenIMException({required this.code, required this.message});

  /// 匹配的 [SDKErrorCode] 枚举值，未匹配时返回 null
  SDKErrorCode? get sdkErrorCode {
    for (final SDKErrorCode e in SDKErrorCode.values) {
      if (e.code == code) return e;
    }
    return null;
  }

  /// 返回对象的可读字符串表示。
  ///
  /// Returns a human-readable string representation.
  ///
  /// - Returns: 字符串结果 / String result.
  @override
  String toString() => 'OpenIMException(code: $code, message: $message)';
}

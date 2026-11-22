/// API响应。
///
/// API response.
class ApiResponse {
  /// 错误代码。
  ///
  /// Error code.
  final int errCode;

  /// 错误消息。
  ///
  /// Error message.
  final String errMsg;

  /// 错误Dlt。
  ///
  /// Error dlt.
  final String errDlt;

  /// 数据。
  ///
  /// Data.
  final dynamic data;

  /// 创建 `ApiResponse` 实例。
  ///
  /// Creates a `ApiResponse` instance.
  ///
  /// - [errCode] 错误代码 / Error code.
  /// - [errMsg] 错误消息 / Error message.
  /// - [errDlt] 错误Dlt / Error dlt.
  /// - [data] 数据 / Data.
  ApiResponse({
    required this.errCode,
    required this.errMsg,
    required this.errDlt,
    required this.data,
  });

  /// 从 JSON 字典反序列化实例（`ApiResponse.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`ApiResponse.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `ApiResponse` 结果 / Resulting `ApiResponse`.
  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      errCode: (json['errCode'] as int?) ?? 0,
      errMsg: (json['errMsg'] as String?) ?? '',
      errDlt: (json['errDlt'] as String?) ?? '',
      data: json['data'],
    );
  }

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{'errCode': errCode, 'errMsg': errMsg, 'errDlt': errDlt, 'data': data};
  }

  /// 是否Success。
  ///
  /// Whether success.
  bool get isSuccess => errCode == 0;
}

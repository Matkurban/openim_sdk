/// 举报对象类型
///
/// Report target type.
class ReportTargetType {
  /// 用户。
  ///
  /// User.
  static const String user = 'user';

  /// 群组。
  ///
  /// Group.
  static const String group = 'group';

  /// 消息。
  ///
  /// Message.
  static const String message = 'message';
}

/// 举报分类
///
/// Report category.
class ReportCategory {
  /// harass。
  ///
  /// Harass.
  static const String harass = 'harass';

  /// scam。
  ///
  /// Scam.
  static const String scam = 'scam';

  /// porn。
  ///
  /// Porn.
  static const String porn = 'porn';

  /// ad。
  ///
  /// Ad.
  static const String ad = 'ad';

  /// other。
  ///
  /// Other.
  static const String other = 'other';
}

/// 创建举报响应
///
/// Create report response.
class CreateReportResp {
  /// 举报ID。
  ///
  /// Report ID.
  final String reportID;

  /// 创建 `CreateReportResp` 实例。
  ///
  /// Creates a `CreateReportResp` instance.
  ///
  /// - [reportID] 举报ID / Report ID.
  CreateReportResp({required this.reportID});

  /// 从 JSON 字典反序列化实例（`CreateReportResp.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`CreateReportResp.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `CreateReportResp` 结果 / Resulting `CreateReportResp`.
  factory CreateReportResp.fromJson(Map<String, dynamic> json) =>
      CreateReportResp(reportID: (json['reportID'] ?? '') as String);
}

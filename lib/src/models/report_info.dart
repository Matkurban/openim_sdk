/// 举报对象类型
class ReportTargetType {
  static const String user = 'user';
  static const String group = 'group';
  static const String message = 'message';
}

/// 举报分类
class ReportCategory {
  static const String harass = 'harass';
  static const String scam = 'scam';
  static const String porn = 'porn';
  static const String ad = 'ad';
  static const String other = 'other';
}

/// 创建举报响应
class CreateReportResp {
  final String reportID;
  CreateReportResp({required this.reportID});
  factory CreateReportResp.fromJson(Map<String, dynamic> json) =>
      CreateReportResp(reportID: (json['reportID'] ?? '') as String);
}

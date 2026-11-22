import 'dart:typed_data';

import '../core/base_manager.dart';
import '../core/sdk_context.dart';
import '../models/api_response.dart';
import '../models/appeal_info.dart';
import '../models/report_info.dart';

/// 治理 Manager：举报 + 申诉（继承 [BaseManager]）。
final class ReportAppealManager extends BaseManager<void> {
  final SdkContext _context;

  /// 创建 `ReportAppealManager` 实例。
  ///
  /// Creates a `ReportAppealManager` instance.
  ///
  /// - [_context] context / Context.
  ReportAppealManager({required this._context}) : super('ReportAppealManager');

  /// 举报用户。
  ///
  /// Report user.
  ///
  /// - [targetUserID] 目标用户ID / Target user ID.
  /// - [category] 分类 / Category.
  /// - [description] 描述 / Description.
  /// - [evidenceUrls] 举证材料URL 列表 / Evidence URLs.
  /// - Returns: `Future<CreateReportResp?>` 结果 / Resulting `Future<CreateReportResp?>`.
  Future<CreateReportResp?> reportUser({
    required String targetUserID,
    required String category,
    String? description,
    List<String>? evidenceUrls,
  }) {
    return _createReport(
      targetType: ReportTargetType.user,
      targetID: targetUserID,
      category: category,
      description: description,
      evidenceUrls: evidenceUrls,
    );
  }

  /// 举报群组。
  ///
  /// Report group.
  ///
  /// - [targetGroupID] 目标群组ID / Target group ID.
  /// - [category] 分类 / Category.
  /// - [description] 描述 / Description.
  /// - [evidenceUrls] 举证材料URL 列表 / Evidence URLs.
  /// - Returns: `Future<CreateReportResp?>` 结果 / Resulting `Future<CreateReportResp?>`.
  Future<CreateReportResp?> reportGroup({
    required String targetGroupID,
    required String category,
    String? description,
    List<String>? evidenceUrls,
  }) {
    return _createReport(
      targetType: ReportTargetType.group,
      targetID: targetGroupID,
      category: category,
      description: description,
      evidenceUrls: evidenceUrls,
    );
  }

  /// 举报消息。
  ///
  /// Report message.
  ///
  /// - [targetUserID] 目标用户ID / Target user ID.
  /// - [messageID] 消息ID / Message ID.
  /// - [category] 分类 / Category.
  /// - [description] 描述 / Description.
  /// - [evidenceUrls] 举证材料URL 列表 / Evidence URLs.
  /// - Returns: `Future<CreateReportResp?>` 结果 / Resulting `Future<CreateReportResp?>`.
  Future<CreateReportResp?> reportMessage({
    required String targetUserID,
    required String messageID,
    required String category,
    String? description,
    List<String>? evidenceUrls,
  }) {
    return _createReport(
      targetType: ReportTargetType.message,
      targetID: targetUserID,
      messageID: messageID,
      category: category,
      description: description,
      evidenceUrls: evidenceUrls,
    );
  }

  Future<CreateReportResp?> _createReport({
    required String targetType,
    required String targetID,
    String? messageID,
    required String category,
    String? description,
    List<String>? evidenceUrls,
  }) async {
    final ApiResponse resp = await _context.apis.governance.createReport(
      targetType: targetType,
      targetID: targetID,
      messageID: messageID,
      category: category,
      description: description,
      evidenceUrls: evidenceUrls,
    );
    if (resp.errCode != 0) {
      logger.warning('createReport failed code=${resp.errCode} msg=${resp.errMsg}');
      return null;
    }
    if (resp.data is Map<String, dynamic>) {
      return CreateReportResp.fromJson(resp.data as Map<String, dynamic>);
    }
    return null;
  }

  /// 获取申诉验证码。
  ///
  /// Get appeal verification code.
  ///
  /// - Returns: `Future<AppealCaptcha?>` 结果 / Resulting `Future<AppealCaptcha?>`.
  Future<AppealCaptcha?> getAppealCaptcha() async {
    final ApiResponse resp = await _context.apis.governance.requestAppealCaptcha();
    if (resp.errCode != 0) {
      logger.warning('captcha failed code=${resp.errCode} msg=${resp.errMsg}');
      return null;
    }
    if (resp.data is Map<String, dynamic>) {
      return AppealCaptcha.fromJson(resp.data as Map<String, dynamic>);
    }
    return null;
  }

  /// submit申诉。
  ///
  /// Submit appeal.
  ///
  /// - [account] 账号 / Account.
  /// - [reason] 原因 / Reason.
  /// - [description] 描述 / Description.
  /// - [contact] contact / Contact.
  /// - [captchaID] 验证码ID / Verification code ID.
  /// - [captchaAnswer] 验证码Answer / Verification code answer.
  /// - Returns: `Future<CreateAppealResp?>` 结果 / Resulting `Future<CreateAppealResp?>`.
  Future<CreateAppealResp?> submitAppeal({
    required String account,
    required String reason,
    String? description,
    String? contact,
    required String captchaID,
    required String captchaAnswer,
  }) async {
    final ApiResponse resp = await _context.apis.governance.createAppeal(
      account: account,
      reason: reason,
      description: description,
      contact: contact,
      captchaID: captchaID,
      captchaAnswer: captchaAnswer,
    );
    if (resp.errCode != 0) {
      logger.warning('submitAppeal failed code=${resp.errCode} msg=${resp.errMsg}');
      return null;
    }
    if (resp.data is Map<String, dynamic>) {
      return CreateAppealResp.fromJson(resp.data as Map<String, dynamic>);
    }
    return null;
  }

  /// 上传申诉举证材料。
  ///
  /// Upload appeal evidence.
  ///
  /// - [appealToken] 申诉令牌 / Appeal token.
  /// - [filePath] 文件路径 / File path.
  /// - [fileBytes] 文件字节数据 / File bytes.
  /// - [fileName] 文件名称 / File name.
  /// - Returns: `Future<AppealUploadResp?>` 结果 / Resulting `Future<AppealUploadResp?>`.
  Future<AppealUploadResp?> uploadAppealEvidence({
    required String appealToken,
    String? filePath,
    Uint8List? fileBytes,
    String? fileName,
  }) async {
    final ApiResponse resp = await _context.apis.governance.uploadAppealEvidence(
      appealToken: appealToken,
      filePath: filePath,
      fileBytes: fileBytes,
      fileName: fileName,
    );
    if (resp.errCode != 0) {
      logger.warning('uploadAppealEvidence failed code=${resp.errCode} msg=${resp.errMsg}');
      return null;
    }
    if (resp.data is Map<String, dynamic>) {
      return AppealUploadResp.fromJson(resp.data as Map<String, dynamic>);
    }
    return null;
  }
}

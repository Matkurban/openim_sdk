import 'dart:typed_data';

import '../core/base_manager.dart';
import '../core/sdk_context.dart';
import '../models/api_response.dart';
import '../models/appeal_info.dart';
import '../models/report_info.dart';

/// 治理 Manager：举报 + 申诉（继承 [BaseManager]）。
final class ReportAppealManager extends BaseManager<void> {
  final SdkContext _context;

  ReportAppealManager({required this._context}) : super('ReportAppealManager');

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

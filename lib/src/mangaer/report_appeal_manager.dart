import 'package:aoiwe_logger/aoiwe_logger.dart';
import 'package:openim_sdk/src/models/api_response.dart';
import 'package:openim_sdk/src/models/appeal_info.dart';
import 'package:openim_sdk/src/models/report_info.dart';
import 'package:openim_sdk/src/services/im_api_service.dart';

/// 治理 Manager：举报 + 申诉
class ReportAppealManager {
  ReportAppealManager._internal();

  static final ReportAppealManager _instance = ReportAppealManager._internal();

  factory ReportAppealManager() => _instance;

  static final AoiweLogger _log = AoiweLogger('ReportAppealManager');

  // ─── 举报（已登录用户） ─────────────────────────────────────────────

  /// 举报用户
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

  /// 举报群
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

  /// 举报消息
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
    final ApiResponse resp = await ImApiService().createReport(
      targetType: targetType,
      targetID: targetID,
      messageID: messageID,
      category: category,
      description: description,
      evidenceUrls: evidenceUrls,
    );
    if (resp.errCode != 0) {
      _log.warning(
        'createReport failed code=${resp.errCode} msg=${resp.errMsg}',
        methodName: '_createReport',
      );
      return null;
    }
    final data = resp.data;
    if (data is Map<String, dynamic>) {
      return CreateReportResp.fromJson(data);
    }
    return null;
  }

  // ─── 申诉（无需登录） ──────────────────────────────────────────────

  /// 获取申诉验证码
  Future<AppealCaptcha?> getAppealCaptcha() async {
    final resp = await ImApiService().requestAppealCaptcha();
    if (resp.errCode != 0) {
      _log.warning(
        'captcha failed code=${resp.errCode} msg=${resp.errMsg}',
        methodName: 'getAppealCaptcha',
      );
      return null;
    }
    final data = resp.data;
    if (data is Map<String, dynamic>) {
      return AppealCaptcha.fromJson(data);
    }
    return null;
  }

  /// 提交申诉。成功返回 [CreateAppealResp]，包含可用于上传证据的 appealToken。
  Future<CreateAppealResp?> submitAppeal({
    required String account,
    required String reason,
    String? description,
    String? contact,
    required String captchaID,
    required String captchaAnswer,
  }) async {
    final resp = await ImApiService().createAppeal(
      account: account,
      reason: reason,
      description: description,
      contact: contact,
      captchaID: captchaID,
      captchaAnswer: captchaAnswer,
    );
    if (resp.errCode != 0) {
      _log.warning(
        'submitAppeal failed code=${resp.errCode} msg=${resp.errMsg}',
        methodName: 'submitAppeal',
      );
      return null;
    }
    final data = resp.data;
    if (data is Map<String, dynamic>) {
      return CreateAppealResp.fromJson(data);
    }
    return null;
  }

  /// 上传申诉证据（图片，最大 5MB；jpg/jpeg/png/webp）
  Future<AppealUploadResp?> uploadAppealEvidence({
    required String appealToken,
    required String filePath,
    String? fileName,
  }) async {
    final resp = await ImApiService().uploadAppealEvidence(
      appealToken: appealToken,
      filePath: filePath,
      fileName: fileName,
    );
    if (resp.errCode != 0) {
      _log.warning(
        'uploadAppealEvidence failed code=${resp.errCode} msg=${resp.errMsg}',
        methodName: 'uploadAppealEvidence',
      );
      return null;
    }
    final data = resp.data;
    if (data is Map<String, dynamic>) {
      return AppealUploadResp.fromJson(data);
    }
    return null;
  }
}

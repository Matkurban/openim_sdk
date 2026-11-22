import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../config/api_url.dart';
import '../core/base_api_client.dart';
import '../models/api_response.dart';

/// 治理（举报/申诉）与应用版本检查 API 客户端。
final class GovernanceApi extends BaseApiClient {
  /// 创建 `GovernanceApi` 实例。
  ///
  /// Creates a `GovernanceApi` instance.
  ///
  /// - [httpClient] HTTP客户端 / HTTP client.
  GovernanceApi({required super.httpClient}) : super(name: 'GovernanceApi');

  /// 创建举报。
  ///
  /// Create report.
  ///
  /// - [targetType] 目标类型 / Target type.
  /// - [targetID] 目标ID / Target ID.
  /// - [messageID] 消息ID / Message ID.
  /// - [category] 分类 / Category.
  /// - [description] 描述 / Description.
  /// - [evidenceUrls] 举证材料URL 列表 / Evidence URLs.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> createReport({
    required String targetType,
    required String targetID,
    String? messageID,
    required String category,
    String? description,
    List<String>? evidenceUrls,
  }) {
    return postChat(
      ChatApiUrl.createReport,
      data: <String, dynamic>{
        'targetType': targetType,
        'targetID': targetID,
        'messageID': ?messageID,
        'category': category,
        'description': description ?? '',
        'evidenceUrls': evidenceUrls ?? <String>[],
      },
    );
  }

  /// 申请/请求申诉验证码。
  ///
  /// Request appeal verification code.
  ///
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> requestAppealCaptcha() => postAdmin(ChatApiUrl.appealCaptcha);

  /// 创建申诉。
  ///
  /// Create appeal.
  ///
  /// - [account] 账号 / Account.
  /// - [reason] 原因 / Reason.
  /// - [description] 描述 / Description.
  /// - [contact] contact / Contact.
  /// - [captchaID] 验证码ID / Verification code ID.
  /// - [captchaAnswer] 验证码Answer / Verification code answer.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> createAppeal({
    required String account,
    required String reason,
    String? description,
    String? contact,
    required String captchaID,
    required String captchaAnswer,
  }) {
    return postAdmin(
      ChatApiUrl.appealCreate,
      data: <String, dynamic>{
        'account': account,
        'reason': reason,
        'description': description ?? '',
        'contact': contact ?? '',
        'captchaID': captchaID,
        'captchaAnswer': captchaAnswer,
      },
    );
  }

  /// 上传申诉证据（支持文件路径与内存字节，兼容 Web 端，修复 B-23）。
  ///
  /// - [appealToken] 申诉令牌 / Appeal token.
  /// - [filePath] 文件路径 / File path.
  /// - [fileBytes] 文件字节数据 / File bytes.
  /// - [fileName] 文件名称 / File name.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> uploadAppealEvidence({
    required String appealToken,
    String? filePath,
    Uint8List? fileBytes,
    String? fileName,
  }) async {
    final MultipartFile file;
    if (fileBytes != null) {
      file = MultipartFile.fromBytes(fileBytes, filename: fileName ?? 'evidence.jpg');
    } else if (filePath != null && filePath.isNotEmpty) {
      file = await MultipartFile.fromFile(filePath, filename: fileName);
    } else {
      throw ArgumentError('filePath or fileBytes must be provided');
    }
    final FormData formData = FormData.fromMap(<String, dynamic>{'file': file});
    return httpClient.adminMultipartPost(
      ChatApiUrl.appealUpload,
      formData: formData,
      headers: <String, dynamic>{'Authorization': 'appeal $appealToken'},
    );
  }

  /// 获取最新申请版本。
  ///
  /// Get latest application version.
  ///
  /// - [platform] 平台 / Platform.
  /// - [version] 版本 / Version.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> getLatestApplicationVersion({required String platform, String? version}) {
    return postChat(
      ChatApiUrl.latestApplicationVersion,
      data: <String, dynamic>{'platform': platform, 'version': ?version},
    );
  }
}

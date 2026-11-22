import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../config/api_url.dart';
import '../core/base_api_client.dart';
import '../models/api_response.dart';

/// 治理（举报/申诉）与应用版本检查 API 客户端。
final class GovernanceApi extends BaseApiClient {
  GovernanceApi({required super.httpClient}) : super(name: 'GovernanceApi');

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

  Future<ApiResponse> requestAppealCaptcha() => postAdmin(ChatApiUrl.appealCaptcha);

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

  Future<ApiResponse> getLatestApplicationVersion({required String platform, String? version}) {
    return postChat(
      ChatApiUrl.latestApplicationVersion,
      data: <String, dynamic>{'platform': platform, 'version': ?version},
    );
  }
}

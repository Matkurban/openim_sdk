import '../config/api_url.dart';
import '../core/base_api_client.dart';
import '../models/api_response.dart';

/// 对象存储分片上传与推送 Token API 客户端。
final class ObjectStorageApi extends BaseApiClient {
  /// 创建 `ObjectStorageApi` 实例。
  ///
  /// Creates a `ObjectStorageApi` instance.
  ///
  /// - [httpClient] HTTP客户端 / HTTP client.
  ObjectStorageApi({required super.httpClient}) : super(name: 'ObjectStorageApi');

  /// 获取分片条数上限。
  ///
  /// Get part limit.
  ///
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> getPartLimit() => postIm(ImApiUrl.objectPartLimit);

  /// initiate分片表单上传。
  ///
  /// Initiate multipart form upload.
  ///
  /// - [hash] 哈希值 / Hash.
  /// - [size] 大小 / Size.
  /// - [partSize] 分片大小 / Part size.
  /// - [maxParts] 最大Parts / Maximum parts.
  /// - [cause] cause / Cause.
  /// - [name] 名称 / Name.
  /// - [contentType] 内容类型 / Content type.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> initiateMultipartUpload({
    required String hash,
    required int size,
    required int partSize,
    required int maxParts,
    required String cause,
    required String name,
    required String contentType,
  }) {
    return postIm(
      ImApiUrl.objectInitiateUpload,
      data: <String, dynamic>{
        'hash': hash,
        'size': size,
        'partSize': partSize,
        'maxParts': maxParts,
        'cause': cause,
        'name': name,
        'contentType': contentType,
      },
    );
  }

  /// 认证Sign。
  ///
  /// Authentication sign.
  ///
  /// - [uploadID] 上传ID / Upload ID.
  /// - [partNumbers] 分片Numbers / Part numbers.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> authSign({required String uploadID, required List<int> partNumbers}) {
    return postIm(
      ImApiUrl.objectAuthSign,
      data: <String, dynamic>{'uploadID': uploadID, 'partNumbers': partNumbers},
    );
  }

  /// complete分片表单上传。
  ///
  /// Complete multipart form upload.
  ///
  /// - [uploadID] 上传ID / Upload ID.
  /// - [parts] parts / Parts.
  /// - [name] 名称 / Name.
  /// - [contentType] 内容类型 / Content type.
  /// - [cause] cause / Cause.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> completeMultipartUpload({
    required String uploadID,
    required List<String> parts,
    required String name,
    required String contentType,
    required String cause,
  }) {
    return postIm(
      ImApiUrl.objectCompleteUpload,
      data: <String, dynamic>{
        'uploadID': uploadID,
        'parts': parts,
        'name': name,
        'contentType': contentType,
        'cause': cause,
      },
    );
  }

  /// 更新 FCM Token（修复 B-23：`platformID` 保持整型而非字符串）。
  ///
  /// - [platformID] 平台ID / Platform ID.
  /// - [fcmToken] FCM 推送令牌 / FCM push token.
  /// - [account] 账号 / Account.
  /// - [expireTime] expire时间戳 / Expire timestamp.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> fcmUpdateToken({
    required int platformID,
    required String fcmToken,
    required String account,
    int expireTime = 0,
  }) {
    return postIm(
      ImApiUrl.fcmUpdateToken,
      data: <String, dynamic>{
        'platformID': platformID,
        'fcmToken': fcmToken,
        'account': account,
        'expireTime': expireTime,
      },
    );
  }
}

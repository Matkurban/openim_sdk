import '../config/api_url.dart';
import '../core/base_api_client.dart';
import '../models/api_response.dart';

/// 对象存储分片上传与推送 Token API 客户端。
final class ObjectStorageApi extends BaseApiClient {
  ObjectStorageApi({required super.httpClient}) : super(name: 'ObjectStorageApi');

  Future<ApiResponse> getPartLimit() => postIm(ImApiUrl.objectPartLimit);

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

  Future<ApiResponse> authSign({required String uploadID, required List<int> partNumbers}) {
    return postIm(
      ImApiUrl.objectAuthSign,
      data: <String, dynamic>{'uploadID': uploadID, 'partNumbers': partNumbers},
    );
  }

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

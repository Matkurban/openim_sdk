import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../concurrency/sdk_compute_executor.dart';
import '../core/sdk_context.dart';
import '../enums/sdk_error_code.dart';
import '../listener/upload_file_listener.dart';
import '../models/api_response.dart';
import '../models/openim_exception.dart';
import '../utils/file_util.dart';

/// 分片文件上传服务（从原 1,718 行 `IMManager` 中解耦）。
///
/// 支持 Native 文件路径与 Web 字节数组双通道、秒传检测、断点续传、
/// 基于 [SdkComputeExecutor] 的后台分片 MD5 哈希及实时进度回调。
class FileUploader {
  final Logger _logger = Logger('openim_sdk.FileUploader');
  final SdkContext _context;

  Map<String, dynamic>? _partLimitCache;

  /// 上传文件监听器。
  ///
  /// Upload file listener.
  OnUploadFileListener? uploadFileListener;

  /// 创建 `FileUploader` 实例。
  ///
  /// Creates a `FileUploader` instance.
  ///
  /// - [_context] context / Context.
  FileUploader({required this._context});

  /// 重置缓存。
  ///
  /// Reset cache.
  void resetCache() {
    _partLimitCache = null;
  }

  /// 上传文件并返回访问 URL。
  ///
  /// - [id] ID / ID.
  /// - [userID] 用户ID / User ID.
  /// - [filePath] 文件路径 / File path.
  /// - [fileBytes] 文件字节数据 / File bytes.
  /// - [fileName] 文件名称 / File name.
  /// - [contentType] 内容类型 / Content type.
  /// - [cause] cause / Cause.
  /// - [onProgress] on进度 / On progress.
  /// - Returns: 字符串结果 / String result.
  Future<String> uploadFile({
    required String id,
    required String userID,
    String? filePath,
    Uint8List? fileBytes,
    required String fileName,
    String? contentType,
    String? cause,
    void Function(int sent, int total)? onProgress,
  }) async {
    assert(filePath != null || fileBytes != null, 'filePath 和 fileBytes 必须提供其中一个');
    _logger.fine('uploadFile id=$id fileName=$fileName hasBytes=${fileBytes != null}');

    final int fileSize;
    if (fileBytes != null) {
      fileSize = fileBytes.length;
    } else {
      if (!await fileExists(filePath!)) {
        throw OpenIMException(
          code: SDKErrorCode.uploadFileNotExist.code,
          message: SDKErrorCode.uploadFileNotExist.message,
        );
      }
      fileSize = await fileLength(filePath);
    }

    uploadFileListener?.open(id, fileSize);

    final int partSize = await _getPartSize(fileSize);
    final int partNum = (fileSize / partSize).ceil().clamp(1, 10000);
    uploadFileListener?.partSize(id, partSize, partNum);

    final List<int> partSizes = List<int>.generate(partNum, (int i) {
      if (i < partNum - 1) {
        return partSize;
      }
      return fileSize - partSize * (partNum - 1);
    });

    final List<String> partMd5s = await SdkComputeExecutor.computePartMd5s(
      filePath: filePath,
      fileBytes: fileBytes,
      partSize: partSize,
      partNum: partNum,
      fileSize: fileSize,
    );
    final List<String?> partEtags = List<String?>.filled(partNum, null);

    for (int i = 0; i < partNum; i++) {
      uploadFileListener?.hashPartProgress(id, i, partSizes[i], partMd5s[i]);
    }

    final String combinedHashStr = partMd5s.join(',');
    final String hash = await SdkComputeExecutor.computeCombinedMd5(partMd5s);
    uploadFileListener?.hashPartComplete(id, combinedHashStr, hash);

    String objectName = fileName;
    final String prefix = '$userID/';
    if (!objectName.startsWith(prefix)) {
      objectName = '$prefix$objectName';
    }
    if (objectName.startsWith('/')) {
      objectName = objectName.substring(1);
    }

    final Map<String, dynamic>? cachedTask = await _context.db.syncMeta.getUploadTaskByHashAndName(
      hash,
      objectName,
    );
    final String? cachedUploadID = cachedTask?['uploadID'] as String?;
    final Set<int> cachedUploadedParts =
        ((cachedTask?['uploadedParts'] as List<dynamic>?) ?? const <dynamic>[])
            .map<int>((dynamic e) => (e as num?)?.toInt() ?? 0)
            .where((int e) => e > 0)
            .toSet();

    final int maxParts = partNum.clamp(1, 20);
    final ApiResponse initResp = await _context.apis.objectStorage.initiateMultipartUpload(
      hash: hash,
      size: fileSize,
      partSize: partSize,
      maxParts: maxParts,
      cause: cause ?? '',
      name: objectName,
      contentType: contentType ?? 'application/octet-stream',
    );
    if (initResp.errCode != 0) {
      throw OpenIMException(code: initResp.errCode, message: initResp.errMsg);
    }

    final Map<String, dynamic> respData =
        initResp.data as Map<String, dynamic>? ?? const <String, dynamic>{};
    final String? instantUrl = respData['url'] as String?;
    if (instantUrl != null && instantUrl.isNotEmpty) {
      uploadFileListener?.complete(id, fileSize, instantUrl, 0);
      return instantUrl;
    }

    final Map<String, dynamic> upload =
        respData['upload'] as Map<String, dynamic>? ?? const <String, dynamic>{};
    final String uploadID = upload['uploadID'] as String? ?? '';
    final int? serverPartSize = (upload['partSize'] as num?)?.toInt();
    if (serverPartSize != null && serverPartSize != partSize) {
      _partLimitCache = null;
      throw OpenIMException(
        code: SDKErrorCode.sdkInternalError.code,
        message: 'part size not match, expect $partSize, got $serverPartSize',
      );
    }

    uploadFileListener?.uploadID(id, uploadID);

    final bool canResume = cachedUploadID != null && cachedUploadID == uploadID;
    if (uploadID.isNotEmpty) {
      await _context.db.syncMeta.upsertUploadTask(<String, dynamic>{
        'uploadID': uploadID,
        'hash': hash,
        'name': objectName,
        'fileSize': fileSize,
        'partSize': partSize,
        'partNum': partNum,
        'uploadedParts': canResume ? cachedUploadedParts.toList() : <int>[],
        'updateTime': DateTime.now().millisecondsSinceEpoch,
      });
    }

    int uploadedSize = 0;
    if (canResume) {
      for (final int part in cachedUploadedParts) {
        final int idx = part - 1;
        if (idx >= 0 && idx < partEtags.length) {
          partEtags[idx] = partMd5s[idx];
          uploadedSize += partSizes[idx];
        }
      }
    }
    final bool continueUpload = uploadedSize > 0;

    final Map<String, dynamic> sign =
        upload['sign'] as Map<String, dynamic>? ?? const <String, dynamic>{};
    final String signUrl = sign['url'] as String? ?? '';
    String? uploadIdParam;
    final List<dynamic>? signQuery = sign['query'] as List<dynamic>?;
    if (signQuery != null) {
      for (final dynamic q in signQuery) {
        if (q is Map<dynamic, dynamic> && q['key'] == 'uploadId') {
          final List<dynamic>? values = q['values'] as List<dynamic>?;
          if (values != null && values.isNotEmpty) {
            uploadIdParam = values.first.toString();
          }
          break;
        }
      }
    }
    final List<dynamic>? signHeader = sign['header'] as List<dynamic>?;
    List<Map<String, dynamic>> currentSignParts =
        (sign['parts'] as List<dynamic>?)?.whereType<Map<String, dynamic>>().toList() ??
        <Map<String, dynamic>>[];

    for (int i = 0; i < partNum; i++) {
      final int currentPartSize = partSizes[i];
      final int partNumber = i + 1;
      if (partEtags[i] != null) {
        uploadFileListener?.uploadPartComplete(id, i, currentPartSize, partMd5s[i]);
        continue;
      }

      final int start = i * partSize;
      final int end = (start + currentPartSize).clamp(0, fileSize);
      final Uint8List partBytes = fileBytes != null
          ? Uint8List.sublistView(fileBytes, start, end)
          : await SdkComputeExecutor.readFilePart(
              filePath: filePath!,
              start: start,
              length: end - start,
            );

      Map<String, dynamic> partInfo = currentSignParts.firstWhere(
        (Map<String, dynamic> p) => p['partNumber'] == partNumber,
        orElse: () => <String, dynamic>{},
      );

      if (partInfo.isEmpty) {
        final List<int> nextBatch = <int>[];
        for (int j = 0; j < 20 && (partNumber + j) <= partNum; j++) {
          nextBatch.add(partNumber + j);
        }
        final ApiResponse authResp = await _context.apis.objectStorage.authSign(
          uploadID: uploadID,
          partNumbers: nextBatch,
        );
        if (authResp.errCode != 0) {
          throw OpenIMException(code: authResp.errCode, message: authResp.errMsg);
        }
        final Map<String, dynamic> newSign =
            authResp.data as Map<String, dynamic>? ?? const <String, dynamic>{};
        currentSignParts =
            (newSign['parts'] as List<dynamic>?)?.whereType<Map<String, dynamic>>().toList() ??
            <Map<String, dynamic>>[];
        partInfo = currentSignParts.firstWhere(
          (Map<String, dynamic> p) => p['partNumber'] == partNumber,
          orElse: () => <String, dynamic>{},
        );
      }

      final String putUrl = _buildPartPutUrl(signUrl, uploadIdParam, partInfo);
      final Map<String, String> headers = _buildPartHeaders(signHeader, partInfo);
      if (putUrl.isNotEmpty) {
        final Response<dynamic> putResp = await _context.httpClient.dio.put<dynamic>(
          putUrl,
          data: partBytes,
          options: Options(
            headers: <String, dynamic>{...headers, Headers.contentLengthHeader: partBytes.length},
            contentType: contentType ?? 'application/octet-stream',
          ),
          onSendProgress: (int sent, int total) {
            uploadFileListener?.uploadProgress(id, fileSize, uploadedSize + sent, uploadedSize);
            onProgress?.call(uploadedSize + sent, fileSize);
          },
        );
        final int statusCode = putResp.statusCode ?? 200;
        if (statusCode < 200 || statusCode >= 300) {
          throw OpenIMException(
            code: SDKErrorCode.networkRequestError.code,
            message: 'Part upload HTTP failed ($statusCode)',
          );
        }
      }

      final String localMd5 = await SdkComputeExecutor.computeMd5(partBytes);
      if (localMd5 != partMd5s[i]) {
        throw OpenIMException(
          code: SDKErrorCode.sdkInternalError.code,
          message: 'upload part $i md5 mismatch: expect ${partMd5s[i]}, got $localMd5',
        );
      }

      partEtags[i] = partMd5s[i];
      uploadedSize += currentPartSize;
      uploadFileListener?.uploadPartComplete(id, i, currentPartSize, partMd5s[i]);

      if (uploadID.isNotEmpty) {
        await _context.db.syncMeta.upsertUploadTask(<String, dynamic>{
          'uploadID': uploadID,
          'uploadedParts': <int>[
            for (int idx = 0; idx < partEtags.length; idx++)
              if (partEtags[idx] != null) idx + 1,
          ],
          'updateTime': DateTime.now().millisecondsSinceEpoch,
        });
      }
    }

    final ApiResponse completeResp = await _context.apis.objectStorage.completeMultipartUpload(
      uploadID: uploadID,
      parts: partMd5s,
      name: objectName,
      contentType: contentType ?? 'application/octet-stream',
      cause: cause ?? '',
    );
    if (completeResp.errCode != 0) {
      throw OpenIMException(code: completeResp.errCode, message: completeResp.errMsg);
    }

    final String resultUrl = (completeResp.data?['url'] as String?) ?? '';
    if (uploadID.isNotEmpty) {
      await _context.db.syncMeta.deleteUploadTask(uploadID);
    }
    uploadFileListener?.complete(id, fileSize, resultUrl, continueUpload ? 2 : 1);
    return resultUrl;
  }

  Future<int> _getPartSize(int fileSize) async {
    if (_partLimitCache == null) {
      final ApiResponse resp = await _context.apis.objectStorage.getPartLimit();
      if (resp.errCode == 0 && resp.data is Map<String, dynamic>) {
        _partLimitCache = resp.data as Map<String, dynamic>;
      }
    }
    final Map<String, dynamic>? limit = _partLimitCache;
    if (limit != null) {
      final int minPartSize = (limit['minPartSize'] as num?)?.toInt() ?? (5 * 1024 * 1024);
      final int maxPartSize = (limit['maxPartSize'] as num?)?.toInt() ?? (5 * 1024 * 1024 * 1024);
      final int maxNumSize = (limit['maxNumSize'] as num?)?.toInt() ?? 10000;
      if (fileSize > maxPartSize * maxNumSize) {
        throw OpenIMException(
          code: SDKErrorCode.parameterError.code,
          message: 'file size $fileSize exceeds maximum',
        );
      }
      if (fileSize <= minPartSize * maxNumSize) {
        return minPartSize;
      }
      int ps = fileSize ~/ maxNumSize;
      if (fileSize % maxNumSize != 0) {
        ps++;
      }
      return ps;
    }
    return 5 * 1024 * 1024;
  }

  String _buildPartPutUrl(String signUrl, String? uploadIdParam, Map<String, dynamic> partInfo) {
    final String partUrl = partInfo['url'] as String? ?? '';
    if (partUrl.isNotEmpty) {
      return partUrl;
    }
    if (signUrl.isEmpty) {
      return '';
    }
    final Uri uri = Uri.parse(signUrl);
    final Map<String, String> queryParams = Map<String, String>.from(uri.queryParameters);
    if (uploadIdParam != null) {
      queryParams['uploadId'] = uploadIdParam;
    }
    final List<dynamic>? rawQuery = partInfo['query'] as List<dynamic>?;
    if (rawQuery != null) {
      for (final dynamic q in rawQuery) {
        if (q is Map<dynamic, dynamic>) {
          final String key = q['key']?.toString() ?? '';
          final List<dynamic>? values = q['values'] as List<dynamic>?;
          if (values != null && values.isNotEmpty && key.isNotEmpty) {
            queryParams[key] = values.first.toString();
          }
        }
      }
    }
    return uri.replace(queryParameters: queryParams).toString();
  }

  Map<String, String> _buildPartHeaders(List<dynamic>? signHeader, Map<String, dynamic> partInfo) {
    final Map<String, String> headers = <String, String>{};
    if (signHeader != null) {
      for (final dynamic h in signHeader) {
        if (h is Map<dynamic, dynamic>) {
          final String? key = h['key']?.toString();
          final List<dynamic>? values = h['values'] as List<dynamic>?;
          if (key != null && values != null && values.isNotEmpty) {
            headers[key] = values.first.toString();
          }
        }
      }
    }
    final dynamic rawHeaders = partInfo['header'];
    if (rawHeaders is List<dynamic>) {
      for (final dynamic h in rawHeaders) {
        if (h is Map<dynamic, dynamic>) {
          final String? key = h['key']?.toString();
          final List<dynamic>? values = h['values'] as List<dynamic>?;
          if (key != null && values != null && values.isNotEmpty) {
            headers[key] = values.first.toString();
          }
        }
      }
    } else if (rawHeaders is Map<dynamic, dynamic>) {
      for (final MapEntry<dynamic, dynamic> entry in rawHeaders.entries) {
        final dynamic val = entry.value;
        if (val is List<dynamic> && val.isNotEmpty) {
          headers[entry.key.toString()] = val.first.toString();
        } else if (val != null) {
          headers[entry.key.toString()] = val.toString();
        }
      }
    }
    return headers;
  }
}

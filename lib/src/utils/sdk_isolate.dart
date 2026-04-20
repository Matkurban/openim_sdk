/// OpenIM SDK Isolate 工具：将 CPU 密集型操作从主线程卸载到后台线程。
///
/// 设计原则：
/// - 使用 `isolate_manager` 插件跨平台运行（native VM Isolate + Web JS Worker）。
/// - 纯 Dart 的 worker 函数位于 [sdk_isolate_workers_core.dart]，用
///   `@isolateManagerSharedWorker` 注解，被生成器编译到单一的 `$shared_worker.js`，
///   在 Web 上真正以 Web Worker 运行。
/// - 涉及 `dart:io` 的 worker 函数位于 [sdk_isolate_workers_io.dart]，不加注解，
///   仅在 native 侧通过 `IsolateManager.runFunction` 运行；Web 侧通过 `fileBytes`
///   分支绕开，或在公共入口直接抛出 [UnsupportedError]。
/// - 对外公开的 API（`computeMd5`、`computePartMd5s` 等）签名保持不变。
library;

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;

import '../isolate/sdk_workers.dart';
import 'sdk_isolate_workers_core.dart' as core;
import 'sdk_isolate_workers_io.dart' as io_workers;

// ============================================================
// 1. MD5 哈希计算
// ============================================================

/// 计算 bytes 的 MD5 哈希，返回 hex 字符串
Future<String> computeMd5(Uint8List bytes) {
  return SdkWorkers.shared.compute<String, Uint8List>(core.md5Worker, bytes);
}

/// 计算组合 MD5：所有分片 MD5 用逗号拼接后再取 MD5
Future<String> computeCombinedMd5(List<String> partMd5s) {
  return SdkWorkers.shared.compute<String, List<String>>(core.combinedMd5Worker, partMd5s);
}

// ============================================================
// 2. 文件分片 MD5（上传流程用）
// ============================================================

class ComputePartMd5sParam {
  final String? filePath;
  final Uint8List? fileBytes;
  final int partSize;
  final int partNum;
  final int fileSize;

  const ComputePartMd5sParam({
    this.filePath,
    this.fileBytes,
    required this.partSize,
    required this.partNum,
    required this.fileSize,
  });
}

/// 批量计算多个分片的 MD5（上传流程用）
Future<List<String>> computePartMd5s(ComputePartMd5sParam param) {
  if (param.fileBytes != null) {
    return SdkWorkers.shared.compute<List<String>, Map<String, dynamic>>(
      core.partMd5sFromBytesWorker,
      <String, dynamic>{
        'fileBytes': param.fileBytes,
        'partSize': param.partSize,
        'partNum': param.partNum,
        'fileSize': param.fileSize,
      },
    );
  }
  if (param.filePath == null) {
    throw ArgumentError('filePath 或 fileBytes 必须提供其中一个');
  }
  if (kIsWeb) {
    throw UnsupportedError('Web 平台不支持通过 filePath 计算分片 MD5，请传入 fileBytes');
  }
  return SdkWorkers.runNative<List<String>, Map<String, dynamic>>(
    io_workers.partMd5sFromFileWorker,
    <String, dynamic>{
      'filePath': param.filePath,
      'partSize': param.partSize,
      'partNum': param.partNum,
      'fileSize': param.fileSize,
    },
  );
}

// ============================================================
// 3. 文件分片读取
// ============================================================

class ReadFilePartParam {
  final String filePath;
  final int start;
  final int length;

  const ReadFilePartParam({required this.filePath, required this.start, required this.length});
}

/// 在后台线程中读取文件的指定部分
Future<Uint8List> readFilePart(ReadFilePartParam param) {
  if (kIsWeb) {
    throw UnsupportedError('Web 平台不支持通过文件路径读取分片，请在主线程使用 fileBytes 切片');
  }
  return SdkWorkers.runNative<Uint8List, Map<String, dynamic>>(
    io_workers.readFilePartWorker,
    <String, dynamic>{'filePath': param.filePath, 'start': param.start, 'length': param.length},
  );
}

// ============================================================
// 4. 图片尺寸解码
// ============================================================

class ImageDimensions {
  final int width;
  final int height;

  ImageDimensions(this.width, this.height);

  static ImageDimensions? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
    final w = (map['w'] as num?)?.toInt();
    final h = (map['h'] as num?)?.toInt();
    if (w == null || h == null) return null;
    return ImageDimensions(w, h);
  }
}

/// 从字节解码图片尺寸（纯 Dart，6 端通用）
Future<ImageDimensions?> computeImageDimensions(Uint8List bytes) async {
  final map = await SdkWorkers.shared.compute<Map<String, dynamic>?, Uint8List>(
    core.imageDimensionsWorker,
    bytes,
  );
  return ImageDimensions.fromMap(map);
}

/// 从文件路径解码图片尺寸（dart:io，仅 native）
Future<ImageDimensions?> computeImageDimensionsFromFile(String filePath) async {
  if (kIsWeb) {
    throw UnsupportedError('Web 平台不支持通过 filePath 解码图片尺寸');
  }
  final map = await SdkWorkers.runNative<Map<String, dynamic>?, String>(
    io_workers.imageDimensionsFromFileWorker,
    filePath,
  );
  return ImageDimensions.fromMap(map);
}

// ============================================================
// 5. 消息搜索过滤
// ============================================================

class SearchFilterParam {
  final List<Map<String, dynamic>> data;
  final String? keyword;
  final List<int>? messageTypes;
  final int? startTime;
  final int? endTime;
  final int offset;
  final int count;

  const SearchFilterParam({
    required this.data,
    this.keyword,
    this.messageTypes,
    this.startTime,
    this.endTime,
    this.offset = 0,
    this.count = 40,
  });
}

class SearchFilterResult {
  final List<Map<String, dynamic>> filtered;

  SearchFilterResult(this.filtered);
}

/// 在后台线程执行消息搜索过滤
Future<SearchFilterResult> computeSearchFilter(SearchFilterParam param) async {
  final list = await SdkWorkers.shared
      .compute<List<dynamic>, Map<String, dynamic>>(core.searchFilterWorker, <String, dynamic>{
        'data': param.data,
        'keyword': param.keyword,
        'messageTypes': param.messageTypes,
        'startTime': param.startTime,
        'endTime': param.endTime,
        'offset': param.offset,
        'count': param.count,
      });
  return SearchFilterResult(list.map((e) => Map<String, dynamic>.from(e as Map)).toList());
}

// ============================================================
// 6. 历史消息过滤
// ============================================================

class HistoryFilterParam {
  final List<Map<String, dynamic>> data;
  final int startTime;
  final int startSeq;
  final String startClientMsgID;
  final int count;

  const HistoryFilterParam({
    required this.data,
    required this.startTime,
    required this.startSeq,
    required this.startClientMsgID,
    required this.count,
  });
}

/// 在后台线程过滤历史消息列表
Future<List<Map<String, dynamic>>> computeHistoryFilter(HistoryFilterParam param) async {
  final list = await SdkWorkers.shared
      .compute<List<dynamic>, Map<String, dynamic>>(core.historyFilterWorker, <String, dynamic>{
        'data': param.data,
        'startTime': param.startTime,
        'startSeq': param.startSeq,
        'startClientMsgID': param.startClientMsgID,
        'count': param.count,
      });
  return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
}

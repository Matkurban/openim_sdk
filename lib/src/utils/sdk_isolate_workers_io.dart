/// 使用 `dart:io` 的 Worker 函数（仅 native 5 端可用）
///
/// 这里的函数**不加** `@isolateManagerSharedWorker` 注解，避免被生成器编译到
/// JS 共享 Worker 中（dart2js 无法编译 `dart:io`）。它们在 native 平台通过
/// `IsolateManager.runFunction` 一次性派发到 VM Isolate 执行。
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

import 'sdk_isolate_workers_core.dart' show decodeImageDimensions;

@pragma('vm:entry-point')
List<String> partMd5sFromFileWorker(Map<String, dynamic> param) {
  final String filePath = param['filePath'] as String;
  final int partSize = (param['partSize'] as num).toInt();
  final int partNum = (param['partNum'] as num).toInt();
  final int fileSize = (param['fileSize'] as num).toInt();

  final results = <String>[];
  final file = _openFileSync(filePath);
  try {
    for (int i = 0; i < partNum; i++) {
      final start = i * partSize;
      final currentPartSize = (i < partNum - 1) ? partSize : fileSize - partSize * (partNum - 1);
      final end = (start + currentPartSize).clamp(0, fileSize);
      file.setPositionSync(start);
      final partBytes = file.readSync(end - start);
      results.add(md5.convert(partBytes).toString());
    }
  } finally {
    file.closeSync();
  }
  return results;
}

@pragma('vm:entry-point')
Uint8List readFilePartWorker(Map<String, dynamic> param) {
  final String filePath = param['filePath'] as String;
  final int start = (param['start'] as num).toInt();
  final int length = (param['length'] as num).toInt();

  final file = _openFileSync(filePath);
  try {
    file.setPositionSync(start);
    return file.readSync(length);
  } finally {
    file.closeSync();
  }
}

@pragma('vm:entry-point')
Map<String, dynamic>? imageDimensionsFromFileWorker(String filePath) {
  final file = _openFileSync(filePath);
  try {
    final headerBytes = file.readSync(65536);
    return decodeImageDimensions(headerBytes);
  } finally {
    file.closeSync();
  }
}

RandomAccessFile _openFileSync(String path) {
  return File(path).openSync();
}

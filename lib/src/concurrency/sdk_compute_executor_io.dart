import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

import 'sdk_compute_executor.dart';

/// Native 端通过 Dart 原生 `Isolate.run` 在独立 Isolate 执行计算任务。
///
/// Runs [computation] inside a dedicated background isolate via `Isolate.run` on native platforms.
///
/// - [computation] 待执行的纯计算闭包 / Pure computation closure to execute.
/// - Returns: 计算结果 / Computation result.
Future<R> runInBackground<R>(R Function() computation) {
  return Isolate.run<R>(computation);
}

/// Native 端在后台 Isolate 中分片读取文件并计算各片 MD5。
///
/// Reads file parts in a background isolate and computes each part's MD5 hex digest (native only).
///
/// - [filePath] 本地文件路径 / Local file path.
/// - [partSize] 单个分片字节大小 / Part size in bytes.
/// - [partNum] 分片总数 / Total number of parts.
/// - [fileSize] 文件总字节大小 / Total file size in bytes.
/// - Returns: 按分片顺序排列的 MD5 列表 / Ordered list of per-part MD5 strings.
Future<List<String>> computePartMd5sFromFile({
  required String filePath,
  required int partSize,
  required int partNum,
  required int fileSize,
}) {
  return Isolate.run<List<String>>(() {
    final List<String> results = <String>[];
    final RandomAccessFile file = File(filePath).openSync();
    try {
      for (int i = 0; i < partNum; i++) {
        final int start = i * partSize;
        final int currentPartSize = i < partNum - 1
            ? partSize
            : fileSize - partSize * (partNum - 1);
        final int end = (start + currentPartSize).clamp(0, fileSize);
        file.setPositionSync(start);
        final Uint8List partBytes = file.readSync(end - start);
        results.add(md5.convert(partBytes).toString());
      }
    } finally {
      file.closeSync();
    }
    return results;
  });
}

/// Native 端在后台 Isolate 读取文件指定片段。
///
/// Reads a specific byte range from [filePath] in a background isolate (native only).
///
/// - [filePath] 本地文件路径 / Local file path.
/// - [start] 起始字节偏移 / Starting byte offset.
/// - [length] 读取字节长度 / Byte length to read.
/// - Returns: 读取到的字节切片 / Read byte slice.
Future<Uint8List> readFilePartFromFile({
  required String filePath,
  required int start,
  required int length,
}) {
  return Isolate.run<Uint8List>(() {
    final RandomAccessFile file = File(filePath).openSync();
    try {
      file.setPositionSync(start);
      return file.readSync(length);
    } finally {
      file.closeSync();
    }
  });
}

/// Native 端在后台 Isolate 读取图片文件头并解码宽高。
///
/// Reads an image file header in a background isolate and decodes its dimensions (native only).
///
/// - [filePath] 本地图片文件路径 / Local image file path.
/// - Returns: 解析出的 [ImageDimensions]，无法识别时返回 `null` / Decoded [ImageDimensions], or `null` if unrecognized.
Future<ImageDimensions?> decodeImageDimensionsFromFile(String filePath) {
  return Isolate.run<ImageDimensions?>(() {
    final RandomAccessFile file = File(filePath).openSync();
    try {
      final Uint8List headerBytes = file.readSync(65536);
      return SdkComputeExecutor.decodeImageDimensionsSync(headerBytes);
    } finally {
      file.closeSync();
    }
  });
}

import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

import 'sdk_compute_executor.dart';

/// Native 端通过 Dart 原生 `Isolate.run` 在独立 Isolate 执行计算任务。
Future<R> runInBackground<R>(R Function() computation) {
  return Isolate.run<R>(computation);
}

/// Native 端在后台 Isolate 中分片读取文件并计算各片 MD5。
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

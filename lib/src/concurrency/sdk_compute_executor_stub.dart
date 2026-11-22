import 'dart:typed_data';

import 'sdk_compute_executor.dart';

/// Web / WASM 端在当前事件循环内联执行。
Future<R> runInBackground<R>(R Function() computation) async {
  return computation();
}

Future<List<String>> computePartMd5sFromFile({
  required String filePath,
  required int partSize,
  required int partNum,
  required int fileSize,
}) {
  throw UnsupportedError('Web platform does not support filePath MD5 computation');
}

Future<Uint8List> readFilePartFromFile({
  required String filePath,
  required int start,
  required int length,
}) {
  throw UnsupportedError('Web platform does not support reading file parts by filePath');
}

Future<ImageDimensions?> decodeImageDimensionsFromFile(String filePath) {
  throw UnsupportedError('Web platform does not support decoding image from filePath');
}

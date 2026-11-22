import 'dart:typed_data';

import 'sdk_compute_executor.dart';

/// Web / WASM 端在当前事件循环内联执行计算任务。
///
/// Executes [computation] inline on the current event loop on Web/WASM platforms.
///
/// - [computation] 待执行的纯计算闭包 / Pure computation closure to execute.
/// - Returns: 计算结果 / Computation result.
Future<R> runInBackground<R>(R Function() computation) async {
  return computation();
}

/// Web / WASM 端不支持按本地文件路径计算分片 MD5，调用时抛出 [UnsupportedError]。
///
/// Throws [UnsupportedError] on Web/WASM because local file paths are not accessible.
///
/// - [filePath] 本地文件路径 / Local file path.
/// - [partSize] 单个分片字节大小 / Part size in bytes.
/// - [partNum] 分片总数 / Total number of parts.
/// - [fileSize] 文件总字节大小 / Total file size in bytes.
/// - Returns: 永不正常返回，恒抛出 [UnsupportedError] / Never returns normally; always throws [UnsupportedError].
Future<List<String>> computePartMd5sFromFile({
  required String filePath,
  required int partSize,
  required int partNum,
  required int fileSize,
}) {
  throw UnsupportedError('Web platform does not support filePath MD5 computation');
}

/// Web / WASM 端不支持按本地文件路径读取分片，调用时抛出 [UnsupportedError]。
///
/// Throws [UnsupportedError] on Web/WASM because local file paths are not accessible.
///
/// - [filePath] 本地文件路径 / Local file path.
/// - [start] 起始字节偏移 / Starting byte offset.
/// - [length] 读取字节长度 / Byte length to read.
/// - Returns: 永不正常返回，恒抛出 [UnsupportedError] / Never returns normally; always throws [UnsupportedError].
Future<Uint8List> readFilePartFromFile({
  required String filePath,
  required int start,
  required int length,
}) {
  throw UnsupportedError('Web platform does not support reading file parts by filePath');
}

/// Web / WASM 端不支持按本地文件路径解码图片尺寸，调用时抛出 [UnsupportedError]。
///
/// Throws [UnsupportedError] on Web/WASM because local file paths are not accessible.
///
/// - [filePath] 本地图片文件路径 / Local image file path.
/// - Returns: 永不正常返回，恒抛出 [UnsupportedError] / Never returns normally; always throws [UnsupportedError].
Future<ImageDimensions?> decodeImageDimensionsFromFile(String filePath) {
  throw UnsupportedError('Web platform does not support decoding image from filePath');
}

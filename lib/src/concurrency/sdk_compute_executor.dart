import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'async_semaphore.dart';
import 'sdk_compute_executor_stub.dart'
    if (dart.library.io) 'sdk_compute_executor_io.dart'
    as platform_compute;

/// 图片宽高尺寸结果。
///
/// Decoded image width and height dimensions.
class ImageDimensions {
  /// 图片宽度（像素）。
  ///
  /// Image width in pixels.
  final int width;

  /// 图片高度（像素）。
  ///
  /// Image height in pixels.
  final int height;

  /// 创建图片尺寸结果对象。
  ///
  /// Creates an [ImageDimensions] instance.
  ///
  /// - [width] 图片宽度（像素） / Image width in pixels.
  /// - [height] 图片高度（像素） / Image height in pixels.
  const ImageDimensions({required this.width, required this.height});
}

/// SDK 纯 CPU / 同步文件计算卸载执行器。
///
/// Pure CPU and synchronous file-I/O compute offloader for the SDK.
///
/// 设计原则：
/// - Native 5 端通过 Dart 原生 `Isolate.run` 按需卸载重计算任务，零第三方并发库依赖；
/// - 内置 [AsyncSemaphore] 限制最大并发 Isolate 数（默认 2），避免抢占宿主 App 核数；
/// - Web / WASM 端条件导入内联执行，确保 6 端编译通过；
/// - 小于 256KB 的字节哈希直接在当前线程计算，避免跨 Isolate 拷贝开销。
/// Offloads heavy CPU/file work via Dart `Isolate.run` on native platforms (capped by
/// [AsyncSemaphore]) and runs inline on Web/WASM via conditional imports.
abstract final class SdkComputeExecutor {
  static const int _offloadThresholdBytes = 256 * 1024;
  static final AsyncSemaphore _semaphore = AsyncSemaphore(2);

  /// 计算字节数组 MD5（大于 256KB 自动卸载到独立 Isolate）。
  ///
  /// Computes the MD5 hex digest of [bytes], automatically offloading payloads >= 256KB.
  ///
  /// - [bytes] 输入字节数据 / Input byte buffer.
  /// - Returns: 32 位小写十六进制 MD5 字符串 / 32-character lowercase hex MD5 string.
  static Future<String> computeMd5(Uint8List bytes) async {
    if (bytes.length < _offloadThresholdBytes) {
      return md5.convert(bytes).toString();
    }
    return _semaphore.run<String>(
      () => platform_compute.runInBackground<String>(() => _md5(bytes)),
    );
  }

  /// 计算多个分片 MD5 的组合哈希。
  ///
  /// Computes the combined MD5 digest of comma-joined part MD5 strings.
  ///
  /// - [partMd5s] 各分片 MD5 字符串列表 / Ordered list of part MD5 hex digests.
  /// - Returns: 组合后的 MD5 字符串 / Combined MD5 hex string.
  static Future<String> computeCombinedMd5(List<String> partMd5s) async {
    final String joined = partMd5s.join(',');
    return md5.convert(utf8.encode(joined)).toString();
  }

  /// 计算大文件或字节缓冲的所有分片 MD5。
  ///
  /// Computes MD5 digests for every part of a file or byte buffer.
  ///
  /// - [filePath] 本地文件路径（Native 平台与 [fileBytes] 二选一） / Local file path on native platforms.
  /// - [fileBytes] 内存字节缓冲（Web 平台必填） / In-memory file bytes (required on Web).
  /// - [partSize] 单个分片字节大小 / Size of each part in bytes.
  /// - [partNum] 分片总数 / Total number of parts.
  /// - [fileSize] 文件总字节大小 / Total file size in bytes.
  /// - Returns: 按分片顺序排列的 MD5 列表 / Ordered list of per-part MD5 strings.
  static Future<List<String>> computePartMd5s({
    String? filePath,
    Uint8List? fileBytes,
    required int partSize,
    required int partNum,
    required int fileSize,
  }) async {
    if (fileBytes != null) {
      if (fileSize < _offloadThresholdBytes) {
        return _computePartMd5sFromBytes(fileBytes, partSize, partNum, fileSize);
      }
      return _semaphore.run<List<String>>(
        () => platform_compute.runInBackground<List<String>>(
          () => _computePartMd5sFromBytes(fileBytes, partSize, partNum, fileSize),
        ),
      );
    }
    if (filePath == null || filePath.isEmpty) {
      throw ArgumentError('filePath or fileBytes must be provided');
    }
    if (kIsWeb) {
      throw UnsupportedError('Web platform requires fileBytes instead of filePath');
    }
    return _semaphore.run<List<String>>(
      () => platform_compute.computePartMd5sFromFile(
        filePath: filePath,
        partSize: partSize,
        partNum: partNum,
        fileSize: fileSize,
      ),
    );
  }

  /// 在后台 Isolate 读取本地文件指定字节分片（仅 Native）。
  ///
  /// Reads a byte slice from a local file in a background isolate (native platforms only).
  ///
  /// - [filePath] 本地文件路径 / Local file path.
  /// - [start] 起始字节偏移量 / Starting byte offset.
  /// - [length] 读取字节长度 / Number of bytes to read.
  /// - Returns: 读取到的分片字节数组 / Read byte slice.
  static Future<Uint8List> readFilePart({
    required String filePath,
    required int start,
    required int length,
  }) async {
    if (kIsWeb) {
      throw UnsupportedError('Web platform does not support reading file part by filePath');
    }
    return _semaphore.run<Uint8List>(
      () => platform_compute.readFilePartFromFile(filePath: filePath, start: start, length: length),
    );
  }

  /// 从字节头解析图片宽高（支持 PNG / JPEG / GIF / BMP / WebP）。
  ///
  /// Decodes image dimensions from raw bytes (supports PNG, JPEG, GIF, BMP, WebP).
  ///
  /// - [bytes] 图片原始字节数组 / Raw image byte buffer.
  /// - Returns: 解析出的 [ImageDimensions]，无法识别时返回 `null` / Decoded [ImageDimensions], or `null` if unrecognized.
  static Future<ImageDimensions?> decodeImageDimensions(Uint8List bytes) async {
    if (bytes.length < _offloadThresholdBytes) {
      return decodeImageDimensionsSync(bytes);
    }
    return _semaphore.run<ImageDimensions?>(
      () => platform_compute.runInBackground<ImageDimensions?>(
        () => decodeImageDimensionsSync(bytes),
      ),
    );
  }

  /// 从本地文件头解析图片宽高（仅 Native）。
  ///
  /// Decodes image dimensions from a local file header (native platforms only).
  ///
  /// - [filePath] 本地图片文件路径 / Local image file path.
  /// - Returns: 解析出的 [ImageDimensions]，无法识别时返回 `null` / Decoded [ImageDimensions], or `null` if unrecognized.
  static Future<ImageDimensions?> decodeImageDimensionsFromFile(String filePath) async {
    if (kIsWeb) {
      throw UnsupportedError('Web platform does not support decoding image from filePath');
    }
    return _semaphore.run<ImageDimensions?>(
      () => platform_compute.decodeImageDimensionsFromFile(filePath),
    );
  }

  /// 纯 Dart 同步解析图片头宽高（无 `dart:io` 依赖，6 端通用）。
  ///
  /// Synchronously parses image header dimensions in pure Dart (works across all 6 platforms).
  ///
  /// - [bytes] 图片原始字节数组 / Raw image byte buffer.
  /// - Returns: 解析出的 [ImageDimensions]，无法识别时返回 `null` / Decoded [ImageDimensions], or `null` if unrecognized.
  static ImageDimensions? decodeImageDimensionsSync(Uint8List bytes) {
    if (bytes.length < 24) {
      return null;
    }

    // PNG
    if (bytes[0] == 0x89 && bytes[1] == 0x50 && bytes[2] == 0x4E && bytes[3] == 0x47) {
      final int width = (bytes[16] << 24) | (bytes[17] << 16) | (bytes[18] << 8) | bytes[19];
      final int height = (bytes[20] << 24) | (bytes[21] << 16) | (bytes[22] << 8) | bytes[23];
      return ImageDimensions(width: width, height: height);
    }

    // JPEG
    if (bytes[0] == 0xFF && bytes[1] == 0xD8) {
      int offset = 2;
      while (offset + 9 < bytes.length) {
        if (bytes[offset] != 0xFF) {
          break;
        }
        final int marker = bytes[offset + 1];
        if (marker >= 0xC0 && marker <= 0xC3) {
          final int height = (bytes[offset + 5] << 8) | bytes[offset + 6];
          final int width = (bytes[offset + 7] << 8) | bytes[offset + 8];
          return ImageDimensions(width: width, height: height);
        }
        if (marker == 0xD9 || marker == 0xDA) {
          break;
        }
        final int length = (bytes[offset + 2] << 8) | bytes[offset + 3];
        offset += 2 + length;
      }
    }

    // GIF
    if (bytes[0] == 0x47 && bytes[1] == 0x49 && bytes[2] == 0x46 && bytes.length >= 10) {
      final int width = bytes[6] | (bytes[7] << 8);
      final int height = bytes[8] | (bytes[9] << 8);
      return ImageDimensions(width: width, height: height);
    }

    // BMP
    if (bytes[0] == 0x42 && bytes[1] == 0x4D && bytes.length >= 26) {
      final int width = bytes[18] | (bytes[19] << 8) | (bytes[20] << 16) | (bytes[21] << 24);
      final int height = bytes[22] | (bytes[23] << 8) | (bytes[24] << 16) | (bytes[25] << 24);
      return ImageDimensions(width: width, height: height.abs());
    }

    // WebP
    if (bytes.length >= 30 &&
        bytes[0] == 0x52 &&
        bytes[1] == 0x49 &&
        bytes[2] == 0x46 &&
        bytes[3] == 0x46 &&
        bytes[8] == 0x57 &&
        bytes[9] == 0x45 &&
        bytes[10] == 0x42 &&
        bytes[11] == 0x50) {
      if (bytes[12] == 0x56 && bytes[13] == 0x50 && bytes[14] == 0x38 && bytes[15] == 0x20) {
        final int width = (bytes[26] | (bytes[27] << 8)) & 0x3FFF;
        final int height = (bytes[28] | (bytes[29] << 8)) & 0x3FFF;
        return ImageDimensions(width: width, height: height);
      }
      if (bytes[12] == 0x56 && bytes[13] == 0x50 && bytes[14] == 0x38 && bytes[15] == 0x4C) {
        final int bits = bytes[21] | (bytes[22] << 8) | (bytes[23] << 16) | (bytes[24] << 24);
        final int width = (bits & 0x3FFF) + 1;
        final int height = ((bits >> 14) & 0x3FFF) + 1;
        return ImageDimensions(width: width, height: height);
      }
    }

    return null;
  }

  static String _md5(Uint8List bytes) => md5.convert(bytes).toString();

  static List<String> _computePartMd5sFromBytes(
    Uint8List fileBytes,
    int partSize,
    int partNum,
    int fileSize,
  ) {
    final List<String> results = <String>[];
    for (int i = 0; i < partNum; i++) {
      final int start = i * partSize;
      final int currentPartSize = i < partNum - 1 ? partSize : fileSize - partSize * (partNum - 1);
      final int end = (start + currentPartSize).clamp(0, fileSize);
      final Uint8List partBytes = Uint8List.sublistView(fileBytes, start, end);
      results.add(md5.convert(partBytes).toString());
    }
    return results;
  }
}

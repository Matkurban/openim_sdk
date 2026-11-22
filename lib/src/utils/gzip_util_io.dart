import 'dart:io';

/// 执行 GZip 压缩编码（Native `dart:io` 实现）。
///
/// Compresses [bytes] using GZip on native (`dart:io`) platforms.
///
/// - [bytes] 原始字节数组 / Raw input bytes.
/// - Returns: GZip 压缩后的字节数组 / GZip-compressed bytes.
List<int> gzipEncode(List<int> bytes) => gzip.encode(bytes);

/// 执行 GZip 解压解码（Native `dart:io` 实现）。
///
/// Decompresses GZip-encoded [bytes] on native (`dart:io`) platforms.
///
/// - [bytes] GZip 压缩字节数组 / GZip-compressed bytes.
/// - Returns: 解压后的原始字节数组 / Decompressed raw bytes.
List<int> gzipDecode(List<int> bytes) => gzip.decode(bytes);

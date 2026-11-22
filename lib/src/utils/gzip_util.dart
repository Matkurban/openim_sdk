import 'gzip_util_stub.dart' if (dart.library.io) 'gzip_util_io.dart' as gzip_impl;

/// 跨平台 GZip 压缩编码（Native 执行 GZip 压缩，Web 原样透传）。
///
/// Cross-platform GZip encoder (compresses on native platforms, pass-through on Web).
///
/// - [bytes] 原始字节数组 / Raw input bytes.
/// - Returns: 编码后的字节数组 / Encoded bytes.
List<int> gzipEncode(List<int> bytes) => gzip_impl.gzipEncode(bytes);

/// 跨平台 GZip 解压解码（Native 执行 GZip 解压，Web 原样透传）。
///
/// Cross-platform GZip decoder (decompresses on native platforms, pass-through on Web).
///
/// - [bytes] 压缩字节数组 / Compressed input bytes.
/// - Returns: 解码后的原始字节数组 / Decoded raw bytes.
List<int> gzipDecode(List<int> bytes) => gzip_impl.gzipDecode(bytes);

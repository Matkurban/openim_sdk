import 'gzip_util_stub.dart' if (dart.library.io) 'gzip_util_io.dart' as gzip_impl;

/// 跨平台 GZip 编码
List<int> gzipEncode(List<int> bytes) => gzip_impl.gzipEncode(bytes);

/// 跨平台 GZip 解码
List<int> gzipDecode(List<int> bytes) => gzip_impl.gzipDecode(bytes);

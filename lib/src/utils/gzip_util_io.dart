import 'dart:io';

/// GZip 编解码 Native 实现（dart:io 平台）
List<int> gzipEncode(List<int> bytes) => gzip.encode(bytes);
List<int> gzipDecode(List<int> bytes) => gzip.decode(bytes);

import 'dart:typed_data';

/// Isolate Workers Stub（Web / 非 dart:io 平台）

List<String> partMd5sFromFileWorker(Map<String, dynamic> param) {
  throw UnsupportedError('partMd5sFromFileWorker is not supported on web');
}

Uint8List readFilePartWorker(Map<String, dynamic> param) {
  throw UnsupportedError('readFilePartWorker is not supported on web');
}

Map<String, dynamic>? imageDimensionsFromFileWorker(String filePath) {
  throw UnsupportedError('imageDimensionsFromFileWorker is not supported on web');
}

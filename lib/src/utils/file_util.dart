import 'file_util_stub.dart' if (dart.library.io) 'file_util_io.dart' as file_impl;

/// 跨平台判断文件是否存在 (同步)
bool fileExistsSync(String path) => file_impl.fileExistsSync(path);

/// 跨平台获取文件大小 (同步)
int fileLengthSync(String path) => file_impl.fileLengthSync(path);

/// 跨平台判断文件是否存在 (异步)
Future<bool> fileExists(String path) => file_impl.fileExists(path);

/// 跨平台获取文件大小 (异步)
Future<int> fileLength(String path) => file_impl.fileLength(path);

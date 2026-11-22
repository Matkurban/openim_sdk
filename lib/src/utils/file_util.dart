import 'file_util_stub.dart' if (dart.library.io) 'file_util_io.dart' as file_impl;

/// 跨平台同步判断本地文件是否存在。
///
/// Synchronously checks whether a local file exists across platforms.
///
/// - [path] 本地文件路径 / Local file path.
/// - Returns: 文件存在返回 `true`，Web 端或不存在返回 `false` / `true` if exists, `false` on Web or missing.
bool fileExistsSync(String path) => file_impl.fileExistsSync(path);

/// 跨平台同步获取本地文件字节大小。
///
/// Synchronously retrieves the byte length of a local file across platforms.
///
/// - [path] 本地文件路径 / Local file path.
/// - Returns: 文件字节数，不存在或 Web 端返回 `0` / File size in bytes, or `0` on Web or error.
int fileLengthSync(String path) => file_impl.fileLengthSync(path);

/// 跨平台异步判断本地文件是否存在。
///
/// Asynchronously checks whether a local file exists across platforms.
///
/// - [path] 本地文件路径 / Local file path.
/// - Returns: 文件存在返回 `true`，否则返回 `false` / `true` if exists, otherwise `false`.
Future<bool> fileExists(String path) => file_impl.fileExists(path);

/// 跨平台异步获取本地文件字节大小。
///
/// Asynchronously retrieves the byte length of a local file across platforms.
///
/// - [path] 本地文件路径 / Local file path.
/// - Returns: 文件字节数，不存在或 Web 端返回 `0` / File size in bytes, or `0` on Web or error.
Future<int> fileLength(String path) => file_impl.fileLength(path);

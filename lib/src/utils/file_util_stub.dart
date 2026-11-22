/// 同步判断文件是否存在（Web / 非 `dart:io` Stub，恒返回 `false`）。
///
/// Stub for synchronous file existence check on Web (always returns `false`).
///
/// - [path] 文件路径 / File path.
/// - Returns: 恒返回 `false` / Always returns `false`.
bool fileExistsSync(String path) => false;

/// 同步获取文件大小（Web / 非 `dart:io` Stub，恒返回 `0`）。
///
/// Stub for synchronous file length lookup on Web (always returns `0`).
///
/// - [path] 文件路径 / File path.
/// - Returns: 恒返回 `0` / Always returns `0`.
int fileLengthSync(String path) => 0;

/// 异步判断文件是否存在（Web / 非 `dart:io` Stub，恒返回 `false`）。
///
/// Stub for asynchronous file existence check on Web (always returns `false`).
///
/// - [path] 文件路径 / File path.
/// - Returns: 恒返回 `false` / Always returns `false`.
Future<bool> fileExists(String path) async => false;

/// 异步获取文件大小（Web / 非 `dart:io` Stub，恒返回 `0`）。
///
/// Stub for asynchronous file length lookup on Web (always returns `0`).
///
/// - [path] 文件路径 / File path.
/// - Returns: 恒返回 `0` / Always returns `0`.
Future<int> fileLength(String path) async => 0;

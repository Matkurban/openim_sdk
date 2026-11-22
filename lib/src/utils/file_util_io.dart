import 'dart:io';

/// 同步判断本地文件是否存在（Native `dart:io` 实现）。
///
/// Synchronously checks whether [path] exists on native (`dart:io`) platforms.
///
/// - [path] 本地文件路径 / Local file path.
/// - Returns: 存在返回 `true`，否则返回 `false` / `true` if exists, otherwise `false`.
bool fileExistsSync(String path) {
  try {
    return File(path).existsSync();
  } catch (_) {
    return false;
  }
}

/// 同步获取本地文件字节大小（Native `dart:io` 实现）。
///
/// Synchronously retrieves the byte length of [path] on native (`dart:io`) platforms.
///
/// - [path] 本地文件路径 / Local file path.
/// - Returns: 文件字节大小，失败时返回 `0` / File size in bytes, or `0` on failure.
int fileLengthSync(String path) {
  try {
    return File(path).lengthSync();
  } catch (_) {
    return 0;
  }
}

/// 异步判断本地文件是否存在（Native `dart:io` 实现）。
///
/// Asynchronously checks whether [path] exists on native (`dart:io`) platforms.
///
/// - [path] 本地文件路径 / Local file path.
/// - Returns: 存在返回 `true`，否则返回 `false` / `true` if exists, otherwise `false`.
Future<bool> fileExists(String path) async {
  try {
    return await File(path).exists();
  } catch (_) {
    return false;
  }
}

/// 异步获取本地文件字节大小（Native `dart:io` 实现）。
///
/// Asynchronously retrieves the byte length of [path] on native (`dart:io`) platforms.
///
/// - [path] 本地文件路径 / Local file path.
/// - Returns: 文件字节大小，失败时返回 `0` / File size in bytes, or `0` on failure.
Future<int> fileLength(String path) async {
  try {
    return await File(path).length();
  } catch (_) {
    return 0;
  }
}

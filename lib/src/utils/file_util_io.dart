import 'dart:io';

/// 文件操作 Native 实现（dart:io 平台）
bool fileExistsSync(String path) {
  try {
    return File(path).existsSync();
  } catch (_) {
    return false;
  }
}

int fileLengthSync(String path) {
  try {
    return File(path).lengthSync();
  } catch (_) {
    return 0;
  }
}

Future<bool> fileExists(String path) async {
  try {
    return await File(path).exists();
  } catch (_) {
    return false;
  }
}

Future<int> fileLength(String path) async {
  try {
    return await File(path).length();
  } catch (_) {
    return 0;
  }
}

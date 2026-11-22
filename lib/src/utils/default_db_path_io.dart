import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// 解析 Native 平台的默认本地数据库目录路径。
///
/// Resolves the default local database directory path on native (`dart:io`) platforms.
///
/// - Returns: 应用支持目录下的 SDK 数据库路径 / SDK database directory path under application support.
Future<String?> resolveDefaultDbPath() async {
  final Directory directory = await getApplicationSupportDirectory();
  return '${directory.path}/kurban_open_im_sdk';
}

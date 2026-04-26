import 'package:aoiwe_logger/aoiwe_logger.dart';
import 'package:openim_sdk/src/models/application_version_info.dart';
import 'package:openim_sdk/src/services/im_api_service.dart';

/// 应用版本管理：用于客户端检查最新版本、强制更新等场景。
class ApplicationManager {
  ApplicationManager._internal();

  static final ApplicationManager _instance = ApplicationManager._internal();

  factory ApplicationManager() => _instance;

  static final AoiweLogger _log = AoiweLogger('ApplicationManager');

  /// 获取指定平台的最新版本信息。
  ///
  /// 当后端没有为该平台发布过版本时返回 `null`。
  ///
  /// [platform] 取值：`android` / `ios` / `windows` / `macos` / `linux`
  /// [currentVersion] 当前客户端版本号（可选，仅用于服务端统计）
  Future<ApplicationVersionInfo?> getLatestVersion({
    required String platform,
    String? currentVersion,
  }) async {
    final resp = await ImApiService().getLatestApplicationVersion(
      platform: platform,
      version: currentVersion,
    );
    if (resp.errCode != 0) {
      _log.warning(
        'getLatestVersion failed code=${resp.errCode} msg=${resp.errMsg}',
        methodName: 'getLatestVersion',
      );
      return null;
    }
    final data = resp.data;
    if (data is Map<String, dynamic>) {
      // 后端响应：{ version: { id, platform, version, ... } } —— 没有记录时为空对象。
      final raw = data['version'];
      if (raw is Map<String, dynamic> && (raw['id']?.toString().isNotEmpty ?? false)) {
        return ApplicationVersionInfo.fromJson(raw);
      }
    }
    return null;
  }
}

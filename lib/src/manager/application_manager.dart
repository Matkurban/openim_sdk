import '../core/base_manager.dart';
import '../core/sdk_context.dart';
import '../models/api_response.dart';
import '../models/application_version_info.dart';

/// 应用版本管理器（继承 [BaseManager]）。
final class ApplicationManager extends BaseManager<void> {
  final SdkContext _context;

  /// 创建 `ApplicationManager` 实例。
  ///
  /// Creates a `ApplicationManager` instance.
  ///
  /// - [_context] context / Context.
  ApplicationManager({required this._context}) : super('ApplicationManager');

  /// 获取最新版本。
  ///
  /// Get latest version.
  ///
  /// - [platform] 平台 / Platform.
  /// - [currentVersion] current版本 / Current version.
  /// - Returns: `Future<ApplicationVersionInfo?>` 结果 / Resulting `Future<ApplicationVersionInfo?>`.
  Future<ApplicationVersionInfo?> getLatestVersion({
    required String platform,
    String? currentVersion,
  }) async {
    final ApiResponse resp = await _context.apis.governance.getLatestApplicationVersion(
      platform: platform,
      version: currentVersion,
    );
    if (resp.errCode != 0) {
      logger.warning('getLatestVersion failed code=${resp.errCode} msg=${resp.errMsg}');
      return null;
    }
    final dynamic data = resp.data;
    if (data is Map<String, dynamic>) {
      final dynamic raw = data['version'];
      if (raw is Map<String, dynamic> && (raw['id']?.toString().isNotEmpty ?? false)) {
        return ApplicationVersionInfo.fromJson(raw);
      }
    }
    return null;
  }
}

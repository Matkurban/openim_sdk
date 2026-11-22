import '../../core/base_notification_handler.dart';
import '../../listener/user_listener.dart';
import '../../models/user_info.dart';
import '../entity_syncers/user_syncer.dart';

/// 用户信息变更 (1303) 与在线状态变更 (1304) 通知处理器。
///
/// User notification handler.
final class UserNotificationHandler extends BaseNotificationHandler {
  /// 用户同步器。
  ///
  /// User syncer.
  final UserSyncer userSyncer;

  /// 登录用户ID。
  ///
  /// Login user ID.
  final String loginUserID;

  /// 用户监听器Provider。
  ///
  /// User listener provider.
  final OnUserListener? Function() userListenerProvider;

  /// 创建 `UserNotificationHandler` 实例。
  ///
  /// Creates a `UserNotificationHandler` instance.
  ///
  /// - [userSyncer] 用户同步器 / User syncer.
  /// - [loginUserID] 登录用户ID / Login user ID.
  /// - [userListenerProvider] 用户监听器Provider / User listener provider.
  UserNotificationHandler({
    required this.userSyncer,
    required this.loginUserID,
    required this.userListenerProvider,
  }) : super('UserNotificationHandler');

  /// 是否支持处理。
  ///
  /// Whether can handle.
  ///
  /// - [contentType] 内容类型 / Content type.
  /// - Returns: 操作结果布尔值 / Boolean result.
  @override
  bool canHandle(int contentType) => contentType == 1303 || contentType == 1304;

  /// 处理。
  ///
  /// Handle.
  ///
  /// - [contentType] 内容类型 / Content type.
  /// - [detail] 详情 / Detail.
  @override
  Future<void> handle(int contentType, Map<String, dynamic> detail) async {
    switch (contentType) {
      case 1303: // userInfoUpdated
        final String targetUserID = detail['userID']?.toString() ?? '';
        if (targetUserID == loginUserID || targetUserID.isEmpty) {
          await userSyncer.syncSelfUserInfo(loginUserID);
        }
      case 1304: // userStatusChange
        final String userID = detail['toUserID']?.toString() ?? detail['userID']?.toString() ?? '';
        final int status = (detail['status'] as num?)?.toInt() ?? 0;
        final List<int> platformIDs =
            ((detail['platformIDs'] as List<dynamic>?) ?? const <dynamic>[])
                .map<int>((dynamic e) => (e as num).toInt())
                .toList();
        if (userID.isNotEmpty) {
          userListenerProvider()?.userStatusChanged(
            UserStatusInfo(userID: userID, status: status, platformIDs: platformIDs),
          );
        }
    }
  }
}

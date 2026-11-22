import 'package:logging/logging.dart';

import '../../api/user_api.dart';
import '../../db/db_engine.dart';
import '../../models/api_response.dart';
import '../../models/user_info.dart';

/// 自身及目标用户信息同步器。
class UserSyncer {
  final Logger _logger = Logger('openim_sdk.UserSyncer');
  final DbEngine db;
  final UserApi userApi;
  final void Function(UserInfo info)? onSelfInfoUpdated;

  UserSyncer({required this.db, required this.userApi, this.onSelfInfoUpdated});

  /// 同步当前登录用户资料，并在昵称/头像变化时回溯更新本地已发消息展示信息。
  Future<void> syncSelfUserInfo(String userID) async {
    try {
      final ApiResponse resp = await userApi.getUsersInfo(userIDs: <String>[userID]);
      if (resp.errCode != 0) {
        return;
      }
      final List<dynamic> users = resp.data?['usersInfo'] as List<dynamic>? ?? const <dynamic>[];
      if (users.isEmpty || users.first is! Map<String, dynamic>) {
        return;
      }
      final Map<String, dynamic> newInfo = users.first as Map<String, dynamic>;
      final UserInfo? oldUser = await db.users.getLoginUser();
      final String oldNickname = oldUser?.nickname ?? '';
      final String oldFaceUrl = oldUser?.faceURL ?? '';

      await db.users.upsertUser(newInfo);
      final UserInfo updated = UserInfo.fromJson(newInfo);
      onSelfInfoUpdated?.call(updated);

      final String newNickname = updated.nickname ?? '';
      final String newFaceUrl = updated.faceURL ?? '';
      if ((newNickname != oldNickname || newFaceUrl != oldFaceUrl) && newNickname.isNotEmpty) {
        await db.messages.updateAllMessageSenderInfo(
          userID,
          senderNickname: newNickname,
          senderFaceUrl: newFaceUrl.isNotEmpty ? newFaceUrl : null,
        );
      }
    } on Object catch (error, stackTrace) {
      _logger.severe('syncSelfUserInfo failed', error, stackTrace);
    }
  }
}

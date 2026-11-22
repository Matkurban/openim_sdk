import '../../core/base_notification_handler.dart';
import '../../db/db_engine.dart';
import '../../listener/friendship_listener.dart';
import '../../models/user_info.dart';
import '../entity_syncers/friend_syncer.dart';

/// 好友与黑名单系统通知处理器（contentType 1201–1210）。
final class FriendNotificationHandler extends BaseNotificationHandler {
  final DbEngine db;
  final FriendSyncer friendSyncer;
  final String loginUserID;
  final OnFriendshipListener? Function() listenerProvider;

  FriendNotificationHandler({
    required this.db,
    required this.friendSyncer,
    required this.loginUserID,
    required this.listenerProvider,
  }) : super('FriendNotificationHandler');

  @override
  bool canHandle(int contentType) => contentType >= 1201 && contentType <= 1210;

  @override
  Future<void> handle(int contentType, Map<String, dynamic> detail) async {
    final OnFriendshipListener? listener = listenerProvider();
    switch (contentType) {
      case 1201: // friendApplicationApproved
        await friendSyncer.sync(loginUserID);
        listener?.friendApplicationAccepted(_parseFriendApp(detail));
      case 1202: // friendApplicationRejected
        listener?.friendApplicationRejected(_parseFriendApp(detail));
      case 1203: // friendApplication
        listener?.friendApplicationAdded(_parseFriendApp(detail));
      case 1204: // friendAdded
        await friendSyncer.sync(loginUserID);
        final String? fid = _extractFriendUserID(detail);
        if (fid != null) {
          final FriendInfo? info = await db.friends.getFriendByUserID(fid);
          if (info != null) {
            listener?.friendAdded(info);
          }
        }
      case 1205: // friendDeleted
        final String? fid = _extractFriendUserID(detail);
        FriendInfo? oldInfo;
        if (fid != null) {
          oldInfo = await db.friends.getFriendByUserID(fid);
          await db.friends.deleteFriend(fid);
        }
        await friendSyncer.sync(loginUserID);
        if (oldInfo != null) {
          listener?.friendDeleted(oldInfo);
        }
      case 1206: // friendRemarkSet
      case 1209: // friendInfoUpdated
      case 1210: // friendsInfoUpdate
        await friendSyncer.sync(loginUserID);
      case 1207: // blackAdded
        await friendSyncer.syncBlackList(loginUserID);
        final Map<String, dynamic> fromTo =
            detail['fromToUserID'] as Map<String, dynamic>? ?? const <String, dynamic>{};
        final String blockID =
            fromTo['toUserID']?.toString() ?? detail['blackUserID']?.toString() ?? '';
        listener?.blackAdded(BlacklistInfo(ownerUserID: loginUserID, blockUserID: blockID));
      case 1208: // blackDeleted
        final Map<String, dynamic> fromTo =
            detail['fromToUserID'] as Map<String, dynamic>? ?? const <String, dynamic>{};
        final String blockID =
            fromTo['toUserID']?.toString() ?? detail['blackUserID']?.toString() ?? '';
        if (blockID.isNotEmpty) {
          await db.friends.removeBlack(blockID);
        }
        await friendSyncer.syncBlackList(loginUserID);
        listener?.blackDeleted(BlacklistInfo(ownerUserID: loginUserID, blockUserID: blockID));
    }
  }

  FriendApplicationInfo _parseFriendApp(Map<String, dynamic> detail) {
    final Map<String, dynamic> fromTo =
        detail['fromToUserID'] as Map<String, dynamic>? ?? const <String, dynamic>{};
    return FriendApplicationInfo(
      fromUserID: fromTo['fromUserID']?.toString() ?? detail['fromUserID']?.toString(),
      toUserID: fromTo['toUserID']?.toString() ?? detail['toUserID']?.toString(),
      reqMsg: detail['reqMsg']?.toString(),
      handleMsg: detail['handleMsg']?.toString(),
    );
  }

  String? _extractFriendUserID(Map<String, dynamic> detail) {
    final Map<String, dynamic> fromTo =
        detail['fromToUserID'] as Map<String, dynamic>? ?? const <String, dynamic>{};
    final String from = fromTo['fromUserID']?.toString() ?? '';
    final String to = fromTo['toUserID']?.toString() ?? '';
    if (from.isNotEmpty && from != loginUserID) {
      return from;
    }
    if (to.isNotEmpty && to != loginUserID) {
      return to;
    }
    return detail['friendUserID']?.toString();
  }
}

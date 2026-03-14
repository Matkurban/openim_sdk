import 'dart:async';

import 'package:get/get.dart';
import 'package:openim_sdk/openim_sdk.dart';

/// 全局 SDK 监听服务
///
/// 集中注册所有 SDK Listener，通过 Broadcast Stream 分发事件，
/// 避免多个 Controller 覆盖同一个 listener 导致回调丢失。
class IMListenerService extends GetxService {
  // ---- Conversation ----
  final conversationChanged = StreamController<List<ConversationInfo>>.broadcast();
  final newConversation = StreamController<List<ConversationInfo>>.broadcast();
  final totalUnreadCount = StreamController<int>.broadcast();
  final syncStarted = StreamController<bool?>.broadcast();
  final syncFinished = StreamController<bool?>.broadcast();
  final syncFailed = StreamController<bool?>.broadcast();
  final inputStatusChanged = StreamController<InputStatusChangedData>.broadcast();

  // ---- Message ----
  final recvNewMessage = StreamController<Message>.broadcast();
  final recvMessageRevoked = StreamController<RevokedInfo>.broadcast();
  final msgDeleted = StreamController<Message>.broadcast();
  final recvC2CReadReceipt = StreamController<List<ReadReceiptInfo>>.broadcast();

  // ---- Friend ----
  final friendAdded = StreamController<FriendInfo>.broadcast();
  final friendDeleted = StreamController<FriendInfo>.broadcast();
  final friendInfoChanged = StreamController<FriendInfo>.broadcast();
  final blackAdded = StreamController<BlacklistInfo>.broadcast();
  final blackDeleted = StreamController<BlacklistInfo>.broadcast();
  final friendApplicationAdded = StreamController<FriendApplicationInfo>.broadcast();
  final friendApplicationAccepted = StreamController<FriendApplicationInfo>.broadcast();
  final friendApplicationRejected = StreamController<FriendApplicationInfo>.broadcast();

  // ---- Group ----
  final joinedGroupAdded = StreamController<GroupInfo>.broadcast();
  final joinedGroupDeleted = StreamController<GroupInfo>.broadcast();
  final groupInfoChanged = StreamController<GroupInfo>.broadcast();
  final groupApplicationAdded = StreamController<GroupApplicationInfo>.broadcast();
  final groupApplicationAccepted = StreamController<GroupApplicationInfo>.broadcast();
  final groupApplicationRejected = StreamController<GroupApplicationInfo>.broadcast();
  final groupMemberAdded = StreamController<GroupMembersInfo>.broadcast();
  final groupMemberDeleted = StreamController<GroupMembersInfo>.broadcast();
  final groupMemberInfoChanged = StreamController<GroupMembersInfo>.broadcast();
  final groupDismissed = StreamController<GroupInfo>.broadcast();

  // ---- User ----
  final selfInfoUpdated = StreamController<UserInfo>.broadcast();
  final userStatusChanged = StreamController<UserStatusInfo>.broadcast();

  /// 注册所有 SDK Listener（应在 login 之前调用）
  void initialize() {
    OpenIM.iMManager.conversationManager.setConversationListener(
      OnConversationListener(
        onConversationChanged: (list) => conversationChanged.add(list),
        onNewConversation: (list) => newConversation.add(list),
        onTotalUnreadMessageCountChanged: (count) => totalUnreadCount.add(count),
        onSyncServerStart: (reinstalled) => syncStarted.add(reinstalled),
        onSyncServerFinish: (reinstalled) => syncFinished.add(reinstalled),
        onSyncServerFailed: (reinstalled) => syncFailed.add(reinstalled),
        onInputStatusChanged: (data) => inputStatusChanged.add(data),
      ),
    );

    OpenIM.iMManager.messageManager.setAdvancedMsgListener(
      OnAdvancedMsgListener(
        onRecvNewMessage: (msg) => recvNewMessage.add(msg),
        onRecvOfflineNewMessage: (msg) => recvNewMessage.add(msg),
        onNewRecvMessageRevoked: (info) => recvMessageRevoked.add(info),
        onMsgDeleted: (msg) => msgDeleted.add(msg),
        onRecvC2CReadReceipt: (list) => recvC2CReadReceipt.add(list),
      ),
    );

    OpenIM.iMManager.friendshipManager.setFriendshipListener(
      OnFriendshipListener(
        onFriendAdded: (info) => friendAdded.add(info),
        onFriendDeleted: (info) => friendDeleted.add(info),
        onFriendInfoChanged: (info) => friendInfoChanged.add(info),
        onBlackAdded: (info) => blackAdded.add(info),
        onBlackDeleted: (info) => blackDeleted.add(info),
        onFriendApplicationAdded: (info) => friendApplicationAdded.add(info),
        onFriendApplicationAccepted: (info) => friendApplicationAccepted.add(info),
        onFriendApplicationRejected: (info) => friendApplicationRejected.add(info),
      ),
    );

    OpenIM.iMManager.groupManager.setGroupListener(
      OnGroupListener(
        onJoinedGroupAdded: (info) => joinedGroupAdded.add(info),
        onJoinedGroupDeleted: (info) => joinedGroupDeleted.add(info),
        onGroupInfoChanged: (info) => groupInfoChanged.add(info),
        onGroupApplicationAdded: (info) => groupApplicationAdded.add(info),
        onGroupApplicationAccepted: (info) => groupApplicationAccepted.add(info),
        onGroupApplicationRejected: (info) => groupApplicationRejected.add(info),
        onGroupMemberAdded: (info) => groupMemberAdded.add(info),
        onGroupMemberDeleted: (info) => groupMemberDeleted.add(info),
        onGroupMemberInfoChanged: (info) => groupMemberInfoChanged.add(info),
        onGroupDismissed: (info) => groupDismissed.add(info),
      ),
    );

    OpenIM.iMManager.userManager.setUserListener(
      OnUserListener(
        onSelfInfoUpdated: (info) => selfInfoUpdated.add(info),
        onUserStatusChanged: (info) => userStatusChanged.add(info),
      ),
    );
  }

  @override
  void onClose() {
    conversationChanged.close();
    newConversation.close();
    totalUnreadCount.close();
    syncStarted.close();
    syncFinished.close();
    syncFailed.close();
    inputStatusChanged.close();
    recvNewMessage.close();
    recvMessageRevoked.close();
    msgDeleted.close();
    recvC2CReadReceipt.close();
    friendAdded.close();
    friendDeleted.close();
    friendInfoChanged.close();
    blackAdded.close();
    blackDeleted.close();
    friendApplicationAdded.close();
    friendApplicationAccepted.close();
    friendApplicationRejected.close();
    joinedGroupAdded.close();
    joinedGroupDeleted.close();
    groupInfoChanged.close();
    groupApplicationAdded.close();
    groupApplicationAccepted.close();
    groupApplicationRejected.close();
    groupMemberAdded.close();
    groupMemberDeleted.close();
    groupMemberInfoChanged.close();
    groupDismissed.close();
    selfInfoUpdated.close();
    userStatusChanged.close();
    super.onClose();
  }
}

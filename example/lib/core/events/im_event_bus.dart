import 'package:logging/logging.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:rxdart/rxdart.dart';
import 'package:signal_wire/signal_wire.dart';

import 'im_connection_event.dart';
import 'im_conversation_event.dart';
import 'im_group_event.dart';
import 'im_message_event.dart';
import 'im_relation_event.dart';
import 'im_social_event.dart';
import 'im_user_event.dart';

/// 唯一的全局 IM 事件监听中心（基于 `rxdart` + `WireService`）。
///
/// 统一承接 OpenIM SDK 全部底层 Listener 回调，并转换为强类型响应式事件流。
/// 所有页面与 Controller 仅允许订阅本中心提供的 Stream，严禁直接注册 SDK Listener。
class ImEventBus extends WireService {
  static final Logger _logger = Logger('ImEventBus');

  bool _listenersBound = false;

  /// 连接状态最新值流（`BehaviorSubject`）。
  final BehaviorSubject<ImConnectionEvent> _connectionSubject =
      BehaviorSubject<ImConnectionEvent>.seeded(
        const ImConnectionEvent(kind: 'idle'),
      );

  /// 总未读消息数流（`BehaviorSubject`）。
  final BehaviorSubject<int> _totalUnreadSubject = BehaviorSubject<int>.seeded(
    0,
  );

  /// 积分余额最新值流（`BehaviorSubject`）。
  final BehaviorSubject<double> _pointsBalanceSubject =
      BehaviorSubject<double>.seeded(0);

  /// 会话变更流。
  final PublishSubject<ImConversationEvent> _conversationSubject =
      PublishSubject<ImConversationEvent>();

  /// 消息收发/撤回/已读/进度流。
  final PublishSubject<ImMessageEvent> _messageSubject =
      PublishSubject<ImMessageEvent>();

  /// 好友/黑名单/申请流。
  final PublishSubject<ImRelationEvent> _relationSubject =
      PublishSubject<ImRelationEvent>();

  /// 群组/成员/入群申请流。
  final PublishSubject<ImGroupEvent> _groupSubject =
      PublishSubject<ImGroupEvent>();

  /// 用户资料与在线状态流。
  final PublishSubject<ImUserEvent> _userSubject =
      PublishSubject<ImUserEvent>();

  /// 朋友圈/收藏/红包/通话/自定义业务流。
  final PublishSubject<ImSocialEvent> _socialSubject =
      PublishSubject<ImSocialEvent>();

  /// 连接事件流。
  ValueStream<ImConnectionEvent> get connectionStream =>
      _connectionSubject.stream;

  /// 总未读数流。
  ValueStream<int> get totalUnreadStream => _totalUnreadSubject.stream;

  /// 积分余额流。
  ValueStream<double> get pointsBalanceStream => _pointsBalanceSubject.stream;

  /// 会话事件流。
  Stream<ImConversationEvent> get conversationStream =>
      _conversationSubject.stream;

  /// 消息事件流。
  Stream<ImMessageEvent> get messageStream => _messageSubject.stream;

  /// 好友关系事件流。
  Stream<ImRelationEvent> get relationStream => _relationSubject.stream;

  /// 群组事件流。
  Stream<ImGroupEvent> get groupStream => _groupSubject.stream;

  /// 用户事件流。
  Stream<ImUserEvent> get userStream => _userSubject.stream;

  /// 朋友圈/收藏/红包/通话事件流。
  Stream<ImSocialEvent> get socialStream => _socialSubject.stream;

  /// 构建供 `IMManager.initSDK` 使用的唯一 [OnConnectListener]。
  OnConnectListener createConnectListener() {
    return OnConnectListener(
      onConnecting: () {
        _logger.info('IM connecting...');
        _connectionSubject.add(const ImConnectionEvent(kind: 'connecting'));
      },
      onConnectSuccess: () {
        _logger.info('IM connected');
        _connectionSubject.add(const ImConnectionEvent(kind: 'connected'));
      },
      onConnectFailed: (int? code, String? errorMsg) {
        _logger.warning('IM connect failed: $code $errorMsg');
        _connectionSubject.add(
          ImConnectionEvent(kind: 'failed', code: code, message: errorMsg),
        );
      },
      onKickedOffline: () {
        _logger.warning('IM kicked offline');
        _connectionSubject.add(const ImConnectionEvent(kind: 'kickedOffline'));
      },
      onUserTokenExpired: () {
        _logger.warning('IM user token expired');
        _connectionSubject.add(const ImConnectionEvent(kind: 'tokenExpired'));
      },
      onUserTokenInvalid: () {
        _logger.warning('IM user token invalid');
        _connectionSubject.add(const ImConnectionEvent(kind: 'tokenInvalid'));
      },
    );
  }

  /// 在 `initSDK` 成功后一次性绑定全部 SDK 业务 Listener。
  void bindSdkListeners() {
    if (_listenersBound) {
      return;
    }
    _listenersBound = true;
    final IMManager im = OpenIM.iMManager;

    im.conversationManager.setConversationListener(
      OnConversationListener(
        onConversationChanged: (List<ConversationInfo> list) {
          _conversationSubject.add(
            ImConversationEvent(kind: 'changed', conversations: list),
          );
        },
        onNewConversation: (List<ConversationInfo> list) {
          _conversationSubject.add(
            ImConversationEvent(kind: 'added', conversations: list),
          );
        },
        onTotalUnreadMessageCountChanged: (int count) {
          _totalUnreadSubject.add(count);
          _conversationSubject.add(
            ImConversationEvent(kind: 'unreadChanged', totalUnreadCount: count),
          );
        },
        onSyncServerStart: (bool? reinstalled) {
          _conversationSubject.add(
            const ImConversationEvent(kind: 'syncStart'),
          );
        },
        onSyncServerProgress: (int? progress) {
          _conversationSubject.add(
            ImConversationEvent(kind: 'syncProgress', syncProgress: progress),
          );
        },
        onSyncServerFinish: (bool? reinstalled) {
          _conversationSubject.add(
            const ImConversationEvent(kind: 'syncFinish'),
          );
        },
        onSyncServerFailed: (bool? reinstalled) {
          _conversationSubject.add(
            const ImConversationEvent(kind: 'syncFailed'),
          );
        },
        onInputStatusChanged: (InputStatusChangedData data) {
          _conversationSubject.add(
            ImConversationEvent(kind: 'inputStatus', inputStatus: data),
          );
        },
      ),
    );

    im.messageManager.setMessageListener(
      OnAdvancedMsgListener(
        onRecvNewMessage: (Message msg) {
          _messageSubject.add(ImMessageEvent(kind: 'newMessage', message: msg));
        },
        onRecvOfflineNewMessage: (Message msg) {
          _messageSubject.add(ImMessageEvent(kind: 'newMessage', message: msg));
        },
        onRecvOfflineNewMessages: (List<Message> msgs) {
          _messageSubject.add(
            ImMessageEvent(kind: 'offlineMessages', messages: msgs),
          );
        },
        onRecvOnlineOnlyMessage: (Message msg) {
          _messageSubject.add(ImMessageEvent(kind: 'onlineOnly', message: msg));
        },
        onMsgDeleted: (Message msg) {
          _messageSubject.add(ImMessageEvent(kind: 'deleted', message: msg));
        },
        onNewRecvMessageRevoked: (RevokedInfo info) {
          _messageSubject.add(
            ImMessageEvent(kind: 'revoked', revokedInfo: info),
          );
        },
        onRecvC2CReadReceipt: (List<ReadReceiptInfo> list) {
          _messageSubject.add(
            ImMessageEvent(kind: 'readReceipt', readReceipts: list),
          );
        },
        onMessageStatusChanged: (Message msg) {
          _messageSubject.add(
            ImMessageEvent(kind: 'statusChanged', message: msg),
          );
        },
      ),
    );

    im.messageManager.setMsgSendProgressListener(
      OnMsgSendProgressListener(
        onProgress: (String clientMsgID, int progress) {
          _messageSubject.add(
            ImMessageEvent(
              kind: 'sendProgress',
              clientMsgID: clientMsgID,
              progress: progress,
            ),
          );
        },
        onFailure: (String clientMsgID, String? error) {
          _messageSubject.add(
            ImMessageEvent(
              kind: 'sendFailure',
              clientMsgID: clientMsgID,
              error: error,
            ),
          );
        },
      ),
    );

    im.messageManager.setCustomBusinessListener(
      OnCustomBusinessListener(
        onRecvCustomBusinessMessage: (String payload) {
          _socialSubject.add(
            ImSocialEvent(kind: 'customBusiness', payload: payload),
          );
        },
      ),
    );

    im.friendshipManager.setFriendshipListener(
      OnFriendshipListener(
        onFriendAdded: (FriendInfo info) {
          _relationSubject.add(
            ImRelationEvent(kind: 'friendAdded', friend: info),
          );
        },
        onFriendDeleted: (FriendInfo info) {
          _relationSubject.add(
            ImRelationEvent(kind: 'friendDeleted', friend: info),
          );
        },
        onFriendInfoChanged: (FriendInfo info) {
          _relationSubject.add(
            ImRelationEvent(kind: 'friendInfoChanged', friend: info),
          );
        },
        onBlackAdded: (BlacklistInfo info) {
          _relationSubject.add(
            ImRelationEvent(kind: 'blackAdded', blacklist: info),
          );
        },
        onBlackDeleted: (BlacklistInfo info) {
          _relationSubject.add(
            ImRelationEvent(kind: 'blackDeleted', blacklist: info),
          );
        },
        onFriendApplicationAdded: (FriendApplicationInfo info) {
          _relationSubject.add(
            ImRelationEvent(kind: 'applicationAdded', application: info),
          );
        },
        onFriendApplicationAccepted: (FriendApplicationInfo info) {
          _relationSubject.add(
            ImRelationEvent(kind: 'applicationAccepted', application: info),
          );
        },
        onFriendApplicationRejected: (FriendApplicationInfo info) {
          _relationSubject.add(
            ImRelationEvent(kind: 'applicationRejected', application: info),
          );
        },
        onFriendApplicationDeleted: (FriendApplicationInfo info) {
          _relationSubject.add(
            ImRelationEvent(kind: 'applicationDeleted', application: info),
          );
        },
      ),
    );

    im.groupManager.setGroupListener(
      OnGroupListener(
        onJoinedGroupAdded: (GroupInfo info) {
          _groupSubject.add(ImGroupEvent(kind: 'joinedAdded', group: info));
        },
        onJoinedGroupDeleted: (GroupInfo info) {
          _groupSubject.add(ImGroupEvent(kind: 'joinedDeleted', group: info));
        },
        onGroupInfoChanged: (GroupInfo info) {
          _groupSubject.add(ImGroupEvent(kind: 'infoChanged', group: info));
        },
        onGroupDismissed: (GroupInfo info) {
          _groupSubject.add(ImGroupEvent(kind: 'dismissed', group: info));
        },
        onGroupMemberAdded: (GroupMembersInfo info) {
          _groupSubject.add(ImGroupEvent(kind: 'memberAdded', member: info));
        },
        onGroupMemberDeleted: (GroupMembersInfo info) {
          _groupSubject.add(ImGroupEvent(kind: 'memberDeleted', member: info));
        },
        onGroupMemberInfoChanged: (GroupMembersInfo info) {
          _groupSubject.add(
            ImGroupEvent(kind: 'memberInfoChanged', member: info),
          );
        },
        onGroupApplicationAdded: (GroupApplicationInfo info) {
          _groupSubject.add(
            ImGroupEvent(kind: 'applicationAdded', application: info),
          );
        },
        onGroupApplicationAccepted: (GroupApplicationInfo info) {
          _groupSubject.add(
            ImGroupEvent(kind: 'applicationAccepted', application: info),
          );
        },
        onGroupApplicationRejected: (GroupApplicationInfo info) {
          _groupSubject.add(
            ImGroupEvent(kind: 'applicationRejected', application: info),
          );
        },
        onGroupApplicationDeleted: (GroupApplicationInfo info) {
          _groupSubject.add(
            ImGroupEvent(kind: 'applicationDeleted', application: info),
          );
        },
      ),
    );

    im.userManager.setUserListener(
      OnUserListener(
        onSelfInfoUpdated: (UserInfo info) {
          _userSubject.add(
            ImUserEvent(kind: 'selfInfoUpdated', selfInfo: info),
          );
        },
        onUserStatusChanged: (UserStatusInfo status) {
          _userSubject.add(
            ImUserEvent(kind: 'userStatusChanged', statusInfo: status),
          );
        },
      ),
    );

    im.momentsManager.setMomentsListener(
      OnMomentsListener(
        onMomentPublished: (MomentInfo moment) {
          _socialSubject.add(
            ImSocialEvent(kind: 'momentPublished', moment: moment),
          );
        },
        onMomentDeleted: (String momentID) {
          _socialSubject.add(
            ImSocialEvent(kind: 'momentDeleted', targetID: momentID),
          );
        },
        onMomentLiked: (MomentLikeWithUser like) {
          _socialSubject.add(
            ImSocialEvent(kind: 'momentLiked', momentLike: like),
          );
        },
        onMomentUnliked: (String momentID, String userID) {
          _socialSubject.add(
            ImSocialEvent(
              kind: 'momentUnliked',
              targetID: momentID,
              extraID: userID,
            ),
          );
        },
        onMomentCommented: (MomentCommentWithUser comment) {
          _socialSubject.add(
            ImSocialEvent(kind: 'momentCommented', momentComment: comment),
          );
        },
        onMomentCommentDeleted: (String commentID) {
          _socialSubject.add(
            ImSocialEvent(kind: 'momentCommentDeleted', targetID: commentID),
          );
        },
        onMomentListUpdated: (List<MomentInfo> _) {
          _socialSubject.add(const ImSocialEvent(kind: 'momentListUpdated'));
        },
      ),
    );

    im.favoriteManager.setFavoriteListener(
      OnFavoriteListener(
        onFavoriteAdded: (FavoriteItem item) {
          _socialSubject.add(
            ImSocialEvent(kind: 'favoriteAdded', favorite: item),
          );
        },
        onFavoriteRemoved: (String targetType, String targetID) {
          _socialSubject.add(
            ImSocialEvent(
              kind: 'favoriteRemoved',
              extraID: targetType,
              targetID: targetID,
            ),
          );
        },
        onFavoriteUpdated: (FavoriteItem item) {
          _socialSubject.add(
            ImSocialEvent(kind: 'favoriteUpdated', favorite: item),
          );
        },
      ),
    );

    im.redPacketManager.setRedPacketListener(
      OnRedPacketListener(
        onRedPacketExpired: (String packetID) {
          _socialSubject.add(
            ImSocialEvent(kind: 'redPacketExpired', targetID: packetID),
          );
        },
        onPointsBalanceChanged: (double newBalance) {
          _pointsBalanceSubject.add(newBalance);
          _socialSubject.add(
            ImSocialEvent(kind: 'pointsBalanceChanged', balance: newBalance),
          );
        },
      ),
    );

    im.callManager.setCallListener(
      OnCallListener(
        onIncomingCall: (CallSession session) {
          _socialSubject.add(
            ImSocialEvent(kind: 'incomingCall', callSession: session),
          );
        },
        onCallAccepted: (CallSession session, String userID) {
          _socialSubject.add(
            ImSocialEvent(
              kind: 'callAccepted',
              callSession: session,
              extraID: userID,
            ),
          );
        },
        onCallRejected: (CallSession session, String userID) {
          _socialSubject.add(
            ImSocialEvent(
              kind: 'callRejected',
              callSession: session,
              extraID: userID,
            ),
          );
        },
        onCallCancelled: (CallSession session) {
          _socialSubject.add(
            ImSocialEvent(kind: 'callCancelled', callSession: session),
          );
        },
        onCallEnded: (CallSession session) {
          _socialSubject.add(
            ImSocialEvent(kind: 'callEnded', callSession: session),
          );
        },
        onCallTimeout: (CallSession session) {
          _socialSubject.add(
            ImSocialEvent(kind: 'callTimeout', callSession: session),
          );
        },
        onCallBusy: (CallSession session, String userID) {
          _socialSubject.add(
            ImSocialEvent(
              kind: 'callBusy',
              callSession: session,
              extraID: userID,
            ),
          );
        },
        onCallConnected: (CallSession session) {
          _socialSubject.add(
            ImSocialEvent(kind: 'callConnected', callSession: session),
          );
        },
      ),
    );

    _logger.info('All OpenIM SDK listeners bound to ImEventBus');
  }

  /// 手动刷新总未读数并广播。
  void updateTotalUnread(int count) {
    _totalUnreadSubject.add(count);
  }

  /// 手动刷新积分余额并广播。
  void updatePointsBalance(double balance) {
    _pointsBalanceSubject.add(balance);
  }

  @override
  void onClose() {
    _connectionSubject.close();
    _totalUnreadSubject.close();
    _pointsBalanceSubject.close();
    _conversationSubject.close();
    _messageSubject.close();
    _relationSubject.close();
    _groupSubject.close();
    _userSubject.close();
    _socialSubject.close();
    super.onClose();
  }
}

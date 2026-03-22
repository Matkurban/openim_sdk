import 'dart:async';
import 'dart:convert';

import 'package:openim_sdk/src/logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:openim_sdk/src/services/database_service.dart';
import 'package:openim_sdk/src/services/im_api_service.dart';

/// 通知分发器
///
/// 对应 Go SDK 的 doNotificationManager，按 contentType 区间路由到:
/// - Friend (1201-1210)
/// - User   (1301-1399)
/// - Group  (1500-1599)
/// - Conversation / Message (1300, 1701, 2001, 2101, 2102, 2200)
///
/// 每个通知: 解析 detail JSON → 更新本地 DB → 触发 Listener 回调
@internal
class NotificationDispatcher {
  final Logger _log = Logger('NotificationDispatcher');

  final DatabaseService database;

  final ImApiService api;

  late String _userID;

  final FriendshipManager friendshipManager;

  final GroupManager groupManager;

  final UserManager userManager;

  final ConversationManager conversationManager;

  final MessageManager messageManager;

  final MomentsManager momentsManager;

  final FavoriteManager favoriteManager;

  OnListenerForService? listenerForService;

  OnFriendshipListener? get friendshipListener => friendshipManager.listener;

  OnGroupListener? get groupListener => groupManager.listener;

  OnUserListener? get userListener => userManager.listener;

  OnConversationListener? get conversationListener => conversationManager.listener;

  OnAdvancedMsgListener? get msgListener => messageManager.msgListener;

  OnCustomBusinessListener? get customBusinessListener => messageManager.customBusinessListener;

  NotificationDispatcher({
    required this.database,
    required this.api,
    required this.friendshipManager,
    required this.groupManager,
    required this.userManager,
    required this.conversationManager,
    required this.messageManager,
    required this.momentsManager,
    required this.favoriteManager,
  });

  // ---------------------------------------------------------------------------
  // 防抖同步：多条通知在短时间内到达时只触发一次同步
  // 对应 Go SDK 的增量同步思路 —— 减少不必要的全量网络请求
  // ---------------------------------------------------------------------------

  Timer? _friendSyncTimer;
  Timer? _groupSyncTimer;
  Timer? _conversationSyncTimer;
  bool _friendSyncPending = false;
  // _groupSyncPending removed (no longer using debounce for group sync)
  bool _conversationSyncPending = false;

  // 防止并发同步导致 version_sync 写入竞争（从而触发 unique constraint）。
  bool _joinedGroupsSyncInFlight = false;
  bool _joinedGroupsSyncAgain = false;
  bool _conversationsSyncInFlight = false;
  bool _conversationsSyncAgain = false;

  static const _syncDebounce = Duration(milliseconds: 200);

  /// 防抖触发好友同步（多条好友通知合并为一次同步）
  void _debounceSyncFriends() {
    _log.info('called', methodName: '_debounceSyncFriends');
    try {
      _friendSyncPending = true;
      _friendSyncTimer?.cancel();
      _friendSyncTimer = Timer(_syncDebounce, () {
        if (_friendSyncPending) {
          _friendSyncPending = false;
          _syncFriends();
        }
      });
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: '_debounceSyncFriends');
      rethrow;
    }
  }

  // _debounceSyncJoinedGroups removed: all group notifications now use
  // targeted _syncGroupInfoAndMembers(groupID) or _syncJoinedGroupsSerial()
  // to match Go SDK's onlineSyncGroupAndMember / IncrSyncJoinGroup pattern.

  /// 防抖触发会话同步
  void _debounceSyncConversations() {
    _log.info('called', methodName: '_debounceSyncConversations');
    try {
      _conversationSyncPending = true;
      _conversationSyncTimer?.cancel();
      _conversationSyncTimer = Timer(_syncDebounce, () {
        if (_conversationSyncPending) {
          _conversationSyncPending = false;
          unawaited(_syncConversationsSerial());
        }
      });
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: '_debounceSyncConversations');
      rethrow;
    }
  }

  Future<void> _syncJoinedGroupsSerial() async {
    if (_joinedGroupsSyncInFlight) {
      _joinedGroupsSyncAgain = true;
      return;
    }
    _joinedGroupsSyncInFlight = true;
    try {
      do {
        _joinedGroupsSyncAgain = false;
        await _syncJoinedGroups();
      } while (_joinedGroupsSyncAgain);
    } finally {
      _joinedGroupsSyncInFlight = false;
    }
  }

  Future<void> _syncConversationsSerial() async {
    if (_conversationsSyncInFlight) {
      _conversationsSyncAgain = true;
      return;
    }
    _conversationsSyncInFlight = true;
    try {
      do {
        _conversationsSyncAgain = false;
        await _syncConversations();
      } while (_conversationsSyncAgain);
    } finally {
      _conversationsSyncInFlight = false;
    }
  }

  void setLoginUserID(String userID) {
    _log.info('userID=$userID', methodName: 'setLoginUserID');
    try {
      _userID = userID;
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'setLoginUserID');
      rethrow;
    }
  }

  /// 取消所有防抖 Timer，释放资源（登出时调用）
  void dispose() {
    _log.info('called', methodName: 'dispose');
    try {
      _friendSyncTimer?.cancel();
      _friendSyncTimer = null;
      _groupSyncTimer?.cancel();
      _groupSyncTimer = null;
      _conversationSyncTimer?.cancel();
      _conversationSyncTimer = null;
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'dispose');
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // 入口: 从 MsgSyncer 调用
  // ---------------------------------------------------------------------------

  /// 分发一条通知消息 (contentType >= 1000)
  void dispatch(int contentType, String content) {
    _log.info(
      'contentType=$contentType, content=${content.length > 50 ? "..." : content}',
      methodName: 'dispatch',
    );
    try {
      try {
        // 解析 NotificationElem → detail JSON
        final detail = _extractDetail(content);
        if (detail == null) {
          _log.info('通知无 detail: contentType=$contentType', methodName: 'dispatch');
          return;
        }
        _route(contentType, detail);
      } catch (e, s) {
        _log.error(e.toString(), error: e, stackTrace: s, methodName: 'dispatch');
      }
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'dispatch');
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // 路由
  // ---------------------------------------------------------------------------

  void _route(int contentType, Map<String, dynamic> detail) {
    _log.info('contentType=$contentType', methodName: '_route');
    try {
      final ct = contentType;

      // Friend notifications: 1201-1210
      if (ct > MessageType.friendNotificationBegin.value &&
          ct < MessageType.friendNotificationEnd.value) {
        _onFriendNotification(ct, detail);
        return;
      }

      // User notifications: 1301-1399
      if (ct > MessageType.userNotificationBegin.value &&
          ct < MessageType.userNotificationEnd.value) {
        _onUserNotification(ct, detail);
        return;
      }

      // Group notifications: 1500-1599
      if (ct > MessageType.groupNotificationBegin.value &&
          ct < MessageType.groupNotificationEnd.value) {
        _onGroupNotification(ct, detail);
        return;
      }

      // Conversation / message-level notifications
      switch (ct) {
        case 1300: // conversationChangeNotification
          _onConversationChanged(detail);
        case 1701: // conversationPrivateChatNotification
          _onConversationPrivateChat(detail);
        case 2001: // businessNotification
          _onBusinessNotification(detail);
        case 2101: // revokeNotification
          _onRevokeMsg(detail);
        case 2102: // deleteMsgsNotification
          unawaited(_onDeleteMsgs(detail));
        case 1703: // clearConversationNotification
          unawaited(_onClearConversationMsgs(detail));
        case 2200: // hasReadReceipt
          unawaited(_onReadReceipt(detail));
        default:
          _log.info('未处理的通知类型: $ct', methodName: '_route');
      }
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: '_route');
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Friend notifications
  // ---------------------------------------------------------------------------

  void _onFriendNotification(int ct, Map<String, dynamic> detail) {
    _log.info('ct=$ct', methodName: '_onFriendNotification');
    try {
      _log.info(
        'FriendNotification: contentType=$ct, detail=$detail',
        methodName: '_onFriendNotification',
      );
      switch (ct) {
        case 1201: // friendApplicationApproved
          _debounceSyncFriends();
          final request1201 = detail['request'] as Map<String, dynamic>? ?? detail;
          final info = FriendApplicationInfo.fromJson(request1201);
          friendshipListener?.friendApplicationAccepted(info);
          listenerForService?.friendApplicationAccepted(info);

        case 1202: // friendApplicationRejected
          final request1202 = detail['request'] as Map<String, dynamic>? ?? detail;
          final info = FriendApplicationInfo.fromJson(request1202);
          friendshipListener?.friendApplicationRejected(info);

        case 1203: // friendApplication (new)
          final request1203 = detail['request'] as Map<String, dynamic>? ?? detail;
          final info = FriendApplicationInfo.fromJson(request1203);
          friendshipListener?.friendApplicationAdded(info);
          listenerForService?.friendApplicationAdded(info);

        case 1204: // friendAdded
          _debounceSyncFriends();
          if (detail['friend'] != null) {
            final info = FriendInfo.fromJson(detail['friend'] as Map<String, dynamic>);
            friendshipListener?.friendAdded(info);
          }

        case 1205: // friendDeleted
          _debounceSyncFriends();
          if (detail['fromToUserID'] != null) {
            final fromTo = detail['fromToUserID'] as Map<String, dynamic>;
            final deletedUserID = fromTo['toUserID'] as String? ?? '';
            friendshipListener?.friendDeleted(FriendInfo(friendUserID: deletedUserID));
          }

        case 1206: // friendRemarkSet
          _syncFriendsAndNotifyChanged(ct, detail);

        case 1207: // blackAdded
          _syncBlackList();
          if (detail['fromToUserID'] != null) {
            final fromTo = detail['fromToUserID'] as Map<String, dynamic>;
            friendshipListener?.blackAdded(
              BlacklistInfo(
                blockUserID: fromTo['toUserID'] as String?,
                ownerUserID: fromTo['fromUserID'] as String?,
              ),
            );
          }

        case 1208: // blackDeleted
          _syncBlackList();
          if (detail['fromToUserID'] != null) {
            final fromTo = detail['fromToUserID'] as Map<String, dynamic>;
            friendshipListener?.blackDeleted(
              BlacklistInfo(
                blockUserID: fromTo['toUserID'] as String?,
                ownerUserID: fromTo['fromUserID'] as String?,
              ),
            );
          }

        case 1209: // friendInfoUpdated
          _syncFriendsAndNotifyChanged(ct, detail);

        case 1210: // friendsInfoUpdate
          _syncFriendsAndNotifyChanged(ct, detail);
      }
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: '_onFriendNotification');
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // User notifications
  // ---------------------------------------------------------------------------

  void _onUserNotification(int ct, Map<String, dynamic> detail) {
    _log.info('ct=$ct', methodName: '_onUserNotification');
    try {
      switch (ct) {
        case 1303: // userInfoUpdated
          final userID = detail['userID'] as String? ?? '';
          if (userID == _userID) {
            _syncSelfUserInfo();
          }

        case 1304: // userStatusChange
          final info = UserStatusInfo(
            userID: detail['fromUserID'] as String?,
            status: detail['status'] as int?,
            platformIDs: detail['platformID'] != null ? [detail['platformID'] as int] : null,
          );
          userListener?.userStatusChanged(info);
      }
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: '_onUserNotification');
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Group notifications
  // ---------------------------------------------------------------------------

  /// 从 notification detail 中提取 groupID
  String? _extractGroupID(Map<String, dynamic> detail) {
    final group = detail['group'];
    if (group is Map<String, dynamic>) {
      return group['groupID'] as String?;
    }
    return null;
  }

  /// 将群申请通知的 Tips 转换为扁平的 GroupApplicationInfo
  /// 对齐 Go SDK ServerGroupRequestToLocalGroupRequestForNotification:
  /// Tips 中 request 字段包含嵌套的 userInfo/groupInfo，需展开为扁平结构
  GroupApplicationInfo _tipsToGroupApplicationInfo(Map<String, dynamic> tips) {
    final request = tips['request'] as Map<String, dynamic>? ?? tips;
    final groupFromTips = tips['group'] as Map<String, dynamic>?;
    final userInfo = request['userInfo'] as Map<String, dynamic>? ?? {};
    final groupInfo = groupFromTips ?? request['groupInfo'] as Map<String, dynamic>? ?? {};
    return GroupApplicationInfo.fromJson({
      'groupID': groupInfo['groupID'],
      'groupName': groupInfo['groupName'],
      'notification': groupInfo['notification'],
      'introduction': groupInfo['introduction'],
      'groupFaceURL': groupInfo['faceURL'],
      'createTime': groupInfo['createTime'],
      'status': groupInfo['status'],
      'creatorUserID': groupInfo['creatorUserID'],
      'groupType': groupInfo['groupType'],
      'ownerUserID': groupInfo['ownerUserID'],
      'memberCount': groupInfo['memberCount'],
      'userID': userInfo['userID'],
      'nickname': userInfo['nickname'],
      'userFaceURL': userInfo['faceURL'],
      'handleResult': request['handleResult'],
      'reqMsg': request['reqMsg'],
      'handledMsg': request['handleMsg'],
      'reqTime': request['reqTime'],
      'handleUserID': request['handleUserID'],
      'handledTime': request['handleTime'],
      'ex': request['ex'],
      'joinSource': request['joinSource'],
      'inviterUserID': request['inviterUserID'],
    });
  }

  /// 群组通知处理（对齐 Go SDK group/notification.go doNotification）
  ///
  /// Go SDK 模式:
  /// - 申请类 (1503/1505/1506): 仅回调
  /// - 群列表变更 (self join/leave): IncrSyncJoinGroup
  /// - 群内变更 (info/member): onlineSyncGroupAndMember(groupID)
  void _onGroupNotification(int ct, Map<String, dynamic> detail) {
    _log.info('ct=$ct', methodName: '_onGroupNotification');
    try {
      switch (ct) {
        // Go: IncrSyncJoinGroup + IncrSyncGroupAndMember(groupID)
        case 1501: // groupCreated
          _syncJoinedGroupsAndNotifyAdded();

        // Go: onlineSyncGroupAndMember(groupID)
        case 1502: // groupInfoSet
          final gid = _extractGroupID(detail);
          if (gid != null) {
            _syncGroupInfoAndMembers(gid);
          }
          if (detail['group'] != null) {
            groupListener?.groupInfoChanged(
              GroupInfo.fromJson(detail['group'] as Map<String, dynamic>),
            );
          }

        // Go: callback only
        case 1503: // joinGroupApplication
          final info = _tipsToGroupApplicationInfo(detail);
          groupListener?.groupApplicationAdded(info);
          listenerForService?.groupApplicationAdded(info);

        // Go: self → IncrSyncJoinGroup; others → onlineSyncGroupAndMember(groupID)
        case 1504: // memberQuit
          final quitUser = detail['quitUser'] as Map<String, dynamic>?;
          final quitUserID = quitUser?['userID'] as String?;
          if (quitUserID == _userID) {
            _syncJoinedGroupsAndNotifyDeleted(detail);
          } else {
            final gid = _extractGroupID(detail);
            if (gid != null) _syncGroupInfoAndMembers(gid);
          }
          if (quitUser != null) {
            groupListener?.groupMemberDeleted(GroupMembersInfo.fromJson(quitUser));
          }

        // Go: callback only (no sync)
        case 1505: // groupApplicationAccepted
          final info = _tipsToGroupApplicationInfo(detail);
          groupListener?.groupApplicationAccepted(info);
          listenerForService?.groupApplicationAccepted(info);

        // Go: callback only
        case 1506: // groupApplicationRejected
          final info1506 = _tipsToGroupApplicationInfo(detail);
          groupListener?.groupApplicationRejected(info1506);

        // Go: onlineSyncGroupAndMember(groupID)
        case 1507: // groupOwnerTransferred
          final gid = _extractGroupID(detail);
          if (gid != null) _syncGroupInfoAndMembers(gid);
          if (detail['group'] != null) {
            groupListener?.groupInfoChanged(
              GroupInfo.fromJson(detail['group'] as Map<String, dynamic>),
            );
          }

        // Go: self → IncrSyncJoinGroup; others → onlineSyncGroupAndMember(groupID)
        case 1508: // memberKicked
          final kickedList = detail['kickedUserList'] as List?;
          final isSelf =
              kickedList?.any((u) => (u as Map<String, dynamic>)['userID'] == _userID) ?? false;
          if (isSelf) {
            _syncJoinedGroupsAndNotifyDeleted(detail);
          } else {
            final gid = _extractGroupID(detail);
            if (gid != null) _syncGroupInfoAndMembers(gid);
          }
          if (kickedList != null) {
            for (final u in kickedList) {
              if (u is Map<String, dynamic>) {
                groupListener?.groupMemberDeleted(GroupMembersInfo.fromJson(u));
              }
            }
          }

        // Go: self → IncrSyncJoinGroup + IncrSyncGroupAndMember; others → onlineSyncGroupAndMember(groupID)
        case 1509: // memberInvited
          final invitedList = detail['invitedUserList'] as List?;
          final isSelf =
              invitedList?.any((u) => (u as Map<String, dynamic>)['userID'] == _userID) ?? false;
          if (isSelf) {
            _syncJoinedGroupsAndNotifyAdded();
          } else {
            final gid = _extractGroupID(detail);
            if (gid != null) _syncGroupInfoAndMembers(gid);
          }
          if (invitedList != null) {
            for (final u in invitedList) {
              if (u is Map<String, dynamic>) {
                groupListener?.groupMemberAdded(GroupMembersInfo.fromJson(u));
              }
            }
          }

        // Go: self → IncrSyncJoinGroup + IncrSyncGroupAndMember; others → onlineSyncGroupAndMember(groupID)
        case 1510: // memberEnter
          final entrantUser = detail['entrantUser'] as Map<String, dynamic>?;
          final entrantUserID = entrantUser?['userID'] as String?;
          if (entrantUserID == _userID) {
            _syncJoinedGroupsAndNotifyAdded();
          } else {
            final gid = _extractGroupID(detail);
            if (gid != null) _syncGroupInfoAndMembers(gid);
          }
          if (entrantUser != null) {
            groupListener?.groupMemberAdded(GroupMembersInfo.fromJson(entrantUser));
          }

        // Go: callback + IncrSyncJoinGroup
        case 1511: // groupDismissed
          if (detail['group'] != null) {
            groupListener?.groupDismissed(
              GroupInfo.fromJson(detail['group'] as Map<String, dynamic>),
            );
          }
          _syncJoinedGroupsSerial();

        // Go: onlineSyncGroupAndMember(groupID)
        case 1512: // groupMemberMuted
        case 1513: // groupMemberCancelMuted
          final gid = _extractGroupID(detail);
          if (gid != null) _syncGroupInfoAndMembers(gid);
          if (detail['mutedUser'] != null) {
            groupListener?.groupMemberInfoChanged(
              GroupMembersInfo.fromJson(detail['mutedUser'] as Map<String, dynamic>),
            );
          }

        // Go: onlineSyncGroupAndMember(groupID)
        case 1514: // groupMuted
        case 1515: // groupCancelMuted
          final gid = _extractGroupID(detail);
          if (gid != null) _syncGroupInfoAndMembers(gid);
          if (detail['group'] != null) {
            groupListener?.groupInfoChanged(
              GroupInfo.fromJson(detail['group'] as Map<String, dynamic>),
            );
          }

        // Go: onlineSyncGroupAndMember(groupID)
        case 1516: // groupMemberInfoSet
        case 1517: // groupMemberSetToAdmin
        case 1518: // groupMemberSetToOrdinaryUser
          final gid = _extractGroupID(detail);
          if (gid != null) _syncGroupInfoAndMembers(gid);
          if (detail['changedUser'] != null) {
            groupListener?.groupMemberInfoChanged(
              GroupMembersInfo.fromJson(detail['changedUser'] as Map<String, dynamic>),
            );
          }

        // Go: onlineSyncGroupAndMember(groupID)
        case 1519: // groupInfoSetAnnouncement
        case 1520: // groupInfoSetName
          final gid = _extractGroupID(detail);
          if (gid != null) _syncGroupInfoAndMembers(gid);
          if (detail['group'] != null) {
            groupListener?.groupInfoChanged(
              GroupInfo.fromJson(detail['group'] as Map<String, dynamic>),
            );
          }
      }
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: '_onGroupNotification');
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Conversation notifications
  // ---------------------------------------------------------------------------

  void _onConversationChanged(Map<String, dynamic> detail) {
    _log.info('called', methodName: '_onConversationChanged');
    try {
      // 服务端会话设置变更 → 重新同步会话
      _debounceSyncConversations();
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: '_onConversationChanged');
      rethrow;
    }
  }

  void _onConversationPrivateChat(Map<String, dynamic> detail) {
    _log.info('called', methodName: '_onConversationPrivateChat');
    try {
      _debounceSyncConversations();
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: '_onConversationPrivateChat');
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Message-level notifications
  // ---------------------------------------------------------------------------

  void _onBusinessNotification(Map<String, dynamic> detail) {
    _log.info('called', methodName: '_onBusinessNotification');
    try {
      // The detail from openim-server BusinessNotification wraps key+data in a nested structure.
      // Structure: { "detail": "{\"key\":\"moment_created\",\"data\":\"{...}\"}" }
      // At this point, `detail` is already the parsed inner JSON.
      final key = detail['key'] as String?;
      final dataStr = detail['data'] as String?;

      if (key != null && dataStr != null) {
        // Try to route to moment/favorite managers
        if (key.startsWith('moment_') || key.startsWith('favorite_')) {
          _onMomentOrFavoriteNotification(key, dataStr);
          return;
        }
      }

      // Fallback: pass to custom business listener
      final detailStr = detail['detail'] as String? ?? jsonEncode(detail);
      customBusinessListener?.recvCustomBusinessMessage(detailStr);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: '_onBusinessNotification');
      rethrow;
    }
  }

  void _onMomentOrFavoriteNotification(String key, String dataStr) {
    _log.info('key=$key', methodName: '_onMomentOrFavoriteNotification');
    try {
      try {
        final data = jsonDecode(dataStr) as Map<String, dynamic>;
        if (key.startsWith('moment_')) {
          momentsManager.handleNotification(key, data);
        } else if (key.startsWith('favorite_')) {
          favoriteManager.handleNotification(key, data);
        }
      } catch (e, s) {
        _log.error(
          '解析 moment/favorite 通知失败: key=$key, error=$e',
          error: e,
          stackTrace: s,
          methodName: '_onMomentOrFavoriteNotification',
        );
      }
    } catch (e, s) {
      _log.error(
        e.toString(),
        error: e,
        stackTrace: s,
        methodName: '_onMomentOrFavoriteNotification',
      );
      rethrow;
    }
  }

  void _onRevokeMsg(Map<String, dynamic> detail) {
    _log.info('called', methodName: '_onRevokeMsg');
    try {
      final clientMsgID = detail['clientMsgID'] as String?;
      final conversationID = detail['conversationID'] as String?;
      final info = RevokedInfo(
        revokerID: detail['revokerUserID'] as String?,
        clientMsgID: clientMsgID,
        revokeTime: detail['revokeTime'] as int?,
        sessionType: _intToConversationType(detail['sesstionType'] as int?),
      );

      // 标记本地消息已删除
      if (clientMsgID != null) {
        database.updateMessage(clientMsgID, {'status': MessageStatus.deleted.value});
      }

      msgListener?.newRecvMessageRevoked(info);

      // 如果被撤回的消息是会话的 latestMsg，更新会话（对应 Go SDK revoke.go）
      if (conversationID != null && clientMsgID != null) {
        _updateConversationIfLatestMsgRevoked(conversationID, clientMsgID);
      }
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: '_onRevokeMsg');
      rethrow;
    }
  }

  /// 撤回通知后检查并更新 latestMsg
  Future<void> _updateConversationIfLatestMsgRevoked(
    String conversationID,
    String clientMsgID,
  ) async {
    _log.info(
      'conversationID=$conversationID, clientMsgID=$clientMsgID',
      methodName: '_updateConversationIfLatestMsgRevoked',
    );
    try {
      try {
        final conv = await database.getConversation(conversationID);
        if (conv?.latestMsg == null) return;
        if (conv!.latestMsg!.clientMsgID != clientMsgID) return;

        final msgs = await database.getHistoryMessages(conversationID: conversationID, count: 1);
        if (msgs.isNotEmpty) {
          await database.updateConversation(conversationID, {
            'latestMsg': jsonEncode(msgs.first.toJson()),
            'latestMsgSendTime': msgs.first.sendTime,
          });
        } else {
          await database.updateConversation(conversationID, {
            'latestMsg': '',
            'latestMsgSendTime': 0,
          });
        }
        final updated = await database.getConversation(conversationID);
        if (updated != null) {
          conversationListener?.conversationChanged([updated]);
        }
      } catch (e, s) {
        _log.error(
          e.toString(),
          error: e,
          stackTrace: s,
          methodName: '_updateConversationIfLatestMsgRevoked',
        );
      }
    } catch (e, s) {
      _log.error(
        e.toString(),
        error: e,
        stackTrace: s,
        methodName: '_updateConversationIfLatestMsgRevoked',
      );
      rethrow;
    }
  }

  Future<void> _onReadReceipt(Map<String, dynamic> detail) async {
    _log.info('called', methodName: '_onReadReceipt');
    try {
      final conversationID = detail['conversationID'] as String?;
      final hasReadSeq = detail['hasReadSeq'] as int?;
      final markAsReadUserID = detail['markAsReadUserID'] as String?;
      final seqs = (detail['seqs'] as List?)?.map((e) => e as int).toList() ?? [];

      if (conversationID != null && hasReadSeq != null) {
        database.updateConversation(conversationID, {'hasReadSeq': hasReadSeq});
      }

      if (markAsReadUserID != _userID) {
        // 对方已读：触发 OnRecvC2CReadReceipt + 更新 latestMsg 已读状态
        final msgList = conversationID != null
            ? await database.getMessagesBySeqs(conversationID, seqs)
            : const <Message>[];
        final msgIDs = msgList.map((e) => e.clientMsgID).whereType<String>().toList();
        final receipts = <ReadReceiptInfo>[
          ReadReceiptInfo(
            userID: markAsReadUserID,
            msgIDList: msgIDs,
            readTime: detail['readTime'] as int?,
          ),
        ];
        msgListener?.recvC2CReadReceipt(receipts);
        if (conversationID != null) {
          await database.markMessagesAsReadBySeqs(conversationID, seqs);
        }
        // 更新会话（对应 Go SDK doReadDrawing 的 latestMsg IsRead 更新）
        if (conversationID != null) {
          _updateConversationAfterReadReceipt(conversationID);
        }
      } else {
        // 自己在其他设备已读：减少未读数（对应 Go SDK doUnreadCount）
        if (conversationID != null) {
          _handleSelfReadReceipt(conversationID, hasReadSeq ?? 0, seqs);
        }
      }
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: '_onReadReceipt');
      rethrow;
    }
  }

  /// 对方已读后更新会话（latestMsg 的 isRead 状态）
  Future<void> _updateConversationAfterReadReceipt(String conversationID) async {
    _log.info('conversationID=$conversationID', methodName: '_updateConversationAfterReadReceipt');
    try {
      try {
        final conv = await database.getConversation(conversationID);
        if (conv == null) return;
        // 触发 conversationChanged 让 UI 更新已读状态
        conversationListener?.conversationChanged([conv]);
      } catch (e, s) {
        _log.error(
          e.toString(),
          error: e,
          stackTrace: s,
          methodName: '_updateConversationAfterReadReceipt',
        );
      }
    } catch (e, s) {
      _log.error(
        e.toString(),
        error: e,
        stackTrace: s,
        methodName: '_updateConversationAfterReadReceipt',
      );
      rethrow;
    }
  }

  /// 自己在其他设备标记已读的处理（对应 Go SDK doUnreadCount）
  Future<void> _handleSelfReadReceipt(String conversationID, int hasReadSeq, List<int> seqs) async {
    _log.info(
      'conversationID=$conversationID, hasReadSeq=$hasReadSeq',
      methodName: '_handleSelfReadReceipt',
    );
    try {
      try {
        final conv = await database.getConversation(conversationID);
        if (conv == null) return;
        await database.markMessagesAsReadBySeqs(conversationID, seqs);
        final maxSeq = await database.getConversationMaxSeq(conversationID);
        final unread = (maxSeq - hasReadSeq).clamp(0, maxSeq);
        await database.updateConversation(conversationID, {'unreadCount': unread});
        conversationListener?.conversationChanged([
          await database.getConversation(conversationID) ?? conv,
        ]);
        final total = await database.getTotalUnreadCount();
        conversationListener?.totalUnreadMessageCountChanged(total);
      } catch (e, s) {
        _log.error(e.toString(), error: e, stackTrace: s, methodName: '_handleSelfReadReceipt');
      }
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: '_handleSelfReadReceipt');
      rethrow;
    }
  }

  Future<void> _onDeleteMsgs(Map<String, dynamic> detail) async {
    _log.info('called', methodName: '_onDeleteMsgs');
    try {
      final conversationID = detail['conversationID'] as String?;
      final seqs = (detail['seqs'] as List?)?.map((e) => e as int).toList() ?? [];
      if (conversationID == null || conversationID.isEmpty || seqs.isEmpty) return;
      await database.markMessagesDeletedBySeqs(conversationID, seqs);
      await _refreshConversationAfterMessageMutation(conversationID);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: '_onDeleteMsgs');
    }
  }

  Future<void> _onClearConversationMsgs(Map<String, dynamic> detail) async {
    _log.info('called', methodName: '_onClearConversationMsgs');
    try {
      final ids =
          (detail['conversationIDs'] as List?)?.map((e) => e.toString()).toList() ??
          (detail['conversationID'] != null ? [detail['conversationID'].toString()] : <String>[]);
      for (final conversationID in ids) {
        await database.deleteConversationAllMessages(conversationID);
        await _refreshConversationAfterMessageMutation(conversationID);
      }
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: '_onClearConversationMsgs');
    }
  }

  Future<void> _refreshConversationAfterMessageMutation(String conversationID) async {
    try {
      final latest = await database.getHistoryMessages(conversationID: conversationID, count: 1);
      if (latest.isNotEmpty) {
        await database.updateConversation(conversationID, {
          'latestMsg': jsonEncode(DatabaseService.messageToDbMap(latest.first)),
          'latestMsgSendTime': latest.first.sendTime ?? 0,
        });
      } else {
        await database.updateConversation(conversationID, {
          'latestMsg': '',
          'latestMsgSendTime': 0,
          'unreadCount': 0,
        });
      }
      final conv = await database.getConversation(conversationID);
      if (conv != null) {
        conversationListener?.conversationChanged([conv]);
        final total = await database.getTotalUnreadCount();
        conversationListener?.totalUnreadMessageCountChanged(total);
      }
    } catch (e, s) {
      _log.error(
        e.toString(),
        error: e,
        stackTrace: s,
        methodName: '_refreshConversationAfterMessageMutation',
      );
    }
  }

  // ---------------------------------------------------------------------------
  // 解析工具
  // ---------------------------------------------------------------------------

  /// 从通知 content 中提取 detail JSON
  ///
  /// Go SDK 的 content 是 NotificationElem 的 JSON: {"detail":"..."}
  /// detail 字段本身是 JSON string（特定 Tips 结构）
  Map<String, dynamic>? _extractDetail(String content) {
    _log.info('called', methodName: '_extractDetail');
    if (content.isEmpty) return null;

    try {
      final map = jsonDecode(content) as Map<String, dynamic>;
      final detailStr = map['detail'] as String?;
      if (detailStr != null && detailStr.isNotEmpty) {
        return jsonDecode(detailStr) as Map<String, dynamic>;
      }
      // 原始 map 可能本身就是 detail
      return map;
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: '_extractDetail');
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // 同步辅助 (异步执行，不阻塞通知分发)
  // ---------------------------------------------------------------------------

  Future<Set<String>> _syncFriends() async {
    _log.info('called', methodName: '_syncFriends');
    final changedFriendIDs = <String>{};
    try {
      // 版本感知增量同步（对齐 Go get_incremental_friends）
      final versionInfo = await database.getVersionSync('friend', _userID);
      final versionID = versionInfo?['versionID'] as String? ?? '';
      final version = (versionInfo?['version'] as num?)?.toInt() ?? 0;

      final resp = await api.getIncrementalFriends(
        req: {'userID': _userID, 'versionID': versionID, 'version': version},
      );
      if (resp.errCode != 0) return changedFriendIDs;

      final data = resp.data as Map<String, dynamic>? ?? {};
      final bool full = data['full'] as bool? ?? false;

      final deleteIDs =
          (data['delete'] as List?)?.map((e) => e.toString()).whereType<String>().toList() ??
          const <String>[];

      final insertList = (data['insert'] as List?) ?? const <dynamic>[];
      final updateList = (data['update'] as List?) ?? const <dynamic>[];

      // 满量兜底：如果服务端标记 full，则删除本地“多余好友”
      // （增量接口理论上会提供 delete 列表，但 full 场景下做兜底更稳）
      if (full) {
        final serverFriendIDs = <String>{};
        for (final f in [...insertList, ...updateList]) {
          if (f is Map<String, dynamic>) {
            final friendUser = f['friendUser'] as Map<String, dynamic>? ?? const {};
            final id = friendUser['userID']?.toString();
            if (id != null && id.isNotEmpty) serverFriendIDs.add(id);
          }
        }
        if (serverFriendIDs.isNotEmpty) {
          final localIDs = (await database.getAllFriends())
              .map((e) => e.friendUserID)
              .whereType<String>()
              .toSet();
          final toDeleteLocal = localIDs.difference(serverFriendIDs);
          for (final userID in toDeleteLocal) {
            await database.deleteFriend(userID);
          }
        }
      }

      for (final userID in deleteIDs) {
        await database.deleteFriend(userID);
      }

      // 对齐 Go SDK friendSyncer.Sync(): update 列表使用 SQL UPDATE，insert 列表使用 batchUpsert
      for (final f in updateList) {
        if (f is! Map<String, dynamic>) continue;
        final friendUser = f['friendUser'] as Map<String, dynamic>? ?? const {};
        final friendUserID = (friendUser['userID'] ?? f['friendUserID'] ?? f['userID'])?.toString();
        if (friendUserID == null || friendUserID.isEmpty) continue;
        final friendData = {
          'friendUserID': friendUserID,
          'ownerUserID': f['ownerUserID'] ?? _userID,
          'nickname': friendUser['nickname'],
          'faceURL': friendUser['faceURL'],
          'remark': f['remark'],
          'createTime': (f['createTime'] as num?)?.toInt(),
          'ex': f['ex'],
          'addSource': f['addSource'],
          'operatorUserID': f['operatorUserID'],
          'isPinned': f['isPinned'],
        };
        final localFriend = await database.getFriendByUserID(friendUserID);
        if (localFriend == null) {
          await database.upsertFriend(friendData);
        } else {
          await database.updateFriend(friendUserID, friendData);
        }
        changedFriendIDs.add(friendUserID);
      }

      final toInsert = <Map<String, dynamic>>[];
      for (final f in insertList) {
        if (f is! Map<String, dynamic>) continue;
        final friendUser = f['friendUser'] as Map<String, dynamic>? ?? const {};
        final friendUserID = (friendUser['userID'] ?? f['friendUserID'] ?? f['userID'])?.toString();
        if (friendUserID == null || friendUserID.isEmpty) continue;
        toInsert.add({
          'friendUserID': friendUserID,
          'ownerUserID': f['ownerUserID'] ?? _userID,
          'nickname': friendUser['nickname'],
          'faceURL': friendUser['faceURL'],
          'remark': f['remark'],
          'createTime': (f['createTime'] as num?)?.toInt(),
          'addSource': (f['addSource'] as num?)?.toInt(),
          'operatorUserID': f['operatorUserID'],
          'ex': f['ex'],
          'isPinned': f['isPinned'],
        });
      }

      if (toInsert.isNotEmpty) {
        await database.batchUpsertFriends(toInsert);
        for (final item in toInsert) {
          final friendUserID = item['friendUserID']?.toString();
          if (friendUserID != null && friendUserID.isNotEmpty) {
            changedFriendIDs.add(friendUserID);
          }
        }
      }

      final newVersion = (data['version'] as num?)?.toInt() ?? version;
      final newVersionID = data['versionID'] as String? ?? versionID;
      await database.setVersionSync(
        tableName: 'friend',
        entityID: _userID,
        versionID: newVersionID,
        version: newVersion,
        uidList: const [],
      );
      return changedFriendIDs;
    } catch (e, s) {
      _log.error('同步好友异常: $e', error: e, stackTrace: s, methodName: '_syncFriends');
      return changedFriendIDs;
    }
  }

  Future<void> _syncUsersInfoByIDs(Set<String> userIDs) async {
    if (userIDs.isEmpty) return;
    try {
      final resp = await api.getUsersInfo(userIDs: userIDs.toList());
      if (resp.errCode != 0) return;
      final users = resp.data?['usersInfo'] as List? ?? [];
      final batch = users.whereType<Map<String, dynamic>>().toList();
      if (batch.isNotEmpty) {
        await database.upsertUsers(batch);
      }
    } catch (e, s) {
      _log.error('同步用户信息异常: $e', error: e, stackTrace: s, methodName: '_syncUsersInfoByIDs');
    }
  }

  /// 全量同步黑名单（对齐 Go SDK SyncAllBlackList：三路 diff）
  Future<void> _syncBlackList() async {
    _log.info('called', methodName: '_syncBlackList');
    try {
      final resp = await api.getBlackList(userID: _userID);
      if (resp.errCode != 0) return;
      final blacks = resp.data?['blacks'] as List? ?? [];
      final batch = <Map<String, dynamic>>[];
      final serverBlockIDs = <String>{};
      for (final b in blacks) {
        if (b is! Map<String, dynamic>) continue;
        // 对齐 Go SDK ServerBlackToLocalBlack：展平嵌套的 blackUserInfo
        final blackUserInfo = b['blackUserInfo'] as Map<String, dynamic>? ?? const {};
        final blockUserID = (blackUserInfo['userID'] ?? b['blockUserID'])?.toString();
        if (blockUserID == null || blockUserID.isEmpty) continue;
        serverBlockIDs.add(blockUserID);
        batch.add({
          'ownerUserID': b['ownerUserID'] ?? _userID,
          'blockUserID': blockUserID,
          'nickname': blackUserInfo['nickname'],
          'faceURL': blackUserInfo['faceURL'],
          'createTime': (b['createTime'] as num?)?.toInt(),
          'addSource': (b['addSource'] as num?)?.toInt(),
          'operatorUserID': b['operatorUserID'],
          'ex': b['ex'],
        });
      }

      // 删除本地多余条目（服务端已不存在的），对齐 Go SDK blackSyncer.Delete
      final localBlacks = await database.getBlackList();
      for (final local in localBlacks) {
        final id = local.blockUserID;
        if (id != null && !serverBlockIDs.contains(id)) {
          await database.removeBlack(id);
        }
      }

      if (batch.isNotEmpty) {
        await database.batchUpsertBlacks(batch);
      }
    } catch (e, s) {
      _log.error('同步黑名单异常: $e', error: e, stackTrace: s, methodName: '_syncBlackList');
    }
  }

  Future<void> _syncJoinedGroups() async {
    _log.info('called', methodName: '_syncJoinedGroups');
    try {
      // 版本感知增量同步（对齐 Go get_incremental_join_groups）
      final versionInfo = await database.getVersionSync('group', _userID);
      final versionID = versionInfo?['versionID'] as String? ?? '';
      final version = (versionInfo?['version'] as num?)?.toInt() ?? 0;

      final resp = await api.getIncrementalJoinGroup(
        req: {'userID': _userID, 'versionID': versionID, 'version': version},
      );
      if (resp.errCode != 0) return;

      final data = resp.data as Map<String, dynamic>? ?? {};
      final bool full = data['full'] as bool? ?? false;

      final deleteIDs =
          (data['delete'] as List?)?.map((e) => e.toString()).whereType<String>().toList() ??
          const <String>[];

      final insertList = (data['insert'] as List?) ?? const <dynamic>[];
      final updateList = (data['update'] as List?) ?? const <dynamic>[];

      // 满量兜底：full=true 时删除本地多余群
      if (full) {
        final serverGroupIDs = <String>{};
        for (final g in [...insertList, ...updateList]) {
          if (g is Map<String, dynamic>) {
            final id = g['groupID']?.toString();
            if (id != null && id.isNotEmpty) serverGroupIDs.add(id);
          }
        }
        if (serverGroupIDs.isNotEmpty) {
          final localGroupIDs = (await database.getJoinedGroupList()).map((e) => e.groupID).toSet();
          final toDeleteLocalGroups = localGroupIDs.difference(serverGroupIDs);
          for (final groupID in toDeleteLocalGroups) {
            await database.deleteGroupAllMembers(groupID);
            await database.deleteGroup(groupID);
            final convID = OpenImUtils.genGroupConversationID(groupID);
            await database.updateConversation(convID, {'isNotInGroup': true});
          }
        }
      }

      // 删除
      for (final groupID in deleteIDs) {
        await database.deleteGroupAllMembers(groupID);
        await database.deleteGroup(groupID);
        final convID = OpenImUtils.genGroupConversationID(groupID);
        await database.updateConversation(convID, {'isNotInGroup': true});
      }

      // insert/update 合并 upsert
      final allGroups = <Map<String, dynamic>>[];
      final affectedGroupIDs = <String>{};
      for (final g in [...insertList, ...updateList]) {
        if (g is Map<String, dynamic>) {
          allGroups.add(g);
          final gid = g['groupID']?.toString();
          if (gid != null && gid.isNotEmpty) affectedGroupIDs.add(gid);
        }
      }

      if (allGroups.isNotEmpty) {
        await database.batchUpsertGroups(allGroups);
      }

      // 对齐 Go SDK syncer WithNotice 回调：已解散群需清理成员 + 标记会话 + 触发回调
      for (final g in allGroups) {
        final gid = g['groupID']?.toString();
        if (gid == null || gid.isEmpty) continue;
        final status = (g['status'] as num?)?.toInt() ?? 0;
        if (status == GroupStatus.dismissed.value) {
          await database.deleteGroupAllMembers(gid);
          final convID = OpenImUtils.genGroupConversationID(gid);
          await database.updateConversation(convID, {'isNotInGroup': true});
          groupListener?.groupDismissed(GroupInfo.fromJson(g));
          affectedGroupIDs.remove(gid);
        }
      }

      // 为了尽量减少“本地补丁”，对增量里出现变化的群拉取成员列表收敛
      for (final groupID in affectedGroupIDs) {
        if (groupID.isEmpty) continue;
        await _syncGroupMembersForGroup(groupID);
      }

      final newVersion = (data['version'] as num?)?.toInt() ?? version;
      final newVersionID = data['versionID'] as String? ?? versionID;
      await database.setVersionSync(
        tableName: 'group',
        entityID: _userID,
        versionID: newVersionID,
        version: newVersion,
        uidList: const [],
      );
    } catch (e, s) {
      _log.error('同步群组异常: $e', error: e, stackTrace: s, methodName: '_syncJoinedGroups');
    }
  }

  /// 从服务器同步指定群组的所有成员到本地数据库
  Future<void> _syncGroupMembersForGroup(String groupID) async {
    _log.info('groupID=$groupID', methodName: '_syncGroupMembersForGroup');
    try {
      int offset = 0;
      const pageSize = 100;
      final allMembers = <Map<String, dynamic>>[];
      while (true) {
        final resp = await api.getGroupMemberList(
          groupID: groupID,
          offset: offset,
          count: pageSize,
        );
        if (resp.errCode != 0) break;
        final members = resp.data?['members'] as List? ?? [];
        if (members.isEmpty) break;
        for (final m in members) {
          if (m is Map<String, dynamic>) allMembers.add(m);
        }
        if (members.length < pageSize) break;
        offset += pageSize;
      }
      if (allMembers.isNotEmpty) {
        await database.batchUpsertGroupMembers(allMembers);
      }
    } catch (e, s) {
      _log.error(
        '同步群[$groupID]成员异常: $e',
        error: e,
        stackTrace: s,
        methodName: '_syncGroupMembersForGroup',
      );
    }
  }

  /// 同步指定群组的群信息 + 全部成员（对齐 Go SDK 的 onlineSyncGroupAndMember）
  ///
  /// 当收到特定群的变更通知（成员变动、群信息修改等）时使用，
  /// 而不是全量同步所有群组。
  Future<void> _syncGroupInfoAndMembers(String groupID) async {
    _log.info('groupID=$groupID', methodName: '_syncGroupInfoAndMembers');
    try {
      final groupResp = await api.getGroupsInfo(groupIDs: [groupID]);
      if (groupResp.errCode == 0) {
        final groups = groupResp.data?['groupInfos'] as List? ?? [];
        final groupMaps = <Map<String, dynamic>>[];
        for (final g in groups) {
          if (g is Map<String, dynamic>) groupMaps.add(g);
        }
        if (groupMaps.isNotEmpty) {
          await database.batchUpsertGroups(groupMaps);
          // 对齐 Go SDK：如果群已解散，清理成员 + 标记会话 + 触发回调
          final first = groupMaps.first;
          final status = (first['status'] as num?)?.toInt() ?? 0;
          if (status == GroupStatus.dismissed.value) {
            await database.deleteGroupAllMembers(groupID);
            final convID = OpenImUtils.genGroupConversationID(groupID);
            await database.updateConversation(convID, {'isNotInGroup': true});
            groupListener?.groupDismissed(GroupInfo.fromJson(first));
            return;
          }
        }
      }
      await _syncGroupMembersForGroup(groupID);
    } catch (e, s) {
      _log.error(
        '同步群[$groupID]信息+成员异常: $e',
        error: e,
        stackTrace: s,
        methodName: '_syncGroupInfoAndMembers',
      );
    }
  }

  Future<void> _syncSelfUserInfo() async {
    _log.info('called', methodName: '_syncSelfUserInfo');
    try {
      final resp = await api.getUsersInfo(userIDs: [_userID]);
      if (resp.errCode != 0) return;
      final users = resp.data?['usersInfo'] as List? ?? [];
      if (users.isNotEmpty && users.first is Map<String, dynamic>) {
        await database.upsertUser(users.first as Map<String, dynamic>);
        final updated = await database.getLoginUser();
        if (updated != null) {
          userListener?.selfInfoUpdated(updated);
        }
      }
    } catch (e, s) {
      _log.error('同步用户信息异常: $e', error: e, stackTrace: s, methodName: '_syncSelfUserInfo');
    }
  }

  Future<void> _syncConversations() async {
    _log.info('called', methodName: '_syncConversations');
    try {
      // 版本感知增量同步（对齐 Go get_incremental_conversations）
      final versionInfo = await database.getVersionSync('conversation', _userID);
      final versionID = versionInfo?['versionID'] as String? ?? '';
      final version = (versionInfo?['version'] as num?)?.toInt() ?? 0;

      final resp = await api.getIncrementalConversation(
        req: {'userID': _userID, 'versionID': versionID, 'version': version},
      );
      if (resp.errCode != 0) return;

      final data = resp.data as Map<String, dynamic>? ?? {};
      final deleteIDs =
          (data['delete'] as List?)?.map((e) => e.toString()).whereType<String>().toList() ??
          const <String>[];

      final insertList = (data['insert'] as List?) ?? const <dynamic>[];
      final updateList = (data['update'] as List?) ?? const <dynamic>[];

      for (final conversationID in deleteIDs) {
        await database.deleteConversation(conversationID);
      }

      final full = data['full'] as bool? ?? false;
      if (full && insertList.isEmpty && updateList.isEmpty) {
        await database.setVersionSync(
          tableName: 'conversation',
          entityID: _userID,
          versionID: data['versionID'] as String? ?? versionID,
          version: (data['version'] as num?)?.toInt() ?? version,
          uidList: const [],
        );
        return;
      }

      final convMaps = <Map<String, dynamic>>[];
      for (final conv in [...insertList, ...updateList]) {
        if (conv is! Map<String, dynamic>) continue;
        // 跳过自己和自己的单聊会话
        final convType = conv['conversationType'] as int?;
        final uid = conv['userID'] as String?;
        if (convType == 1 && uid == _userID) continue;

        final map = Map<String, dynamic>.from(conv);
        if (map['latestMsg'] is Map) {
          map['latestMsg'] = jsonEncode(map['latestMsg']);
        }
        convMaps.add(map);
      }

      if (convMaps.isNotEmpty) {
        // 对已存在的会话，保留本地 unreadCount，防止服务端过时数据覆盖
        for (final map in convMaps) {
          final id = map['conversationID'] as String?;
          if (id == null) continue;
          final local = await database.getConversation(id);
          if (local != null) {
            map.remove('unreadCount');
          }
        }

        // 补充 showName/faceURL（服务端不返回这些字段，需客户端填充）
        await _batchFillShowNameAndFaceURL(convMaps);

        await database.batchUpsertConversations(convMaps);

        final ids = convMaps
            .map((c) => c['conversationID'] as String?)
            .where((id) => id != null)
            .cast<String>()
            .toList();
        if (ids.isNotEmpty) {
          final convList = await database.getMultipleConversations(ids);
          if (convList.isNotEmpty) {
            conversationListener?.conversationChanged(convList);
          }
        }
      }

      await database.setVersionSync(
        tableName: 'conversation',
        entityID: _userID,
        versionID: data['versionID'] as String? ?? versionID,
        version: (data['version'] as num?)?.toInt() ?? version,
        uidList: const [],
      );
    } catch (e, s) {
      _log.error('同步会话异常: $e', error: e, stackTrace: s, methodName: '_syncConversations');
    }
  }

  /// 批量为会话填充 showName 和 faceURL
  ///
  /// 服务端 getAllConversations 不返回 showName/faceURL，需客户端填充。
  /// 对齐 Go SDK 的 batchAddFaceURLAndName：
  /// - 单聊/通知 (type=1/4): 优先好友备注 → 好友昵称 → 用户表 → 网络
  /// - 群聊 (type=3): 本地群组表 → 网络
  Future<void> _batchFillShowNameAndFaceURL(List<Map<String, dynamic>> conversations) async {
    try {
      final userIDs = <String>{};
      final groupIDs = <String>{};

      for (final conv in conversations) {
        final type = conv['conversationType'] as int?;
        if (type == 1 || type == 4) {
          final uid = conv['userID'] as String?;
          if (uid != null && uid.isNotEmpty) userIDs.add(uid);
        } else if (type == 2 || type == 3) {
          final gid = conv['groupID'] as String?;
          if (gid != null && gid.isNotEmpty) groupIDs.add(gid);
        }
      }

      // 批量查好友信息（优先使用备注）
      final friendMap = <String, FriendInfo>{};
      if (userIDs.isNotEmpty) {
        final friends = await database.getFriendsByUserIDs(userIDs.toList());
        for (final f in friends) {
          final fid = f.friendUserID;
          if (fid != null) friendMap[fid] = f;
        }
      }

      // 不在好友中的 userID，从用户表查 → 网络兜底
      final userMap = <String, UserInfo>{};
      final notInFriendIDs = userIDs.where((id) => !friendMap.containsKey(id)).toList();
      if (notInFriendIDs.isNotEmpty) {
        final users = await database.getUsersByIDs(notInFriendIDs);
        for (final u in users) {
          final uid = u.userID;
          userMap[uid] = u;
        }
        final missing = notInFriendIDs.where((id) => !userMap.containsKey(id)).toList();
        if (missing.isNotEmpty) {
          try {
            final resp = await api.getUsersInfo(userIDs: missing);
            if (resp.errCode == 0) {
              final netUsers = resp.data?['usersInfo'] as List? ?? [];
              for (final u in netUsers) {
                if (u is Map<String, dynamic>) {
                  final uid = u['userID'] as String?;
                  if (uid != null) {
                    userMap[uid] = UserInfo.fromJson(u);
                    await database.upsertUser(u);
                  }
                }
              }
            }
          } catch (_) {}
        }
      }

      // 批量查群组信息 → 网络兜底
      final groupMap = <String, GroupInfo>{};
      if (groupIDs.isNotEmpty) {
        final groups = await database.getGroupsByIDs(groupIDs.toList());
        for (final g in groups) {
          groupMap[g.groupID] = g;
        }
        final missing = groupIDs.where((id) => !groupMap.containsKey(id)).toList();
        if (missing.isNotEmpty) {
          try {
            final resp = await api.getGroupsInfo(groupIDs: missing.toList());
            if (resp.errCode == 0) {
              final netGroups = resp.data?['groupInfos'] as List? ?? [];
              for (final g in netGroups) {
                if (g is Map<String, dynamic>) {
                  final gid = g['groupID'] as String?;
                  if (gid != null) {
                    groupMap[gid] = GroupInfo.fromJson(g);
                    await database.upsertGroup(g);
                  }
                }
              }
            }
          } catch (_) {}
        }
      }

      // 填充
      for (final conv in conversations) {
        final type = conv['conversationType'] as int?;
        if (type == 1 || type == 4) {
          final uid = conv['userID'] as String? ?? '';
          final friend = friendMap[uid];
          if (friend != null) {
            conv['showName'] = friend.getShowName();
            conv['faceURL'] = friend.faceURL ?? '';
          } else {
            final user = userMap[uid];
            if (user != null) {
              conv['showName'] = user.getShowName();
              conv['faceURL'] = user.faceURL ?? '';
            }
          }
        } else if (type == 2 || type == 3) {
          final gid = conv['groupID'] as String? ?? '';
          final group = groupMap[gid];
          if (group != null) {
            conv['showName'] = group.groupName ?? '';
            conv['faceURL'] = group.faceURL ?? '';
          }
        }
      }
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: '_batchFillShowNameAndFaceURL');
    }
  }

  // ---------------------------------------------------------------------------
  // 枚举转换
  // ---------------------------------------------------------------------------

  static ConversationType? _intToConversationType(int? value) {
    if (value == null) return null;
    for (final e in ConversationType.values) {
      if (e.value == value) return e;
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // 带回调通知的同步方法
  // ---------------------------------------------------------------------------

  /// 同步好友并对比变更，触发 OnFriendInfoChanged
  ///
  /// 对应 Go SDK 的 IncrSyncFriends → syncer.Update → OnFriendInfoChanged
  Future<void> _syncFriendsAndNotifyChanged(int ct, Map<String, dynamic> detail) async {
    _log.info('called', methodName: '_syncFriendsAndNotifyChanged');
    try {
      final fromTo = detail['fromToUserID'] as Map<String, dynamic>?;
      final changedUserIDs = <String>{};
      String? asString(dynamic value) {
        final text = value?.toString();
        if (text == null || text.isEmpty) return null;
        return text;
      }

      switch (ct) {
        case 1206:
          final friendUserID = asString(fromTo?['toUserID']);
          if (friendUserID != null) changedUserIDs.add(friendUserID);
          break;
        case 1209:
          final friendUserID = asString(detail['userID']);
          if (friendUserID != null) changedUserIDs.add(friendUserID);
          break;
        case 1210:
          final friendIDs = (detail['friendIDs'] as List?) ?? const <dynamic>[];
          for (final friendID in friendIDs) {
            final value = asString(friendID);
            if (value != null) changedUserIDs.add(value);
          }
          break;
        default:
          final friendUserID = asString(fromTo?['toUserID']) ?? asString(detail['userID']);
          if (friendUserID != null) changedUserIDs.add(friendUserID);
          break;
      }

      final syncedUserIDs = await _syncFriends();
      changedUserIDs.addAll(syncedUserIDs);
      await _syncUsersInfoByIDs(changedUserIDs);

      for (final changedUserID in changedUserIDs) {
        final updated = await database.getFriendByUserID(changedUserID);
        if (updated != null) {
          friendshipListener?.friendInfoChanged(updated);

          // 对齐 Go SDK：更新对应单聊会话的 showName / faceURL
          final showName = updated.getShowName();
          final convID = OpenImUtils.genSingleConversationID(_userID, changedUserID);
          final conv = await database.getConversation(convID);
          if (conv != null) {
            final convUpdates = <String, dynamic>{'showName': showName};
            if (updated.faceURL != null) convUpdates['faceURL'] = updated.faceURL;
            if (convUpdates.isNotEmpty) {
              await database.updateConversation(convID, convUpdates);
              final updatedConv = await database.getConversation(convID);
              if (updatedConv != null) {
                conversationListener?.conversationChanged([updatedConv]);
              }
            }
          }

          await database.updateSingleChatMessageSenderInfo(
            changedUserID,
            senderNickname: showName,
            senderFaceUrl: updated.faceURL,
          );
        }
      }
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: '_syncFriendsAndNotifyChanged');
      rethrow;
    }
  }

  /// 同步已加入群组并通知新增群（自己加入了新群）
  ///
  /// 对应 Go SDK 的 IncrSyncJoinGroup → syncer.Insert → OnJoinedGroupAdded
  Future<void> _syncJoinedGroupsAndNotifyAdded() async {
    _log.info('called', methodName: '_syncJoinedGroupsAndNotifyAdded');
    try {
      final oldGroupIDs = (await database.getJoinedGroupList()).map((g) => g.groupID).toSet();
      await _syncJoinedGroupsSerial();
      final newGroups = await database.getJoinedGroupList();
      final addedGroups = <GroupInfo>[];
      final notifiedGroupIDs = <String>{};
      for (final g in newGroups) {
        if (!oldGroupIDs.contains(g.groupID)) {
          groupListener?.joinedGroupAdded(g);
          addedGroups.add(g);
          if (g.groupID.isNotEmpty) {
            notifiedGroupIDs.add(g.groupID);
          }
        }
      }

      // 对齐 Go：加入新群后需要立即补齐 sg_$groupID 会话（含 showName/maxSeq/hasReadSeq/unreadCount）。
      // 避免出现：会话缺失/昵称为空/maxSeq==0 导致已读回写不生效。
      // 重要：当你是“本地先 createGroup 再收到 groupCreated push”时，addedGroups 可能为空；
      // 但会话（sg_$groupID）仍可能缺失/昵称为空。这里用“会话是否齐全”作为兜底条件。
      final targetGroupIDs = <String>{};
      if (addedGroups.isNotEmpty) {
        for (final g in addedGroups) {
          if (g.groupID.isNotEmpty) targetGroupIDs.add(g.groupID);
        }
      } else {
        final joinedGroups = await database.getJoinedGroupList();
        final convIDs = joinedGroups
            .map<String>((g) => OpenImUtils.genGroupConversationID(g.groupID))
            .toList();
        final existing = await database.getMultipleConversations(convIDs);
        final existingMap = <String, ConversationInfo>{};
        for (final c in existing) {
          existingMap[c.conversationID] = c;
        }
        for (final g in joinedGroups) {
          final cid = OpenImUtils.genGroupConversationID(g.groupID);
          final conv = existingMap[cid];
          final showNameEmpty = (conv?.showName ?? '').isEmpty;
          final faceURLEmpty = (conv?.faceURL ?? '').isEmpty;
          if (conv == null || showNameEmpty || faceURLEmpty) {
            targetGroupIDs.add(g.groupID);
          }
        }
      }

      // 对齐 Go：当你在本地先 createGroup 写入过 group，导致 addedGroups 为空时，
      // Go 仍会在增量同步 Insert 阶段触发 OnJoinedGroupAdded。
      // Dart 这里用 “需要补齐的会话” 作为兜底条件，补触发 joinedGroupAdded 回调。
      if (groupListener != null && targetGroupIDs.isNotEmpty) {
        for (final gid in targetGroupIDs) {
          if (notifiedGroupIDs.contains(gid)) continue;
          final g = await database.getGroupByID(gid);
          if (g != null) {
            groupListener?.joinedGroupAdded(g);
            notifiedGroupIDs.add(gid);
          }
        }
      }

      if (targetGroupIDs.isNotEmpty) {
        final convIDs = targetGroupIDs.map(OpenImUtils.genGroupConversationID).toList();

        // 服务器落库可能比 push 晚一点，短重试补齐 sg_$groupID 会话
        final resultByCid = <String, Map<String, dynamic>>{};
        final seqsByCid = <String, Map<String, dynamic>>{};
        var pending = List<String>.from(convIDs);

        for (int attempt = 0; attempt < 3 && pending.isNotEmpty; attempt++) {
          final seqResp = await api.getConversationsHasReadAndMaxSeq(
            userID: _userID,
            conversationIDs: pending,
          );
          final seqs = seqResp.data?['seqs'] as Map<String, dynamic>? ?? <String, dynamic>{};
          for (final entry in seqs.entries) {
            final v = entry.value;
            if (v is Map<String, dynamic>) seqsByCid[entry.key] = v;
          }

          final convResp = await api.getConversations(
            ownerUserID: _userID,
            conversationIDs: pending,
          );
          if (convResp.errCode != 0) break;

          final conversations = convResp.data?['conversations'] as List? ?? [];
          for (final conv in conversations) {
            if (conv is! Map<String, dynamic>) continue;
            final map = Map<String, dynamic>.from(conv);
            final cid = map['conversationID'] as String?;
            if (cid == null || cid.isEmpty) continue;
            if (map['latestMsg'] is Map) {
              map['latestMsg'] = jsonEncode(map['latestMsg']);
            }
            resultByCid[cid] = map;
          }

          final gotCids = resultByCid.keys.toSet();
          pending = convIDs.where((id) => !gotCids.contains(id)).toList();

          if (pending.isNotEmpty && attempt < 2) {
            await Future.delayed(const Duration(milliseconds: 200));
          }
        }

        if (convIDs.isNotEmpty) {
          final gotCids = resultByCid.keys.toSet();
          final missingCids = convIDs.where((cid) => !gotCids.contains(cid)).toList();

          final convMaps = <Map<String, dynamic>>[];

          // 1) 写入服务器返回的会话
          for (final cid in resultByCid.keys) {
            final map = resultByCid[cid]!;
            // 强制对齐 Go：当 conversationID 是群会话 sg_$groupID 时，保证本地可见性。
            if (cid.startsWith('sg_')) {
              final gid = cid.substring(3);
              map['conversationType'] = ConversationType.superGroup.value;
              map['groupID'] = gid;
              map['isNotInGroup'] = false;
              map['userID'] = null;
            }

            final seqInfo = seqsByCid[cid];
            if (seqInfo != null) {
              final maxSeq = (seqInfo['maxSeq'] as num?)?.toInt() ?? 0;
              final hasReadSeq = (seqInfo['hasReadSeq'] as num?)?.toInt() ?? 0;
              final unread = (maxSeq - hasReadSeq).clamp(0, maxSeq);
              map['unreadCount'] = unread;
              map['maxSeq'] = maxSeq;
              map['hasReadSeq'] = hasReadSeq;
            }
            convMaps.add(map);
          }

          // 2) 对“服务器没返回”的会话写入占位，确保 UI 立即可见
          if (missingCids.isNotEmpty) {
            for (final cid in missingCids) {
              if (!cid.startsWith('sg_')) continue;
              final gid = cid.substring(3);
              final group = await database.getGroupByID(gid);
              convMaps.add({
                'conversationID': cid,
                'conversationType': ConversationType.superGroup.value,
                'userID': null,
                'groupID': gid,
                'showName': group?.groupName ?? '',
                'faceURL': group?.faceURL ?? '',
                'unreadCount': 0,
                'latestMsg': '',
                'latestMsgSendTime': group?.createTime ?? DateTime.now().millisecondsSinceEpoch,
                'maxSeq': 0,
                'hasReadSeq': 0,
                'isNotInGroup': false,
              });
            }
          }

          await _batchFillShowNameAndFaceURL(convMaps);
          await database.batchUpsertConversations(convMaps);

          _log.info(
            'sg 会话补齐: requested=${convIDs.length}, got=${resultByCid.length}, missing=${missingCids.length}, upserted=${convMaps.length}',
            methodName: '_syncJoinedGroupsAndNotifyAdded',
          );

          final updated = await database.getMultipleConversations(convIDs);
          _log.info(
            'sg 会话补齐后读取: updated=${updated.length}, updatedCids=${updated.map((e) => e.conversationID).toList()}',
            methodName: '_syncJoinedGroupsAndNotifyAdded',
          );

          if (updated.isNotEmpty) {
            conversationListener?.conversationChanged(updated);
          }
        }
      }

      // 仍保留一次 debounce 的增量会话同步，用于处理非新增会话的其他变更。
      _debounceSyncConversations();
    } catch (e, s) {
      _log.error(
        e.toString(),
        error: e,
        stackTrace: s,
        methodName: '_syncJoinedGroupsAndNotifyAdded',
      );
      rethrow;
    }
  }

  /// 处理自己退出/被踢出群的本地数据清理与通知
  ///
  /// 直接从 detail 中提取 groupID，做针对性的本地删除，
  /// 避免全量同步所有群组和成员导致的大量 unique constraint 警告。
  Future<void> _syncJoinedGroupsAndNotifyDeleted(Map<String, dynamic> detail) async {
    _log.info('called', methodName: '_syncJoinedGroupsAndNotifyDeleted');
    try {
      final groupMap = detail['group'] as Map<String, dynamic>?;
      final groupID = groupMap?['groupID'] as String?;
      if (groupID == null || groupID.isEmpty) return;

      // 删除通知使用“增量收敛 + 对比差异”
      // - 避免直接从 detail 做本地 delete（Go 使用增量 pull 来收敛）
      final oldGroupIDs = (await database.getJoinedGroupList()).map((e) => e.groupID).toSet();
      final groupInfo = groupMap != null
          ? GroupInfo.fromJson(groupMap)
          : await database.getGroupByID(groupID);

      await _syncJoinedGroupsSerial();

      final newGroupIDs = (await database.getJoinedGroupList()).map((e) => e.groupID).toSet();
      if (oldGroupIDs.contains(groupID) && !newGroupIDs.contains(groupID)) {
        // 更新会话的 isNotInGroup 字段并通知 UI（由 _syncJoinedGroups 增量逻辑完成，但需要触发回调）
        final convID = OpenImUtils.genGroupConversationID(groupID);
        final conv = await database.getConversation(convID);
        if (conv != null) {
          conversationListener?.conversationChanged([conv]);
        }

        groupListener?.joinedGroupDeleted(groupInfo ?? GroupInfo(groupID: groupID));
      }
      _debounceSyncConversations();
    } catch (e, s) {
      _log.error(
        e.toString(),
        error: e,
        stackTrace: s,
        methodName: '_syncJoinedGroupsAndNotifyDeleted',
      );
      rethrow;
    }
  }
}

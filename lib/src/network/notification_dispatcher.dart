import 'dart:convert';

import 'package:logging/logging.dart';
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
class NotificationDispatcher {
  final Logger _log = Logger('NotificationDispatcher');

  final DatabaseService database;
  final ImApiService api;
  late String _userID;

  // -- Listeners (由 IMManager 注入) --
  OnFriendshipListener? friendshipListener;
  OnGroupListener? groupListener;
  OnUserListener? userListener;
  OnConversationListener? conversationListener;
  OnAdvancedMsgListener? msgListener;
  OnCustomBusinessListener? customBusinessListener;
  OnListenerForService? listenerForService;

  NotificationDispatcher({required this.database, required this.api});

  void setLoginUserID(String userID) {
    _userID = userID;
  }

  // ---------------------------------------------------------------------------
  // 入口: 从 MsgSyncer 调用
  // ---------------------------------------------------------------------------

  /// 分发一条通知消息 (contentType >= 1000)
  void dispatch(int contentType, String content) {
    try {
      // 解析 NotificationElem → detail JSON
      final detail = _extractDetail(content);
      if (detail == null) {
        _log.fine('通知无 detail: contentType=$contentType');
        return;
      }
      _route(contentType, detail);
    } catch (e, s) {
      _log.warning('分发通知失败: contentType=$contentType', e, s);
    }
  }

  // ---------------------------------------------------------------------------
  // 路由
  // ---------------------------------------------------------------------------

  void _route(int contentType, Map<String, dynamic> detail) {
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
      case 2200: // hasReadReceipt
        _onReadReceipt(detail);
      default:
        _log.fine('未处理的通知类型: $ct');
    }
  }

  // ---------------------------------------------------------------------------
  // Friend notifications
  // ---------------------------------------------------------------------------

  void _onFriendNotification(int ct, Map<String, dynamic> detail) {
    switch (ct) {
      case 1201: // friendApplicationApproved
        _syncFriends();
        final info = FriendApplicationInfo.fromJson(detail);
        friendshipListener?.friendApplicationAccepted(info);
        listenerForService?.friendApplicationAccepted(info);

      case 1202: // friendApplicationRejected
        final info = FriendApplicationInfo.fromJson(detail);
        friendshipListener?.friendApplicationRejected(info);

      case 1203: // friendApplication (new)
        final info = FriendApplicationInfo.fromJson(detail);
        friendshipListener?.friendApplicationAdded(info);
        listenerForService?.friendApplicationAdded(info);

      case 1204: // friendAdded
        _syncFriends();
        if (detail['friend'] != null) {
          final info = FriendInfo.fromJson(detail['friend'] as Map<String, dynamic>);
          friendshipListener?.friendAdded(info);
        }

      case 1205: // friendDeleted
        _syncFriends();
        if (detail['fromToUserID'] != null) {
          final fromTo = detail['fromToUserID'] as Map<String, dynamic>;
          final deletedUserID = fromTo['toUserID'] as String? ?? '';
          friendshipListener?.friendDeleted(FriendInfo(friendUserID: deletedUserID));
        }

      case 1206: // friendRemarkSet
        _syncFriends();

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
        _syncFriends();

      case 1210: // friendsInfoUpdate
        _syncFriends();
    }
  }

  // ---------------------------------------------------------------------------
  // User notifications
  // ---------------------------------------------------------------------------

  void _onUserNotification(int ct, Map<String, dynamic> detail) {
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
  }

  // ---------------------------------------------------------------------------
  // Group notifications
  // ---------------------------------------------------------------------------

  void _onGroupNotification(int ct, Map<String, dynamic> detail) {
    switch (ct) {
      case 1501: // groupCreated
        _syncJoinedGroups();

      case 1502: // groupInfoSet
        _syncJoinedGroups();
        if (detail['group'] != null) {
          groupListener?.groupInfoChanged(
            GroupInfo.fromJson(detail['group'] as Map<String, dynamic>),
          );
        }

      case 1503: // joinGroupApplication
        final info = GroupApplicationInfo.fromJson(detail);
        groupListener?.groupApplicationAdded(info);
        listenerForService?.groupApplicationAdded(info);

      case 1504: // memberQuit
        final quitUserID = (detail['quitUser'] as Map<String, dynamic>?)?['userID'] as String?;
        if (quitUserID == _userID) {
          _syncJoinedGroups();
        }
        if (detail['quitUser'] != null) {
          groupListener?.groupMemberDeleted(
            GroupMembersInfo.fromJson(detail['quitUser'] as Map<String, dynamic>),
          );
        }

      case 1505: // groupApplicationAccepted
        _syncJoinedGroups();
        final info = GroupApplicationInfo.fromJson(detail);
        groupListener?.groupApplicationAccepted(info);
        listenerForService?.groupApplicationAccepted(info);

      case 1506: // groupApplicationRejected
        final info = GroupApplicationInfo.fromJson(detail);
        groupListener?.groupApplicationRejected(info);

      case 1507: // groupOwnerTransferred
        _syncJoinedGroups();
        if (detail['group'] != null) {
          groupListener?.groupInfoChanged(
            GroupInfo.fromJson(detail['group'] as Map<String, dynamic>),
          );
        }

      case 1508: // memberKicked
        final kickedList = detail['kickedUserList'] as List?;
        final isSelf =
            kickedList?.any((u) => (u as Map<String, dynamic>)['userID'] == _userID) ?? false;
        if (isSelf) {
          _syncJoinedGroups();
        }
        if (kickedList != null) {
          for (final u in kickedList) {
            if (u is Map<String, dynamic>) {
              groupListener?.groupMemberDeleted(GroupMembersInfo.fromJson(u));
            }
          }
        }

      case 1509: // memberInvited
        final invitedList = detail['invitedUserList'] as List?;
        final isSelf =
            invitedList?.any((u) => (u as Map<String, dynamic>)['userID'] == _userID) ?? false;
        if (isSelf) {
          _syncJoinedGroups();
        }
        if (invitedList != null) {
          for (final u in invitedList) {
            if (u is Map<String, dynamic>) {
              groupListener?.groupMemberAdded(GroupMembersInfo.fromJson(u));
            }
          }
        }

      case 1510: // memberEnter
        final entrantUserID =
            (detail['entrantUser'] as Map<String, dynamic>?)?['userID'] as String?;
        if (entrantUserID == _userID) {
          _syncJoinedGroups();
        }
        if (detail['entrantUser'] != null) {
          groupListener?.groupMemberAdded(
            GroupMembersInfo.fromJson(detail['entrantUser'] as Map<String, dynamic>),
          );
        }

      case 1511: // groupDismissed
        _syncJoinedGroups();
        if (detail['group'] != null) {
          groupListener?.groupDismissed(
            GroupInfo.fromJson(detail['group'] as Map<String, dynamic>),
          );
        }

      case 1512: // groupMemberMuted
      case 1513: // groupMemberCancelMuted
      case 1514: // groupMuted
      case 1515: // groupCancelMuted
      case 1516: // groupMemberInfoSet
      case 1517: // groupMemberSetToAdmin
      case 1518: // groupMemberSetToOrdinaryUser
        _syncJoinedGroups();
        if (detail['group'] != null) {
          groupListener?.groupInfoChanged(
            GroupInfo.fromJson(detail['group'] as Map<String, dynamic>),
          );
        }
        if (detail['changedUser'] != null) {
          groupListener?.groupMemberInfoChanged(
            GroupMembersInfo.fromJson(detail['changedUser'] as Map<String, dynamic>),
          );
        }
        if (detail['mutedUser'] != null) {
          groupListener?.groupMemberInfoChanged(
            GroupMembersInfo.fromJson(detail['mutedUser'] as Map<String, dynamic>),
          );
        }

      case 1519: // groupInfoSetAnnouncement
      case 1520: // groupInfoSetName
        _syncJoinedGroups();
        if (detail['group'] != null) {
          groupListener?.groupInfoChanged(
            GroupInfo.fromJson(detail['group'] as Map<String, dynamic>),
          );
        }
    }
  }

  // ---------------------------------------------------------------------------
  // Conversation notifications
  // ---------------------------------------------------------------------------

  void _onConversationChanged(Map<String, dynamic> detail) {
    // 服务端会话设置变更 → 重新同步会话
    _syncConversations();
  }

  void _onConversationPrivateChat(Map<String, dynamic> detail) {
    _syncConversations();
  }

  // ---------------------------------------------------------------------------
  // Message-level notifications
  // ---------------------------------------------------------------------------

  void _onBusinessNotification(Map<String, dynamic> detail) {
    final detailStr = detail['detail'] as String? ?? jsonEncode(detail);
    customBusinessListener?.recvCustomBusinessMessage(detailStr);
  }

  void _onRevokeMsg(Map<String, dynamic> detail) {
    final clientMsgID = detail['clientMsgID'] as String?;
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
  }

  void _onReadReceipt(Map<String, dynamic> detail) {
    final conversationID = detail['conversationID'] as String?;
    final hasReadSeq = detail['hasReadSeq'] as int?;
    if (conversationID != null && hasReadSeq != null) {
      database.updateConversation(conversationID, {'hasReadSeq': hasReadSeq});
    }

    final receipts = <ReadReceiptInfo>[
      ReadReceiptInfo(
        userID: detail['markAsReadUserID'] as String?,
        msgIDList: ((detail['seqs'] as List?) ?? []).map((e) => e.toString()).toList(),
        readTime: detail['readTime'] as int?,
      ),
    ];
    msgListener?.recvC2CReadReceipt(receipts);
  }

  // ---------------------------------------------------------------------------
  // 解析工具
  // ---------------------------------------------------------------------------

  /// 从通知 content 中提取 detail JSON
  ///
  /// Go SDK 的 content 是 NotificationElem 的 JSON: {"detail":"..."}
  /// detail 字段本身是 JSON string（特定 Tips 结构）
  Map<String, dynamic>? _extractDetail(String content) {
    if (content.isEmpty) return null;

    try {
      final map = jsonDecode(content) as Map<String, dynamic>;
      final detailStr = map['detail'] as String?;
      if (detailStr != null && detailStr.isNotEmpty) {
        return jsonDecode(detailStr) as Map<String, dynamic>;
      }
      // 原始 map 可能本身就是 detail
      return map;
    } catch (_) {
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // 同步辅助 (异步执行，不阻塞通知分发)
  // ---------------------------------------------------------------------------

  Future<void> _syncFriends() async {
    try {
      int pageNumber = 1;
      const pageSize = 100;
      while (true) {
        final resp = await api.getFriendList(
          userID: _userID,
          offset: (pageNumber - 1) * pageSize,
          count: pageSize,
        );
        if (resp.errCode != 0) break;
        final friends = resp.data?['friendsInfo'] as List? ?? [];
        if (friends.isEmpty) break;
        final batch = <Map<String, dynamic>>[];
        for (final f in friends) {
          if (f is Map<String, dynamic>) {
            final friendUser = f['friendUser'] as Map<String, dynamic>? ?? {};
            batch.add({
              'friendUserID': friendUser['userID'] ?? f['userID'],
              'ownerUserID': f['ownerUserID'],
              'nickname': friendUser['nickname'],
              'faceURL': friendUser['faceURL'],
              'remark': f['remark'],
              'createTime': f['createTime'],
              'addSource': f['addSource'],
              'operatorUserID': f['operatorUserID'],
              'ex': f['ex'],
              'isPinned': f['isPinned'],
            });
          }
        }
        if (batch.isNotEmpty) await database.batchUpsertFriends(batch);
        if (friends.length < pageSize) break;
        pageNumber++;
      }
    } catch (e) {
      _log.warning('同步好友异常: $e');
    }
  }

  Future<void> _syncBlackList() async {
    // 黑名单量一般较少，全量拉取
    try {
      final resp = await api.getBlackList(userID: _userID);
      if (resp.errCode != 0) return;
      final blacks = resp.data?['blacks'] as List? ?? [];
      final batch = <Map<String, dynamic>>[];
      for (final b in blacks) {
        if (b is Map<String, dynamic>) {
          batch.add(b);
        }
      }
      if (batch.isNotEmpty) {
        await database.batchUpsertBlacks(batch);
      }
    } catch (e) {
      _log.warning('同步黑名单异常: $e');
    }
  }

  Future<void> _syncJoinedGroups() async {
    try {
      int pageNumber = 1;
      const pageSize = 100;
      while (true) {
        final resp = await api.getJoinedGroupList(
          fromUserID: _userID,
          offset: (pageNumber - 1) * pageSize,
          count: pageSize,
        );
        if (resp.errCode != 0) break;
        final groups = resp.data?['groups'] as List? ?? [];
        if (groups.isEmpty) break;
        final batch = <Map<String, dynamic>>[];
        for (final g in groups) {
          if (g is Map<String, dynamic>) batch.add(g);
        }
        if (batch.isNotEmpty) await database.batchUpsertGroups(batch);
        if (groups.length < pageSize) break;
        pageNumber++;
      }
    } catch (e) {
      _log.warning('同步群组异常: $e');
    }
  }

  Future<void> _syncSelfUserInfo() async {
    try {
      final resp = await api.getUsersInfo(userIDs: [_userID]);
      if (resp.errCode != 0) return;
      final users = resp.data?['usersInfo'] as List? ?? [];
      if (users.isNotEmpty && users.first is Map<String, dynamic>) {
        await database.insertOrUpdateUser(users.first as Map<String, dynamic>);
        final updated = await database.getLoginUser();
        if (updated != null) {
          userListener?.selfInfoUpdated(updated);
        }
      }
    } catch (e) {
      _log.warning('同步用户信息异常: $e');
    }
  }

  Future<void> _syncConversations() async {
    try {
      final resp = await api.getAllConversations(ownerUserID: _userID);
      if (resp.errCode != 0) return;
      final conversations = resp.data?['conversations'] as List? ?? [];
      final convMaps = <Map<String, dynamic>>[];
      for (final conv in conversations) {
        if (conv is Map<String, dynamic>) {
          final map = Map<String, dynamic>.from(conv);
          if (map['latestMsg'] is Map) {
            map['latestMsg'] = jsonEncode(map['latestMsg']);
          }
          convMaps.add(map);
        }
      }
      if (convMaps.isNotEmpty) {
        await database.batchUpsertConversations(convMaps);
        // 通知 UI 刷新
        final ids = convMaps
            .map((c) => c['conversationID'] as String?)
            .where((id) => id != null)
            .cast<String>()
            .toList();
        if (ids.isNotEmpty) {
          final convList = <ConversationInfo>[];
          for (final id in ids) {
            final conv = await database.getConversation(id);
            if (conv != null) convList.add(conv);
          }
          if (convList.isNotEmpty) {
            conversationListener?.conversationChanged(convList);
          }
        }
      }
    } catch (e) {
      _log.warning('同步会话异常: $e');
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
}

import 'dart:async';
import 'dart:convert';

import 'package:logging/logging.dart';
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
  bool _groupSyncPending = false;
  bool _conversationSyncPending = false;

  static const _syncDebounce = Duration(milliseconds: 200);

  /// 防抖触发好友同步（多条好友通知合并为一次同步）
  void _debounceSyncFriends() {
    _friendSyncPending = true;
    _friendSyncTimer?.cancel();
    _friendSyncTimer = Timer(_syncDebounce, () {
      if (_friendSyncPending) {
        _friendSyncPending = false;
        _syncFriends();
      }
    });
  }

  /// 防抖触发群组同步
  void _debounceSyncJoinedGroups() {
    _groupSyncPending = true;
    _groupSyncTimer?.cancel();
    _groupSyncTimer = Timer(_syncDebounce, () {
      if (_groupSyncPending) {
        _groupSyncPending = false;
        _syncJoinedGroups();
      }
    });
  }

  /// 防抖触发会话同步
  void _debounceSyncConversations() {
    _conversationSyncPending = true;
    _conversationSyncTimer?.cancel();
    _conversationSyncTimer = Timer(_syncDebounce, () {
      if (_conversationSyncPending) {
        _conversationSyncPending = false;
        _syncConversations();
      }
    });
  }

  void setLoginUserID(String userID) {
    _userID = userID;
  }

  /// 取消所有防抖 Timer，释放资源（登出时调用）
  void dispose() {
    _friendSyncTimer?.cancel();
    _friendSyncTimer = null;
    _groupSyncTimer?.cancel();
    _groupSyncTimer = null;
    _conversationSyncTimer?.cancel();
    _conversationSyncTimer = null;
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
    _log.fine('FriendNotification: contentType=$ct, detail=$detail');
    switch (ct) {
      case 1201: // friendApplicationApproved
        _debounceSyncFriends();
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
        _syncFriendsAndNotifyChanged(detail);

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
        _syncFriendsAndNotifyChanged(detail);

      case 1210: // friendsInfoUpdate
        _syncFriendsAndNotifyChanged(detail);
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
        _syncJoinedGroupsAndNotifyAdded();

      case 1502: // groupInfoSet
        _debounceSyncJoinedGroups();
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
        final quitUser = detail['quitUser'] as Map<String, dynamic>?;
        final quitUserID = quitUser?['userID'] as String?;
        if (quitUserID == _userID) {
          _syncJoinedGroupsAndNotifyDeleted(detail);
        }
        if (quitUser != null) {
          final gid = detail['group'] is Map
              ? (detail['group'] as Map)['groupID'] as String?
              : null;
          if (gid != null && quitUserID != null) {
            database.deleteGroupMember(gid, quitUserID);
          }
          groupListener?.groupMemberDeleted(GroupMembersInfo.fromJson(quitUser));
        }

      case 1505: // groupApplicationAccepted
        _syncJoinedGroupsAndNotifyAdded();
        final info = GroupApplicationInfo.fromJson(detail);
        groupListener?.groupApplicationAccepted(info);
        listenerForService?.groupApplicationAccepted(info);

      case 1506: // groupApplicationRejected
        final info = GroupApplicationInfo.fromJson(detail);
        groupListener?.groupApplicationRejected(info);

      case 1507: // groupOwnerTransferred
        _debounceSyncJoinedGroups();
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
          _syncJoinedGroupsAndNotifyDeleted(detail);
        }
        if (kickedList != null) {
          final gid = detail['group'] is Map
              ? (detail['group'] as Map)['groupID'] as String?
              : null;
          for (final u in kickedList) {
            if (u is Map<String, dynamic>) {
              if (gid != null && u['userID'] != null) {
                database.deleteGroupMember(gid, u['userID'] as String);
              }
              groupListener?.groupMemberDeleted(GroupMembersInfo.fromJson(u));
            }
          }
        }

      case 1509: // memberInvited
        final invitedList = detail['invitedUserList'] as List?;
        final isSelf =
            invitedList?.any((u) => (u as Map<String, dynamic>)['userID'] == _userID) ?? false;
        if (isSelf) {
          _syncJoinedGroupsAndNotifyAdded();
        }
        if (invitedList != null) {
          for (final u in invitedList) {
            if (u is Map<String, dynamic>) {
              database.upsertGroupMember(u);
              groupListener?.groupMemberAdded(GroupMembersInfo.fromJson(u));
            }
          }
        }

      case 1510: // memberEnter
        final entrantUser = detail['entrantUser'] as Map<String, dynamic>?;
        final entrantUserID = entrantUser?['userID'] as String?;
        if (entrantUserID == _userID) {
          _syncJoinedGroupsAndNotifyAdded();
        }
        if (entrantUser != null) {
          database.upsertGroupMember(entrantUser);
          groupListener?.groupMemberAdded(GroupMembersInfo.fromJson(entrantUser));
        }

      case 1511: // groupDismissed
        if (detail['group'] != null) {
          final groupMap = detail['group'] as Map<String, dynamic>;
          final gid = groupMap['groupID'] as String?;
          if (gid != null) {
            database.deleteGroupAllMembers(gid);
            database.deleteGroup(gid);
            final convID = OpenImUtils.genGroupConversationID(gid);
            database.updateConversation(convID, {'isNotInGroup': true});
          }
          groupListener?.groupDismissed(GroupInfo.fromJson(groupMap));
        }

      case 1512: // groupMemberMuted
      case 1513: // groupMemberCancelMuted
      case 1514: // groupMuted
      case 1515: // groupCancelMuted
      case 1516: // groupMemberInfoSet
      case 1517: // groupMemberSetToAdmin
      case 1518: // groupMemberSetToOrdinaryUser
        _debounceSyncJoinedGroups();
        if (detail['group'] != null) {
          groupListener?.groupInfoChanged(
            GroupInfo.fromJson(detail['group'] as Map<String, dynamic>),
          );
        }
        if (detail['changedUser'] != null) {
          final changedUser = detail['changedUser'] as Map<String, dynamic>;
          database.upsertGroupMember(changedUser);
          groupListener?.groupMemberInfoChanged(GroupMembersInfo.fromJson(changedUser));
        }
        if (detail['mutedUser'] != null) {
          final mutedUser = detail['mutedUser'] as Map<String, dynamic>;
          database.upsertGroupMember(mutedUser);
          groupListener?.groupMemberInfoChanged(GroupMembersInfo.fromJson(mutedUser));
        }

      case 1519: // groupInfoSetAnnouncement
      case 1520: // groupInfoSetName
        _debounceSyncJoinedGroups();
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
    _debounceSyncConversations();
  }

  void _onConversationPrivateChat(Map<String, dynamic> detail) {
    _debounceSyncConversations();
  }

  // ---------------------------------------------------------------------------
  // Message-level notifications
  // ---------------------------------------------------------------------------

  void _onBusinessNotification(Map<String, dynamic> detail) {
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
  }

  void _onMomentOrFavoriteNotification(String key, String dataStr) {
    try {
      final data = jsonDecode(dataStr) as Map<String, dynamic>;
      if (key.startsWith('moment_')) {
        momentsManager.handleNotification(key, data);
      } else if (key.startsWith('favorite_')) {
        favoriteManager.handleNotification(key, data);
      }
    } catch (e) {
      _log.warning('解析 moment/favorite 通知失败: key=$key, error=$e');
    }
  }

  void _onRevokeMsg(Map<String, dynamic> detail) {
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
  }

  /// 撤回通知后检查并更新 latestMsg
  Future<void> _updateConversationIfLatestMsgRevoked(
    String conversationID,
    String clientMsgID,
  ) async {
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
    } catch (_) {}
  }

  void _onReadReceipt(Map<String, dynamic> detail) {
    final conversationID = detail['conversationID'] as String?;
    final hasReadSeq = detail['hasReadSeq'] as int?;
    final markAsReadUserID = detail['markAsReadUserID'] as String?;
    final seqs = (detail['seqs'] as List?)?.map((e) => e as int).toList() ?? [];

    if (conversationID != null && hasReadSeq != null) {
      database.updateConversation(conversationID, {'hasReadSeq': hasReadSeq});
    }

    if (markAsReadUserID != _userID) {
      // 对方已读：触发 OnRecvC2CReadReceipt + 更新 latestMsg 已读状态
      final receipts = <ReadReceiptInfo>[
        ReadReceiptInfo(
          userID: markAsReadUserID,
          msgIDList: seqs.map((e) => e.toString()).toList(),
          readTime: detail['readTime'] as int?,
        ),
      ];
      msgListener?.recvC2CReadReceipt(receipts);
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
  }

  /// 对方已读后更新会话（latestMsg 的 isRead 状态）
  Future<void> _updateConversationAfterReadReceipt(String conversationID) async {
    try {
      final conv = await database.getConversation(conversationID);
      if (conv == null) return;
      // 触发 conversationChanged 让 UI 更新已读状态
      conversationListener?.conversationChanged([conv]);
    } catch (_) {}
  }

  /// 自己在其他设备标记已读的处理（对应 Go SDK doUnreadCount）
  Future<void> _handleSelfReadReceipt(String conversationID, int hasReadSeq, List<int> seqs) async {
    try {
      final conv = await database.getConversation(conversationID);
      if (conv == null) return;
      if (conv.unreadCount > 0) {
        await database.clearConversationUnreadCount(conversationID);
      }
      conversationListener?.conversationChanged([
        await database.getConversation(conversationID) ?? conv,
      ]);
      final total = await database.getTotalUnreadCount();
      conversationListener?.totalUnreadMessageCountChanged(total);
    } catch (_) {}
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
      final allFriends = <Map<String, dynamic>>[];
      while (true) {
        final resp = await api.getFriendList(
          userID: _userID,
          offset: (pageNumber - 1) * pageSize,
          count: pageSize,
        );
        if (resp.errCode != 0) break;
        final friends = resp.data?['friendsInfo'] as List? ?? [];
        if (friends.isEmpty) break;
        for (final f in friends) {
          if (f is Map<String, dynamic>) {
            final friendUser = f['friendUser'] as Map<String, dynamic>? ?? {};
            allFriends.add({
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
        if (friends.length < pageSize) break;
        pageNumber++;
      }
      if (allFriends.isNotEmpty) await database.batchUpsertFriends(allFriends);
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
      final allGroups = <Map<String, dynamic>>[];
      while (true) {
        final resp = await api.getJoinedGroupList(
          fromUserID: _userID,
          offset: (pageNumber - 1) * pageSize,
          count: pageSize,
        );
        if (resp.errCode != 0) break;
        final groups = resp.data?['groups'] as List? ?? [];
        if (groups.isEmpty) break;
        for (final g in groups) {
          if (g is Map<String, dynamic>) allGroups.add(g);
        }
        if (groups.length < pageSize) break;
        pageNumber++;
      }
      if (allGroups.isNotEmpty) await database.batchUpsertGroups(allGroups);

      // 同步每个群的成员列表
      for (final group in allGroups) {
        final groupID = group['groupID'] as String?;
        if (groupID == null || groupID.isEmpty) continue;
        await _syncGroupMembersForGroup(groupID);
      }
    } catch (e) {
      _log.warning('同步群组异常: $e');
    }
  }

  /// 从服务器同步指定群组的所有成员到本地数据库
  Future<void> _syncGroupMembersForGroup(String groupID) async {
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
    } catch (e) {
      _log.warning('同步群[$groupID]成员异常: $e');
    }
  }

  Future<void> _syncSelfUserInfo() async {
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
      }
      if (convMaps.isNotEmpty) {
        // 对已存在的会话，保留本地 unreadCount，防止服务端过时数据覆盖
        // 导致 markAsRead → syncConversations → unread>0 → markAsRead 死循环
        final existingIds = <String>{};
        for (final map in convMaps) {
          final id = map['conversationID'] as String?;
          if (id != null) {
            final local = await database.getConversation(id);
            if (local != null) {
              existingIds.add(id);
              map.remove('unreadCount');
            }
          }
        }

        await database.batchUpsertConversations(convMaps);
        // 通知 UI 刷新（批量读取代替逐个查询）
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

  // ---------------------------------------------------------------------------
  // 带回调通知的同步方法
  // ---------------------------------------------------------------------------

  /// 同步好友并对比变更，触发 OnFriendInfoChanged
  ///
  /// 对应 Go SDK 的 IncrSyncFriends → syncer.Update → OnFriendInfoChanged
  Future<void> _syncFriendsAndNotifyChanged(Map<String, dynamic> detail) async {
    // 提取变更用户 ID
    final fromTo = detail['fromToUserID'] as Map<String, dynamic>?;
    final userID = detail['userID'] as String?;
    final changedUserID = fromTo?['toUserID'] as String? ?? userID;

    await _syncFriends();

    // 同步完成后用最新数据通知
    if (changedUserID != null && changedUserID.isNotEmpty) {
      final updated = await database.getFriendByUserID(changedUserID);
      if (updated != null) {
        friendshipListener?.friendInfoChanged(updated);
      }
    }
  }

  /// 同步已加入群组并通知新增群（自己加入了新群）
  ///
  /// 对应 Go SDK 的 IncrSyncJoinGroup → syncer.Insert → OnJoinedGroupAdded
  Future<void> _syncJoinedGroupsAndNotifyAdded() async {
    final oldGroupIDs = (await database.getJoinedGroupList()).map((g) => g.groupID).toSet();
    await _syncJoinedGroups();
    final newGroups = await database.getJoinedGroupList();
    for (final g in newGroups) {
      if (!oldGroupIDs.contains(g.groupID)) {
        groupListener?.joinedGroupAdded(g);
      }
    }
  }

  /// 处理自己退出/被踢出群的本地数据清理与通知
  ///
  /// 直接从 detail 中提取 groupID，做针对性的本地删除，
  /// 避免全量同步所有群组和成员导致的大量 unique constraint 警告。
  Future<void> _syncJoinedGroupsAndNotifyDeleted(Map<String, dynamic> detail) async {
    final groupMap = detail['group'] as Map<String, dynamic>?;
    final groupID = groupMap?['groupID'] as String?;
    if (groupID == null || groupID.isEmpty) return;

    // 获取群信息用于回调通知
    final groupInfo = await database.getGroupByID(groupID);

    // 本地删除群成员、群组
    await database.deleteGroupAllMembers(groupID);
    await database.deleteGroup(groupID);

    // 更新会话的 isNotInGroup 字段并通知 UI
    final convID = OpenImUtils.genGroupConversationID(groupID);
    await database.updateConversation(convID, {'isNotInGroup': true});
    final conv = await database.getConversation(convID);
    if (conv != null) {
      conversationListener?.conversationChanged([conv]);
    }

    groupListener?.joinedGroupDeleted(groupInfo ?? GroupInfo(groupID: groupID));
  }
}

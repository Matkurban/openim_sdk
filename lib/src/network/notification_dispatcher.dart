import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:openim_sdk/src/services/database_service.dart';

/// 通知消息分发器
///
/// 对应 Go SDK 的 notification.go Work()，负责：
/// - 按 contentType 路由通知消息
/// - 解析通知体并触发对应监听器回调
/// - 同步本地数据库
class NotificationDispatcher {
  final _log = Logger('NotificationDispatcher');

  // ---- 数据库引用 ----
  DatabaseService? _db;

  // ---- Manager 引用（通过 Manager 动态获取监听器，避免快照失效） ----
  FriendshipManager? _friendshipManager;
  GroupManager? _groupManager;
  ConversationManager? _conversationManager;
  MessageManager? _messageManager;
  UserManager? _userManager;
  OnListenerForService? listenerForService;

  // 动态获取当前有效监听器
  OnFriendshipListener? get friendshipListener => _friendshipManager?.listener;
  OnGroupListener? get groupListener => _groupManager?.listener;
  OnConversationListener? get conversationListener =>
      _conversationManager?.listener;
  OnAdvancedMsgListener? get advancedMsgListener =>
      _messageManager?.msgListener;
  OnUserListener? get userListener => _userManager?.listener;
  OnCustomBusinessListener? get customBusinessListener =>
      _messageManager?.customBusinessListener;

  NotificationDispatcher();

  /// 绑定 Manager 引用和数据库
  void bindManagers({
    required FriendshipManager friendshipManager,
    required GroupManager groupManager,
    required ConversationManager conversationManager,
    required MessageManager messageManager,
    required UserManager userManager,
    DatabaseService? db,
  }) {
    _friendshipManager = friendshipManager;
    _groupManager = groupManager;
    _conversationManager = conversationManager;
    _messageManager = messageManager;
    _userManager = userManager;
    _db = db;
  }

  // ---------------------------------------------------------------------------
  // 消息分发入口
  // ---------------------------------------------------------------------------

  /// 分发收到的消息/通知
  ///
  /// [msg] 原始消息 Map（来自 WebSocket 推送或本地拉取）
  void dispatch(Map<String, dynamic> msg) {
    final contentType = msg['contentType'] as int? ?? 0;

    // contentType < 1000 为普通用户消息
    if (contentType < 1000) {
      _dispatchUserMessage(msg, contentType);
      return;
    }

    // contentType >= 1000 为系统通知
    _dispatchNotification(msg, contentType);
  }

  // ---------------------------------------------------------------------------
  // 普通消息
  // ---------------------------------------------------------------------------

  /// 将服务端原始消息 Map 规范化为 Message.fromJson 可解析的格式。
  ///
  /// 服务端消息的内容存放在 `content` 字段（JSON 字符串 或 base64 编码的 JSON 字符串），
  /// 而 Message.fromJson（json_serializable 自动生成）期望找到对应 elem 的子对象字段
  /// （如 `customElem`、`textElem` 等）。
  /// 此方法负责把 `content` 解析后注入到正确的 elem 字段，避免 null 检查崩溃。
  Map<String, dynamic> _normalizeServerMessage(
    Map<String, dynamic> msg,
    int contentType,
  ) {
    // 确定目标 elem 字段名
    final elemKey = _contentTypeToElemKey(contentType);
    if (elemKey == null) return msg;
    // 已经有对应 elem 字段时，无需处理
    if (msg[elemKey] != null) return msg;

    final rawContent = msg['content'] as String?;
    if (rawContent == null || rawContent.isEmpty) return msg;

    Map<String, dynamic>? contentMap;
    // 尝试直接 JSON 解析
    try {
      contentMap = jsonDecode(rawContent) as Map<String, dynamic>;
    } catch (_) {}
    // 兜底：base64 → UTF-8 → JSON
    if (contentMap == null) {
      try {
        final decoded = utf8.decode(base64Decode(rawContent));
        contentMap = jsonDecode(decoded) as Map<String, dynamic>;
      } catch (_) {}
    }

    if (contentMap == null) return msg;
    return {...msg, elemKey: contentMap};
  }

  /// content type → Message.fromJson 期望的 elem 字段名映射
  String? _contentTypeToElemKey(int contentType) {
    switch (contentType) {
      case 101:
        return 'textElem';
      case 102:
        return 'pictureElem';
      case 103:
        return 'soundElem';
      case 104:
        return 'videoElem';
      case 105:
        return 'fileElem';
      case 106:
        return 'atTextElem';
      case 107:
        return 'mergeElem';
      case 108:
        return 'cardElem';
      case 109:
        return 'locationElem';
      case 110:
        return 'customElem';
      case 114:
        return 'quoteElem';
      case 115:
        return 'faceElem';
      case 117:
        return 'advancedTextElem';
      case 119:
      case 120:
        return 'customElem';
      default:
        return null;
    }
  }

  void _dispatchUserMessage(Map<String, dynamic> msg, int contentType) {
    try {
      final normalized = _normalizeServerMessage(msg, contentType);
      final message = Message.fromJson(normalized);

      // 通知消息监听器
      advancedMsgListener?.recvNewMessage(message);

      // 通知服务监听器
      listenerForService?.recvNewMessage(message);
    } catch (e) {
      _log.warning('分发用户消息失败: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // 系统通知分发
  // ---------------------------------------------------------------------------

  void _dispatchNotification(Map<String, dynamic> msg, int contentType) {
    // 解析通知体中的 detail JSON（content 可能是 JSON 字符串或 base64 编码的 JSON 字符串）
    final rawContent = msg['content'] as String? ?? '{}';
    Map<String, dynamic> detail;
    Map<String, dynamic>? parsed;
    try {
      parsed = jsonDecode(rawContent) as Map<String, dynamic>;
    } catch (_) {}
    if (parsed == null) {
      try {
        final decoded = utf8.decode(base64Decode(rawContent));
        parsed = jsonDecode(decoded) as Map<String, dynamic>;
      } catch (_) {}
    }
    detail = parsed ?? {};

    switch (contentType) {
      // ---- Friend 通知 (1200-1299) ----
      case 1201: // FriendApplicationApproved
        _onFriendApplicationChanged(detail, accepted: true);
      case 1202: // FriendApplicationRejected
        _onFriendApplicationChanged(detail, accepted: false);
      case 1203: // FriendApplication
        _onFriendApplicationAdded(detail);
      case 1204: // FriendAdded
        _onFriendAdded(detail);
      case 1205: // FriendDeleted
        _onFriendDeleted(detail);
      case 1206: // FriendRemarkSet
        _onFriendInfoChanged(detail);
      case 1207: // BlackAdded
        _onBlackAdded(detail);
      case 1208: // BlackDeleted
        _onBlackDeleted(detail);
      case 1209: // FriendInfoUpdated
      case 1210: // FriendsInfoUpdate
        _onFriendInfoChanged(detail);

      // ---- User 通知 (1301-1399) ----
      case 1303: // UserInfoUpdated
        _onSelfInfoUpdated(detail);
      case 1304: // UserStatusChange
        _onUserStatusChanged(detail);

      // ---- Conversation 通知 (1300) ----
      case 1300: // ConversationChange
        _onConversationChanged(detail);

      // ---- OA 通知 (1400) ----
      case 1400: // OANotification
        _dispatchUserMessage(msg, contentType);

      // ---- Group 通知 (1500-1599) ----
      case 1501: // GroupCreated
        _onJoinedGroupAdded(detail);
      case 1502: // GroupInfoSet
      case 1519: // GroupInfoSetAnnouncement
      case 1520: // GroupInfoSetName
        _onGroupInfoChanged(detail);
      case 1503: // JoinGroupApplication
        _onGroupApplicationAdded(detail);
      case 1504: // MemberQuit
        _onGroupMemberDeleted(detail);
      case 1505: // GroupApplicationAccepted
        _onGroupApplicationAccepted(detail);
      case 1506: // GroupApplicationRejected
        _onGroupApplicationRejected(detail);
      case 1507: // GroupOwnerTransferred
        _onGroupInfoChanged(detail);
      case 1508: // MemberKicked
        _onGroupMemberDeleted(detail);
      case 1509: // MemberInvited
        _onGroupMemberAdded(detail);
      case 1510: // MemberEnter
        _onGroupMemberAdded(detail);
      case 1511: // GroupDismissed
        _onGroupDismissed(detail);
      case 1512: // GroupMemberMuted
        _onGroupMemberInfoChanged(detail);
      case 1513: // GroupMemberCancelMuted
        _onGroupMemberInfoChanged(detail);
      case 1514: // GroupMuted
        _onGroupInfoChanged(detail);
      case 1515: // GroupCancelMuted
        _onGroupInfoChanged(detail);
      case 1516: // GroupMemberInfoSet
      case 1517: // GroupMemberSetToAdmin
      case 1518: // GroupMemberSetToOrdinaryUser
        _onGroupMemberInfoChanged(detail);

      // ---- Conversation Private Chat (1701) ----
      case 1701: // ConversationPrivateChat
        _onConversationChanged(detail);
      case 1703: // ClearConversation
        _onConversationChanged(detail);

      // ---- Business Notification (2001) ----
      case 2001:
        _onCustomBusinessMessage(msg);

      // ---- Message 通知 ----
      case 2101: // Revoke
        _onMsgRevoked(detail);
      case 2102: // DeleteMsgs
        _onMsgDeleted(detail);

      // ---- 已读回执 ----
      case 2200: // HasReadReceipt
        _onRecvReadReceipt(detail);

      default:
        _log.fine('未处理的通知类型: $contentType');
    }
  }

  // ---------------------------------------------------------------------------
  // Friend 事件
  // ---------------------------------------------------------------------------

  void _onFriendApplicationAdded(Map<String, dynamic> detail) {
    try {
      final info = FriendApplicationInfo.fromJson(_extractFromDetail(detail));
      friendshipListener?.friendApplicationAdded(info);
      listenerForService?.friendApplicationAdded(info);
    } catch (e) {
      _log.warning('处理好友申请通知失败: $e');
    }
  }

  void _onFriendApplicationChanged(
    Map<String, dynamic> detail, {
    required bool accepted,
  }) {
    try {
      final info = FriendApplicationInfo.fromJson(_extractFromDetail(detail));
      if (accepted) {
        friendshipListener?.friendApplicationAccepted(info);
        listenerForService?.friendApplicationAccepted(info);
      } else {
        friendshipListener?.friendApplicationRejected(info);
      }
    } catch (e) {
      _log.warning('处理好友申请变更通知失败: $e');
    }
  }

  void _onFriendAdded(Map<String, dynamic> detail) {
    try {
      final data = _extractFromDetail(detail);
      final info = FriendInfo.fromJson(data);
      // 同步到本地 DB
      _db?.upsertFriend(data);
      friendshipListener?.friendAdded(info);
    } catch (e) {
      _log.warning('处理好友添加通知失败: $e');
    }
  }

  void _onFriendDeleted(Map<String, dynamic> detail) {
    try {
      final data = _extractFromDetail(detail);
      final info = FriendInfo.fromJson(data);
      // 从本地 DB 删除
      final uid = info.userID;
      if (uid != null && uid.isNotEmpty) {
        _db?.deleteFriend(uid);
      }
      friendshipListener?.friendDeleted(info);
    } catch (e) {
      _log.warning('处理好友删除通知失败: $e');
    }
  }

  void _onFriendInfoChanged(Map<String, dynamic> detail) {
    try {
      final data = _extractFromDetail(detail);
      final info = FriendInfo.fromJson(data);
      // 同步到本地 DB
      _db?.upsertFriend(data);
      friendshipListener?.friendInfoChanged(info);
    } catch (e) {
      _log.warning('处理好友信息变更通知失败: $e');
    }
  }

  void _onBlackAdded(Map<String, dynamic> detail) {
    try {
      final info = BlacklistInfo.fromJson(_extractFromDetail(detail));
      friendshipListener?.blackAdded(info);
    } catch (e) {
      _log.warning('处理黑名单添加通知失败: $e');
    }
  }

  void _onBlackDeleted(Map<String, dynamic> detail) {
    try {
      final info = BlacklistInfo.fromJson(_extractFromDetail(detail));
      friendshipListener?.blackDeleted(info);
    } catch (e) {
      _log.warning('处理黑名单删除通知失败: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // User 事件
  // ---------------------------------------------------------------------------

  void _onSelfInfoUpdated(Map<String, dynamic> detail) {
    try {
      final data = _extractFromDetail(detail);
      final info = UserInfo.fromJson(data);
      // 同步到本地 DB
      _db?.insertOrUpdateUser(data);
      userListener?.selfInfoUpdated(info);
    } catch (e) {
      _log.warning('处理用户信息更新通知失败: $e');
    }
  }

  void _onUserStatusChanged(Map<String, dynamic> detail) {
    try {
      final info = UserStatusInfo.fromJson(_extractFromDetail(detail));
      userListener?.userStatusChanged(info);
    } catch (e) {
      _log.warning('处理用户状态变更通知失败: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // Conversation 事件
  // ---------------------------------------------------------------------------

  void _onConversationChanged(Map<String, dynamic> detail) {
    try {
      // detail 可能包含单个或多个会话
      final List<ConversationInfo> convList;
      if (detail.containsKey('conversationID')) {
        convList = [ConversationInfo.fromJson(detail)];
      } else if (detail.containsKey('conversationList')) {
        convList = (detail['conversationList'] as List)
            .map((e) => ConversationInfo.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        // 可能在 detail 里是 json 字符串
        final extracted = _extractFromDetail(detail);
        if (extracted.containsKey('conversationID')) {
          convList = [ConversationInfo.fromJson(extracted)];
        } else if (extracted is List) {
          convList = (extracted as List)
              .map((e) => ConversationInfo.fromJson(e as Map<String, dynamic>))
              .toList();
        } else {
          convList = [];
        }
      }

      // 同步到本地 DB（对应 Go SDK 的 doNotificationConversation）
      if (_db != null && convList.isNotEmpty) {
        for (final conv in convList) {
          final updates = <String, dynamic>{};
          if (conv.conversationID.isNotEmpty) {
            // 服务端推送的字段直接覆写到本地
            if (conv.recvMsgOpt != null)
              updates['recvMsgOpt'] = conv.recvMsgOpt;
            if (conv.isPinned != null)
              updates['isPinned'] = conv.isPinned! ? 1 : 0;
            if (conv.isPrivateChat != null)
              updates['isPrivateChat'] = conv.isPrivateChat! ? 1 : 0;
            if (conv.burnDuration != null)
              updates['burnDuration'] = conv.burnDuration;
            if (conv.groupAtType != null)
              updates['groupAtType'] = conv.groupAtType;
            if (conv.ex != null) updates['ex'] = conv.ex;
            if (conv.showName != null) updates['showName'] = conv.showName;
            if (conv.faceURL != null) updates['faceURL'] = conv.faceURL;

            if (updates.isNotEmpty) {
              _db!.updateConversation(conv.conversationID, updates);
            }
          }
        }
      }

      if (convList.isNotEmpty) {
        conversationListener?.conversationChanged(convList);
      }
    } catch (e) {
      _log.warning('处理会话变更通知失败: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // Group 事件
  // ---------------------------------------------------------------------------

  void _onJoinedGroupAdded(Map<String, dynamic> detail) {
    try {
      final group = detail['group'] as Map<String, dynamic>?;
      if (group != null) {
        final info = GroupInfo.fromJson(group);
        // 同步到本地 DB
        _db?.upsertGroup(group);
        groupListener?.joinedGroupAdded(info);
      }
    } catch (e) {
      _log.warning('处理入群通知失败: $e');
    }
  }

  void _onGroupDismissed(Map<String, dynamic> detail) {
    try {
      final group = detail['group'] as Map<String, dynamic>?;
      if (group != null) {
        final info = GroupInfo.fromJson(group);
        // 从本地 DB 删除
        final gid = info.groupID;
        if (gid.isNotEmpty) {
          _db?.deleteGroup(gid);
        }
        groupListener?.groupDismissed(info);
        groupListener?.joinedGroupDeleted(info);
      }
    } catch (e) {
      _log.warning('处理群解散通知失败: $e');
    }
  }

  void _onGroupInfoChanged(Map<String, dynamic> detail) {
    try {
      final group = detail['group'] as Map<String, dynamic>?;
      if (group != null) {
        final info = GroupInfo.fromJson(group);
        // 同步到本地 DB
        _db?.upsertGroup(group);
        groupListener?.groupInfoChanged(info);
      }
    } catch (e) {
      _log.warning('处理群信息变更通知失败: $e');
    }
  }

  void _onGroupMemberAdded(Map<String, dynamic> detail) {
    try {
      final memberList =
          detail['invitedUserList'] as List? ??
          detail['memberList'] as List? ??
          [];
      for (final m in memberList) {
        if (m is Map<String, dynamic>) {
          final info = GroupMembersInfo.fromJson(m);
          groupListener?.groupMemberAdded(info);
        }
      }
    } catch (e) {
      _log.warning('处理群成员添加通知失败: $e');
    }
  }

  void _onGroupMemberDeleted(Map<String, dynamic> detail) {
    try {
      final memberList =
          detail['kickedUserList'] as List? ??
          detail['memberList'] as List? ??
          [];
      for (final m in memberList) {
        if (m is Map<String, dynamic>) {
          final info = GroupMembersInfo.fromJson(m);
          groupListener?.groupMemberDeleted(info);
        }
      }
      // 如果是自己被踢或自己退群
      final quitUser = detail['quitUser'] as Map<String, dynamic>?;
      if (quitUser != null) {
        final info = GroupMembersInfo.fromJson(quitUser);
        groupListener?.groupMemberDeleted(info);
      }
    } catch (e) {
      _log.warning('处理群成员删除通知失败: $e');
    }
  }

  void _onGroupMemberInfoChanged(Map<String, dynamic> detail) {
    try {
      final member =
          detail['mutedUser'] as Map<String, dynamic>? ??
          detail['changedUser'] as Map<String, dynamic>? ??
          detail;
      final info = GroupMembersInfo.fromJson(_extractFromDetail(member));
      groupListener?.groupMemberInfoChanged(info);
    } catch (e) {
      _log.warning('处理群成员信息变更通知失败: $e');
    }
  }

  void _onGroupApplicationAdded(Map<String, dynamic> detail) {
    try {
      final info = GroupApplicationInfo.fromJson(_extractFromDetail(detail));
      groupListener?.groupApplicationAdded(info);
      listenerForService?.groupApplicationAdded(info);
    } catch (e) {
      _log.warning('处理入群申请通知失败: $e');
    }
  }

  void _onGroupApplicationAccepted(Map<String, dynamic> detail) {
    try {
      final info = GroupApplicationInfo.fromJson(_extractFromDetail(detail));
      groupListener?.groupApplicationAccepted(info);
      listenerForService?.groupApplicationAccepted(info);
    } catch (e) {
      _log.warning('处理入群申请通过通知失败: $e');
    }
  }

  void _onGroupApplicationRejected(Map<String, dynamic> detail) {
    try {
      final info = GroupApplicationInfo.fromJson(_extractFromDetail(detail));
      groupListener?.groupApplicationRejected(info);
    } catch (e) {
      _log.warning('处理入群申请拒绝通知失败: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // Message 事件
  // ---------------------------------------------------------------------------

  void _onMsgRevoked(Map<String, dynamic> detail) {
    try {
      final info = RevokedInfo.fromJson(_extractFromDetail(detail));
      advancedMsgListener?.newRecvMessageRevoked(info);
    } catch (e) {
      _log.warning('处理消息撤回通知失败: $e');
    }
  }

  void _onMsgDeleted(Map<String, dynamic> detail) {
    try {
      final message = Message.fromJson(_extractFromDetail(detail));
      advancedMsgListener?.msgDeleted(message);
    } catch (e) {
      _log.warning('处理消息删除通知失败: $e');
    }
  }

  void _onRecvReadReceipt(Map<String, dynamic> detail) {
    try {
      final list = (detail['msgReceiptList'] as List? ?? [])
          .map((e) => ReadReceiptInfo.fromJson(e as Map<String, dynamic>))
          .toList();
      if (list.isNotEmpty) {
        advancedMsgListener?.recvC2CReadReceipt(list);
      }
    } catch (e) {
      _log.warning('处理已读回执通知失败: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // Business 事件
  // ---------------------------------------------------------------------------

  void _onCustomBusinessMessage(Map<String, dynamic> msg) {
    final content = msg['content'] as String? ?? '';
    customBusinessListener?.recvCustomBusinessMessage(content);
  }

  // ---------------------------------------------------------------------------
  // 工具方法
  // ---------------------------------------------------------------------------

  /// 从 detail 中提取实际数据
  /// Go SDK 的通知体通常为 {detail: jsonString} 或直接是对象
  Map<String, dynamic> _extractFromDetail(Map<String, dynamic> detail) {
    if (detail.containsKey('detail')) {
      final d = detail['detail'];
      if (d is String) {
        return jsonDecode(d) as Map<String, dynamic>;
      } else if (d is Map<String, dynamic>) {
        return d;
      }
    }
    return detail;
  }
}

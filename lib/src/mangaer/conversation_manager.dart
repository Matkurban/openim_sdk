import 'dart:convert';
import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:openim_sdk/src/config/instance_name.dart';
import 'package:aoiwe_logger/aoiwe_logger.dart';
import 'package:openim_sdk/src/models/web_socket_identifier.dart';
import 'package:openim_sdk/src/services/database_service.dart';
import 'package:openim_sdk/src/services/im_api_service.dart';
import 'package:openim_sdk/src/services/web_socket_service.dart';
import 'package:openim_sdk/src/utils/platform_utils.dart';
import 'package:meta/meta.dart';

class ConversationManager {
  ConversationManager._internal();

  static final ConversationManager _instance = ConversationManager._internal();

  factory ConversationManager() => _instance;

  static final AoiweLogger _log = AoiweLogger('ConversationManager');

  final GetIt _getIt = GetIt.instance;

  /// 防止 markConversationMessageAsRead 重入的守卫集合
  final Set<String> _markingAsRead = {};

  ImApiService get _api {
    return _getIt.get<ImApiService>(instanceName: InstanceName.imApiService);
  }

  DatabaseService get _database {
    return _getIt.get<DatabaseService>(instanceName: InstanceName.databaseService);
  }

  WebSocketService get _webSocketService {
    return _getIt.get<WebSocketService>(instanceName: InstanceName.webSocketService);
  }

  OnConversationListener? listener;

  late String _currentUserID;

  void setConversationListener(OnConversationListener listener) {
    _log.info('设置会话监听器', methodName: 'setConversationListener');
    this.listener = listener;
  }

  @internal
  void setCurrentUserID(String userID) {
    _currentUserID = userID;
  }

  /// 根据会话类型生成会话ID
  /// [sourceID] 单聊为用户ID，群聊为群组ID
  /// [sessionType] 会话类型
  String getConversationIDBySessionType({required String sourceID, required int sessionType}) {
    _log.info(
      'sourceID=$sourceID, sessionType=$sessionType',
      methodName: 'getConversationIDBySessionType',
    );
    try {
      if (sessionType == ConversationType.single.value) {
        return OpenImUtils.genSingleConversationID(_currentUserID, sourceID);
      } else if (sessionType == ConversationType.superGroup.value) {
        return OpenImUtils.genGroupConversationID(sourceID);
      } else {
        return OpenImUtils.genNotificationConversationID(_currentUserID, sourceID);
      }
    } catch (e, s) {
      _log.error(
        e.toString(),
        error: e,
        stackTrace: s,
        methodName: 'getConversationIDBySessionType',
      );
      rethrow;
    }
  }

  /// 获取 @所有人 标识
  String getAtAllTag() {
    _log.info('called', methodName: 'getAtAllTag');
    try {
      return atAllTag;
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getAtAllTag');
      rethrow;
    }
  }

  /// @所有人 标识
  String get atAllTag => 'AtAllTag';

  /// 获取所有会话列表
  Future<List<ConversationInfo>> getAllConversationList() async {
    if (SdkIsolateManager.isActive) {
      final result = await SdkIsolateManager.instance.invoke(
        'conversation.getAllConversationList',
        {},
      );
      return (result as List)
          .map((e) => ConversationInfo.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }
    _log.info('called', methodName: 'getAllConversationList');
    try {
      return await _database.getVisibleConversations();
    } catch (e, s) {
      _log.error(
        '获取所有会话方法发生了异常，返回了空列表。',
        methodName: 'getAllConversationList',
        error: e,
        stackTrace: s,
      );
      return [];
    }
  }

  /// 分页获取会话列表
  /// [offset] 起始索引
  /// [count] 每页数量
  Future<List<ConversationInfo>> getConversationListSplit({int offset = 0, int count = 20}) async {
    if (SdkIsolateManager.isActive) {
      final result = await SdkIsolateManager.instance.invoke(
        'conversation.getConversationListSplit',
        {'offset': offset, 'count': count},
      );
      return (result as List)
          .map((e) => ConversationInfo.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }
    _log.info('offset=$offset, count=$count', methodName: 'getConversationListSplit');
    try {
      return await _database.getConversationsPage(offset, count);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getConversationListSplit');
      rethrow;
    }
  }

  /// 查询会话，如果不存在则创建
  /// [sourceID] 单聊为用户ID，群聊为群组ID
  /// [sessionType] 参考 [ConversationType]
  Future<ConversationInfo> getOneConversation({
    required String sourceID,
    required int sessionType,
  }) async {
    if (SdkIsolateManager.isActive) {
      final result = await SdkIsolateManager.instance.invoke('conversation.getOneConversation', {
        'sourceID': sourceID,
        'sessionType': sessionType,
      });
      return ConversationInfo.fromJson(Map<String, dynamic>.from(result as Map));
    }
    _log.info('sourceID=$sourceID, sessionType=$sessionType', methodName: 'getOneConversation');
    try {
      final conversationID = getConversationIDBySessionType(
        sourceID: sourceID,
        sessionType: sessionType,
      );
      final data = await _database.getConversation(conversationID);
      if (data != null) {
        return data;
      }
      // 不存在则自动创建
      final newConv = <String, dynamic>{
        'conversationID': conversationID,
        'conversationType': sessionType,
        'userID': sessionType == ConversationType.single.value ? sourceID : null,
        'groupID': sessionType != ConversationType.single.value ? sourceID : null,
        'unreadCount': 0,
      };
      await _database.upsertConversation(newConv);
      final created =
          (await _database.getConversation(conversationID)) ??
          ConversationInfo(conversationID: conversationID);

      // 创建会话时也要立刻补齐 showName/faceURL（否则 UI 可能先展示空昵称，重启才刷新）
      final updates = <String, dynamic>{};
      try {
        if (sessionType == ConversationType.superGroup.value ||
            sessionType == ConversationType.superGroup.value) {
          final group = await _database.getGroupByID(sourceID);
          if (group != null) {
            updates['showName'] = group.groupName ?? '';
            updates['faceURL'] = group.faceURL ?? '';
          }
        } else if (sessionType == ConversationType.single.value ||
            sessionType == ConversationType.notification.value) {
          final friend = await _database.getFriendByUserID(sourceID);
          if (friend != null) {
            updates['showName'] = friend.getShowName();
            updates['faceURL'] = friend.faceURL ?? '';
          } else {
            final users = await _database.getUsersByIDs([sourceID]);
            if (users.isNotEmpty) {
              updates['showName'] = users.first.getShowName();
              updates['faceURL'] = users.first.faceURL ?? '';
            }
          }
        }
      } catch (_) {
        // 填充失败不影响创建会话
      }

      if (updates.isNotEmpty) {
        await _database.updateConversation(conversationID, updates);
      }

      final finalCreated = (await _database.getConversation(conversationID)) ?? created;

      // 通知上层：新会话立刻进入列表
      listener?.newConversation([finalCreated]);

      return finalCreated;
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getOneConversation');
      rethrow;
    }
  }

  /// 根据会话ID列表获取多个会话
  /// [conversationIDList] 会话ID列表
  Future<List<ConversationInfo>> getMultipleConversation({
    required List<String> conversationIDList,
  }) async {
    if (SdkIsolateManager.isActive) {
      final result = await SdkIsolateManager.instance.invoke(
        'conversation.getMultipleConversation',
        {'conversationIDList': conversationIDList},
      );
      return (result as List)
          .map((e) => ConversationInfo.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }
    _log.info('conversationIDList=$conversationIDList', methodName: 'getMultipleConversation');
    try {
      return await _database.getMultipleConversations(conversationIDList);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getMultipleConversation');
      rethrow;
    }
  }

  /// 搜索会话
  /// [name] 搜索关键字
  Future<List<ConversationInfo>> searchConversations(String name) async {
    if (SdkIsolateManager.isActive) {
      final result = await SdkIsolateManager.instance.invoke('conversation.searchConversations', {
        'name': name,
      });
      return (result as List)
          .map((e) => ConversationInfo.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }
    _log.info('name=$name', methodName: 'searchConversations');
    try {
      return await _database.searchConversations(name);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'searchConversations');
      rethrow;
    }
  }

  /// 自定义会话列表排序
  /// 置顶会话优先，然后按最新消息时间或草稿时间排序
  List<ConversationInfo> simpleSort(List<ConversationInfo> list) {
    _log.info('called', methodName: 'simpleSort');
    try {
      return list..sort((a, b) {
        if ((a.isPinned == true && b.isPinned == true) ||
            (a.isPinned != true && b.isPinned != true)) {
          final aCompare = (a.draftTextTime ?? 0) > (a.latestMsgSendTime ?? 0)
              ? (a.draftTextTime ?? 0)
              : (a.latestMsgSendTime ?? 0);
          final bCompare = (b.draftTextTime ?? 0) > (b.latestMsgSendTime ?? 0)
              ? (b.draftTextTime ?? 0)
              : (b.latestMsgSendTime ?? 0);
          if (aCompare > bCompare) {
            return -1;
          } else if (aCompare < bCompare) {
            return 1;
          } else {
            return 0;
          }
        } else if (a.isPinned == true && b.isPinned != true) {
          return -1;
        } else {
          return 1;
        }
      });
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'simpleSort');
      rethrow;
    }
  }

  /// 设置会话属性（免打扰、置顶等）
  /// [conversationID] 会话ID
  /// [req] 会话修改请求
  Future<void> setConversation({
    required String conversationID,
    required ConversationReq req,
  }) async {
    if (SdkIsolateManager.isActive) {
      await SdkIsolateManager.instance.invoke('conversation.setConversation', {
        'conversationID': conversationID,
        'req': req.toJson(),
      });
      return;
    }
    _log.info('conversationID=$conversationID, req=$req', methodName: 'setConversation');
    try {
      final updateData = req.toJson()..removeWhere((_, v) => v == null);
      if (updateData.isNotEmpty) {
        await _database.updateConversation(conversationID, updateData);
      }
      _log.info('会话属性已更新: $conversationID', methodName: 'setConversation');
      await _notifyConversationChanged([conversationID]);

      // 同步到服务器
      final resp = await _api.setConversations(
        req: {'userID': _currentUserID, 'conversationID': conversationID, ...updateData},
      );
      if (resp.errCode != 0) {
        _log.warning('同步会话属性到服务器失败: ${resp.errMsg}');
      }
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'setConversation');
      rethrow;
    }
  }

  /// 置顶会话
  /// [conversationID] 会话ID
  /// [isPinned] true: 置顶, false: 取消置顶
  Future<void> pinConversation({required String conversationID, required bool isPinned}) async {
    if (SdkIsolateManager.isActive) {
      await SdkIsolateManager.instance.invoke('conversation.pinConversation', {
        'conversationID': conversationID,
        'isPinned': isPinned,
      });
      return;
    }
    _log.info('conversationID=$conversationID, isPinned=$isPinned', methodName: 'pinConversation');
    try {
      final req = ConversationReq(isPinned: isPinned);
      return await setConversation(conversationID: conversationID, req: req);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'pinConversation');
      rethrow;
    }
  }

  /// 隐藏会话（对齐 Go SDK HideConversation：仅本地隐藏，不操作服务端）
  /// [conversationID] 会话ID
  Future<void> hideConversation({required String conversationID}) async {
    if (SdkIsolateManager.isActive) {
      await SdkIsolateManager.instance.invoke('conversation.hideConversation', {
        'conversationID': conversationID,
      });
      return;
    }
    _log.info('conversationID=$conversationID', methodName: 'hideConversation');
    try {
      await _database.resetConversation(conversationID);
      _log.info('会话已隐藏: $conversationID', methodName: 'hideConversation');
      await _notifyConversationChanged([conversationID]);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'hideConversation');
      rethrow;
    }
  }

  /// 隐藏所有会话（对齐 Go SDK HideAllConversations）
  Future<void> hideAllConversations() async {
    if (SdkIsolateManager.isActive) {
      await SdkIsolateManager.instance.invoke('conversation.hideAllConversations', {});
      return;
    }
    _log.info('called', methodName: 'hideAllConversations');
    try {
      await _database.resetAllConversations();
      _log.info('所有会话已隐藏', methodName: 'hideAllConversations');
      final allConvs = await _database.getVisibleConversations();
      listener?.conversationChanged(allConvs);
      final total = await getTotalUnreadMsgCount();
      listener?.totalUnreadMessageCountChanged(total);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'hideAllConversations');
      rethrow;
    }
  }

  /// 设置会话草稿
  /// [conversationID] 会话ID
  /// [draftText] 草稿内容
  Future<void> setConversationDraft({
    required String conversationID,
    required String draftText,
  }) async {
    if (SdkIsolateManager.isActive) {
      await SdkIsolateManager.instance.invoke('conversation.setConversationDraft', {
        'conversationID': conversationID,
        'draftText': draftText,
      });
      return;
    }
    _log.info(
      'conversationID=$conversationID, draftText=$draftText',
      methodName: 'setConversationDraft',
    );
    try {
      await _database.setConversationDraft(conversationID, draftText);
      _log.info('会话草稿已设置: $conversationID', methodName: 'setConversationDraft');
      await _notifyConversationChanged([conversationID]);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'setConversationDraft');
      rethrow;
    }
  }

  /// 获取未读消息总数
  Future<int> getTotalUnreadMsgCount() async {
    if (SdkIsolateManager.isActive) {
      return await SdkIsolateManager.instance.invoke('conversation.getTotalUnreadMsgCount', {})
          as int;
    }
    _log.info('called', methodName: 'getTotalUnreadMsgCount');
    try {
      return await _database.getTotalUnreadCount();
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getTotalUnreadMsgCount');
      rethrow;
    }
  }

  /// 标记会话消息已读
  /// [conversationID] 会话ID
  Future<void> markConversationMessageAsRead({required String conversationID}) async {
    if (SdkIsolateManager.isActive) {
      await SdkIsolateManager.instance.invoke('conversation.markConversationMessageAsRead', {
        'conversationID': conversationID,
      });
      return;
    }
    // 防止重入：同一会话正在标记已读时跳过
    if (_markingAsRead.contains(conversationID)) {
      _log.info(
        '跳过重入调用 conversationID=$conversationID',
        methodName: 'markConversationMessageAsRead',
      );
      return;
    }

    try {
      // 检查未读数是否已经为 0（对应 Go SDK 的 UnreadCount==0 守卫）
      final conv = await _database.getConversation(conversationID);
      if (conv == null || conv.unreadCount == 0) {
        _log.info(
          '未读数已为0，跳过 conversationID=$conversationID',
          methodName: 'markConversationMessageAsRead',
        );
        return;
      }

      _markingAsRead.add(conversationID);
      _log.info('conversationID=$conversationID', methodName: 'markConversationMessageAsRead');

      // 优先从消息表取最大 seq（对齐 Go SDK GetConversationNormalMsgSeq），
      // 回退到会话表 maxSeq
      var hasReadSeq = await _database.getConversationNormalMsgMaxSeq(conversationID);
      if (hasReadSeq <= 0) {
        hasReadSeq = await _database.getConversationMaxSeq(conversationID);
      }

      await _database.updateConversation(conversationID, {
        'unreadCount': 0,
        if (hasReadSeq > 0) 'hasReadSeq': hasReadSeq,
      });
      _log.info(
        '会话已标记已读: $conversationID, hasReadSeq=$hasReadSeq',
        methodName: 'markConversationMessageAsRead',
      );

      final total = await getTotalUnreadMsgCount();
      listener?.totalUnreadMessageCountChanged(total);
      await _notifyConversationChanged([conversationID]);

      // 同步到服务器（即使 hasReadSeq 为 0 也要调用，确保服务端清零未读数）
      final resp = await _api.markConversationAsRead(
        userID: _currentUserID,
        conversationID: conversationID,
        hasReadSeq: hasReadSeq,
      );
      if (resp.errCode != 0) {
        _log.warning('标记会话已读同步服务器失败: ${resp.errMsg}');
      }
    } catch (e, s) {
      _log.error(
        e.toString(),
        error: e,
        stackTrace: s,
        methodName: 'markConversationMessageAsRead',
      );
      rethrow;
    } finally {
      _markingAsRead.remove(conversationID);
    }
  }

  /// 标记所有会话消息已读
  Future<void> markAllConversationMessageAsRead() async {
    if (SdkIsolateManager.isActive) {
      await SdkIsolateManager.instance.invoke('conversation.markAllConversationMessageAsRead', {});
      return;
    }
    _log.info('called', methodName: 'markAllConversationMessageAsRead');
    try {
      final allConversations = await _database.getAllConversations();
      final unreadConvs = allConversations.where((c) => c.unreadCount > 0).toList();

      for (final conv in unreadConvs) {
        try {
          await markConversationMessageAsRead(conversationID: conv.conversationID);
        } catch (e) {
          _log.warning(
            '标记 ${conv.conversationID} 已读失败: $e',
            methodName: 'markAllConversationMessageAsRead',
          );
        }
      }

      _log.info(
        '所有会话已标记已读, count=${unreadConvs.length}',
        methodName: 'markAllConversationMessageAsRead',
      );
    } catch (e, s) {
      _log.error(
        e.toString(),
        error: e,
        stackTrace: s,
        methodName: 'markAllConversationMessageAsRead',
      );
      rethrow;
    }
  }

  /// 根据消息ID标记消息已读
  /// 对应 Go SDK MarkMessagesAsReadByMsgID
  /// [conversationID] 会话ID
  /// [clientMsgIDs] 要标记已读的消息clientMsgID列表
  Future<void> markMessagesAsReadByMsgID({
    required String conversationID,
    required List<String> clientMsgIDs,
  }) async {
    if (SdkIsolateManager.isActive) {
      await SdkIsolateManager.instance.invoke('conversation.markMessagesAsReadByMsgID', {
        'conversationID': conversationID,
        'clientMsgIDs': clientMsgIDs,
      });
      return;
    }
    _log.info(
      'conversationID=$conversationID, clientMsgIDs=$clientMsgIDs',
      methodName: 'markMessagesAsReadByMsgID',
    );
    try {
      if (clientMsgIDs.isEmpty) return;

      // 1. 验证会话存在
      final conv = await _database.getConversation(conversationID);
      if (conv == null) {
        _log.warning('会话不存在: $conversationID');
        return;
      }

      // 2. 获取消息列表
      final msgs = await _database.getMessagesByClientMsgIDs(clientMsgIDs);
      if (msgs.isEmpty) return;

      // 3. 过滤出未读的、非自己发的消息（对应 Go SDK getAsReadMsgMapAndList）
      final asReadMsgIDs = <String>[];
      final seqs = <int>[];
      for (final msg in msgs) {
        if (!(msg.isRead ?? false) && msg.sendID != _currentUserID) {
          final seq = msg.seq ?? 0;
          if (seq > 0) {
            asReadMsgIDs.add(msg.clientMsgID!);
            seqs.add(seq);
          }
        }
      }

      if (seqs.isEmpty) {
        _log.info('没有需要标记已读的消息', methodName: 'markMessagesAsReadByMsgID');
        return;
      }

      // 4. 同步到服务器
      final resp = await _api.markMsgsAsRead(
        userID: _currentUserID,
        conversationID: conversationID,
        seqs: seqs,
      );
      if (resp.errCode != 0) {
        _log.warning('标记消息已读同步服务器失败: ${resp.errMsg}');
      }

      // 5. 更新本地 DB
      final decrCount = await _database.markConversationMessageAsReadDB(
        conversationID,
        asReadMsgIDs,
      );

      // 6. 减少未读数
      await _database.decrConversationUnreadCount(conversationID, decrCount);

      // 7. 触发未读数变更
      final total = await getTotalUnreadMsgCount();
      listener?.totalUnreadMessageCountChanged(total);
      await _notifyConversationChanged([conversationID]);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'markMessagesAsReadByMsgID');
      rethrow;
    }
  }

  /// 删除会话及其所有消息（对齐 Go SDK DeleteConversationAndDeleteAllMsg）
  ///
  /// API-first：先清空服务端消息，再本地重置。
  /// 使用 ResetConversation（latestMsgSendTime=0）使会话从列表消失，
  /// 但保留会话记录供增量同步使用。
  Future<void> deleteConversationAndDeleteAllMsg({required String conversationID}) async {
    if (SdkIsolateManager.isActive) {
      await SdkIsolateManager.instance.invoke('conversation.deleteConversationAndDeleteAllMsg', {
        'conversationID': conversationID,
      });
      return;
    }
    _log.info('conversationID=$conversationID', methodName: 'deleteConversationAndDeleteAllMsg');
    try {
      final conv = await _database.getConversation(conversationID);
      if (conv == null) {
        throw OpenIMException(code: 0, message: 'conversation not found: $conversationID');
      }

      // API-first：先通知服务端清空消息
      final resp = await _api.clearConversationMsg(
        userID: _currentUserID,
        conversationIDs: [conversationID],
      );
      if (resp.errCode != 0) {
        _log.warning('服务端清空消息失败: ${resp.errMsg}', methodName: 'deleteConversationAndDeleteAllMsg');
      }

      // 标记已读到最新 seq
      await _getConversationMaxSeqAndSetHasRead(conversationID);
      // 删除本地消息
      await _clearConversationMessages(conversationID);
      // 重置会话（对齐 Go SDK ResetConversation）
      await _database.resetConversation(conversationID);

      await _notifyConversationChanged([conversationID]);
      final total = await getTotalUnreadMsgCount();
      listener?.totalUnreadMessageCountChanged(total);
    } catch (e, s) {
      _log.error(
        e.toString(),
        error: e,
        stackTrace: s,
        methodName: 'deleteConversationAndDeleteAllMsg',
      );
      rethrow;
    }
  }

  /// 清空会话消息但保留会话在列表中（对齐 Go SDK ClearConversationAndDeleteAllMsg）
  ///
  /// 与 deleteConversationAndDeleteAllMsg 的区别：
  /// - 使用 ClearConversation（不重置 latestMsgSendTime），会话仍显示在列表中
  Future<void> clearConversationAndDeleteAllMsg({required String conversationID}) async {
    if (SdkIsolateManager.isActive) {
      await SdkIsolateManager.instance.invoke('conversation.clearConversationAndDeleteAllMsg', {
        'conversationID': conversationID,
      });
      return;
    }
    _log.info('conversationID=$conversationID', methodName: 'clearConversationAndDeleteAllMsg');
    try {
      final conv = await _database.getConversation(conversationID);
      if (conv == null) {
        throw OpenIMException(code: 0, message: 'conversation not found: $conversationID');
      }

      // API-first
      final resp = await _api.clearConversationMsg(
        userID: _currentUserID,
        conversationIDs: [conversationID],
      );
      if (resp.errCode != 0) {
        _log.warning('服务端清空消息失败: ${resp.errMsg}', methodName: 'clearConversationAndDeleteAllMsg');
      }

      await _getConversationMaxSeqAndSetHasRead(conversationID);
      await _clearConversationMessages(conversationID);
      // 清空会话（对齐 Go SDK ClearConversation：保留 latestMsgSendTime）
      await _database.clearConversation(conversationID);

      await _notifyConversationChanged([conversationID]);
      final total = await getTotalUnreadMsgCount();
      listener?.totalUnreadMessageCountChanged(total);
    } catch (e, s) {
      _log.error(
        e.toString(),
        error: e,
        stackTrace: s,
        methodName: 'clearConversationAndDeleteAllMsg',
      );
      rethrow;
    }
  }

  /// 更新输入状态
  /// [conversationID] 会话ID
  /// [focus] 是否正在输入
  Future<void> changeInputStates({required String conversationID, required bool focus}) async {
    if (SdkIsolateManager.isActive) {
      await SdkIsolateManager.instance.invoke('conversation.changeInputStates', {
        'conversationID': conversationID,
        'focus': focus,
      });
      return;
    }
    _log.info('conversationID=$conversationID, focus=$focus', methodName: 'changeInputStates');
    try {
      _log.info('输入状态变更: $conversationID, focus=$focus', methodName: 'changeInputStates');

      // 获取会话信息以确定接收方
      final conv = await _database.getConversation(conversationID);
      if (conv == null) return;

      final recvID = conv.userID ?? '';
      final groupID = conv.groupID ?? '';
      final convType = conv.conversationType?.value ?? 1;

      // 构造 Typing 消息（对应 Go SDK 的 entering.go）
      final typingElem = {'msgTips': focus ? 'yes' : 'no'};
      final options = <String, bool>{
        'history': false,
        'persistent': false,
        'senderSync': false,
        'conversationUpdate': false,
        'senderConversationUpdate': false,
        'unreadCount': false,
        'offlinePush': false,
      };
      final msgData = {
        'sendID': _currentUserID,
        'recvID': recvID,
        'groupID': groupID,
        'clientMsgID': '${DateTime.now().microsecondsSinceEpoch}',
        'sessionType': convType,
        'msgFrom': 100,
        'contentType': 113, // Typing
        'content': jsonEncode(typingElem),
        'senderPlatformID': PlatformUtils.currentPlatform.value,
        'createTime': DateTime.now().millisecondsSinceEpoch,
        'sendTime': 0,
        'options': options,
      };

      final wsData = Uint8List.fromList(utf8.encode(jsonEncode(msgData)));
      await _webSocketService.sendRequestWaitResponse(
        reqIdentifier: WebSocketIdentifier.sendMsg,
        data: wsData,
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'changeInputStates');
      rethrow;
    }
  }

  /// 获取对方输入状态
  /// [conversationID] 会话ID
  /// [userID] 对方用户ID
  Future<List<int>?> getInputStates(String conversationID, String userID) async {
    if (SdkIsolateManager.isActive) {
      final result = await SdkIsolateManager.instance.invoke('conversation.getInputStates', {
        'conversationID': conversationID,
        'userID': userID,
      });
      return (result as List?)?.cast<int>();
    }
    _log.info('conversationID=$conversationID, userID=$userID', methodName: 'getInputStates');
    try {
      // 监听端提供平台列表，通常为实时响应
      return [];
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getInputStates');
      rethrow;
    }
  }

  /// 清空指定会话的所有消息
  Future<void> _clearConversationMessages(String conversationID) async {
    _log.info('conversationID=$conversationID', methodName: '_clearConversationMessages');
    try {
      await _database.deleteConversationAllMessages(conversationID);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: '_clearConversationMessages');
      rethrow;
    }
  }

  /// 对齐 Go SDK getConversationMaxSeqAndSetHasRead：
  /// 查询会话最大 seq 并设置 hasReadSeq，用于删除/清空前标记已读
  Future<void> _getConversationMaxSeqAndSetHasRead(String conversationID) async {
    try {
      final maxSeq = await _database.getConversationNormalMsgMaxSeq(conversationID);
      if (maxSeq > 0) {
        await _database.updateConversation(conversationID, {'hasReadSeq': maxSeq});
      }
    } catch (e, s) {
      _log.error(
        e.toString(),
        error: e,
        stackTrace: s,
        methodName: '_getConversationMaxSeqAndSetHasRead',
      );
    }
  }

  /// 通知会话变更
  Future<void> _notifyConversationChanged(List<String> conversationIDs) async {
    _log.info('conversationIDs=$conversationIDs', methodName: '_notifyConversationChanged');
    try {
      final conversations = await getMultipleConversation(conversationIDList: conversationIDs);
      if (conversations.isNotEmpty) {
        listener?.conversationChanged(conversations);
      }
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: '_notifyConversationChanged');
      rethrow;
    }
  }
}

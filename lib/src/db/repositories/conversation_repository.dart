import 'dart:convert';

import 'package:tostore/tostore.dart';

import '../../core/base_repository.dart';
import '../../enums/conversation_type.dart';
import '../../enums/group_at_type.dart';
import '../../enums/receive_message_opt.dart';
import '../../models/conversation_info.dart';
import '../../models/message.dart';
import '../../utils/im_convert.dart';
import '../db_schema.dart';
import 'message_repository.dart';

/// 本地会话领域仓储（`local_conversations`）。
final class ConversationRepository extends BaseRepository<ConversationInfo> {
  ConversationRepository({required super.store})
    : super(
        tableName: DbTableName.localConversation,
        primaryKeyName: 'conversationID',
        name: 'ConversationRepository',
      );

  void setCurrentUserID(String userID) {
    // 会话已通过 ToStore Multi-Space 按用户隔离，保留接口便于统一生命周期管理。
  }

  @override
  ConversationInfo fromRow(Map<String, dynamic> row) {
    final String? latestMsgStr = row['latestMsg'] as String?;
    Message? latestMsg;
    if (latestMsgStr != null && latestMsgStr.isNotEmpty) {
      try {
        final Map<String, dynamic> rawMap = jsonDecode(latestMsgStr) as Map<String, dynamic>;
        latestMsg = convertMessage(MessageRepository.normalizeRawMsg(rawMap));
      } catch (_) {}
    }

    return ConversationInfo(
      conversationID: row['conversationID'] as String,
      conversationType: (row['conversationType'] as int?) == null
          ? null
          : ConversationType.fromValue(row['conversationType'] as int),
      userID: row['userID'] as String?,
      groupID: row['groupID'] as String?,
      showName: row['showName'] as String?,
      faceURL: row['faceURL'] as String?,
      recvMsgOpt: (row['recvMsgOpt'] as int?) == null
          ? null
          : ReceiveMessageOpt.fromValue(row['recvMsgOpt'] as int),
      unreadCount: (row['unreadCount'] as num?)?.toInt() ?? 0,
      latestMsg: latestMsg,
      latestMsgSendTime: (row['latestMsgSendTime'] as num?)?.toInt(),
      draftText: row['draftText'] as String?,
      draftTextTime: (row['draftTextTime'] as num?)?.toInt(),
      isPinned: row['isPinned'] as bool?,
      isPrivateChat: row['isPrivateChat'] as bool?,
      burnDuration: (row['burnDuration'] as num?)?.toInt(),
      isMsgDestruct: row['isMsgDestruct'] as bool?,
      msgDestructTime: (row['msgDestructTime'] as num?)?.toInt(),
      ex: row['ex'] as String?,
      isNotInGroup: row['isNotInGroup'] as bool?,
      groupAtType: (row['groupAtType'] as int?) == null
          ? null
          : GroupAtType.fromValue(row['groupAtType'] as int),
    );
  }

  Future<DbResult> upsertConversation(Map<String, dynamic> data) => upsertRow(data);

  Future<DbResult> batchUpsertConversations(List<Map<String, dynamic>> dataList) =>
      batchUpsertRows(dataList);

  /// 批量局部更新会话（用于同步 seq/未读水位，替代 50 次循环单行更新）。
  Future<DbResult> batchUpdateConversations(List<Map<String, dynamic>> updates) =>
      batchUpdateRows(updates);

  Future<DbResult> updateConversation(String conversationID, Map<String, dynamic> data) =>
      updateByPrimaryKey(conversationID, data);

  Future<DbResult> deleteConversation(String conversationID) => deleteByPrimaryKey(conversationID);

  Future<DbResult> deleteAllConversations() async {
    final DbResult result = await store.delete(DbTableName.localConversation).allowDeleteAll();
    logIfErrors('deleteAllConversations', result);
    return result;
  }

  Future<ConversationInfo?> getConversation(String conversationID) =>
      findByPrimaryKey(conversationID);

  Future<List<ConversationInfo>> getMultipleConversations(List<String> conversationIDs) =>
      findByPrimaryKeys(conversationIDs);

  Future<List<ConversationInfo>> getAllConversations({int limit = 2000}) async {
    final QueryResult<Map<String, dynamic>> result = await store
        .query(DbTableName.localConversation)
        .limit(limit);
    return result.data.map<ConversationInfo>(fromRow).toList();
  }

  /// 获取可见会话列表，命中 `idx_conv_pinned_time` 索引并按置顶 + 活跃时间降序排列（修复 B-21）。
  Future<List<ConversationInfo>> getVisibleConversations({int limit = 2000}) async {
    final QueryResult<Map<String, dynamic>> result = await store
        .query(DbTableName.localConversation)
        .whereGreaterThan('latestMsgSendTime', 0)
        .orderByDesc('isPinned')
        .orderByDesc('latestMsgSendTime')
        .limit(limit);
    return sortConversations(result.data.map<ConversationInfo>(fromRow).toList());
  }

  /// 分页获取可见会话列表（有序）。
  Future<List<ConversationInfo>> getConversationsPage(int offset, int count) async {
    final QueryResult<Map<String, dynamic>> result = await store
        .query(DbTableName.localConversation)
        .whereGreaterThan('latestMsgSendTime', 0)
        .orderByDesc('isPinned')
        .orderByDesc('latestMsgSendTime')
        .limit(count)
        .offset(offset);
    return sortConversations(result.data.map<ConversationInfo>(fromRow).toList());
  }

  /// 按 OpenIM 规则排序：置顶优先，其次按 `max(draftTextTime, latestMsgSendTime)` 降序。
  static List<ConversationInfo> sortConversations(List<ConversationInfo> list) {
    list.sort((ConversationInfo a, ConversationInfo b) {
      final bool aPinned = a.isPinned == true;
      final bool bPinned = b.isPinned == true;
      if (aPinned != bPinned) {
        return aPinned ? -1 : 1;
      }
      final int aDraft = a.draftTextTime ?? 0;
      final int aMsg = a.latestMsgSendTime ?? 0;
      final int aTime = aDraft > aMsg ? aDraft : aMsg;
      final int bDraft = b.draftTextTime ?? 0;
      final int bMsg = b.latestMsgSendTime ?? 0;
      final int bTime = bDraft > bMsg ? bDraft : bMsg;
      return bTime.compareTo(aTime);
    });
    return list;
  }

  Future<Map<String, int>> getAllConversationHasReadSeqs() async {
    final QueryResult<Map<String, dynamic>> result = await store
        .query(DbTableName.localConversation)
        .select(<String>['conversationID', 'hasReadSeq'])
        .limit(5000);
    final Map<String, int> map = <String, int>{};
    for (final Map<String, dynamic> row in result.data) {
      final String? convID = row['conversationID'] as String?;
      if (convID != null) {
        map[convID] = (row['hasReadSeq'] as num?)?.toInt() ?? 0;
      }
    }
    return map;
  }

  Future<Map<String, int>> getAllConversationMaxSeqs() async {
    final QueryResult<Map<String, dynamic>> result = await store
        .query(DbTableName.localConversation)
        .select(<String>['conversationID', 'maxSeq'])
        .limit(5000);
    final Map<String, int> seqs = <String, int>{};
    for (final Map<String, dynamic> row in result.data) {
      final String? convID = row['conversationID'] as String?;
      if (convID != null) {
        seqs[convID] = (row['maxSeq'] as num?)?.toInt() ?? 0;
      }
    }
    return seqs;
  }

  Future<int> getConversationMaxSeq(String conversationID) async {
    final QueryBuilder query = store
        .query(DbTableName.localConversation)
        .whereEqual('conversationID', conversationID)
        .select(<String>['maxSeq']);
    final Map<String, dynamic>? row = query.peekFirst() ?? await query.first();
    return (row?['maxSeq'] as num?)?.toInt() ?? 0;
  }

  Future<int> getConversationHasReadSeq(String conversationID) async {
    final QueryBuilder query = store
        .query(DbTableName.localConversation)
        .whereEqual('conversationID', conversationID)
        .select(<String>['hasReadSeq']);
    final Map<String, dynamic>? row = query.peekFirst() ?? await query.first();
    return (row?['hasReadSeq'] as num?)?.toInt() ?? 0;
  }

  Future<DbResult> resetConversation(String conversationID) =>
      updateConversation(conversationID, <String, dynamic>{
        'unreadCount': 0,
        'latestMsg': '',
        'latestMsgSendTime': 0,
        'draftText': '',
        'draftTextTime': 0,
      });

  Future<DbResult> clearConversation(String conversationID) => updateConversation(
    conversationID,
    <String, dynamic>{'unreadCount': 0, 'latestMsg': '', 'draftText': '', 'draftTextTime': 0},
  );

  Future<DbResult> resetAllConversations() async {
    final DbResult result = await store.update(DbTableName.localConversation, <String, dynamic>{
      'unreadCount': 0,
      'latestMsg': '',
      'latestMsgSendTime': 0,
      'draftText': '',
      'draftTextTime': 0,
    }).allowUpdateAll();
    logIfErrors('resetAllConversations', result);
    return result;
  }

  /// 清空全部会话的 latestMsg 与 unreadCount（保留会话记录，修复 B-20）。
  Future<DbResult> clearAllConversationsMessages() async {
    final DbResult result = await store.update(DbTableName.localConversation, <String, dynamic>{
      'unreadCount': 0,
      'latestMsg': '',
    }).allowUpdateAll();
    logIfErrors('clearAllConversationsMessages', result);
    return result;
  }

  /// 计算非免打扰会话的未读总数（命中 `unreadCount` 索引 + 列裁剪）。
  Future<int> getTotalUnreadCount() async {
    final QueryResult<Map<String, dynamic>> result = await store
        .query(DbTableName.localConversation)
        .whereGreaterThan('unreadCount', 0)
        .select(<String>['unreadCount', 'recvMsgOpt'])
        .limit(5000);
    int total = 0;
    for (final Map<String, dynamic> row in result.data) {
      final int? recvOpt = (row['recvMsgOpt'] as num?)?.toInt();
      if (recvOpt == ReceiveMessageOpt.notNotify.value) {
        continue;
      }
      total += (row['unreadCount'] as num?)?.toInt() ?? 0;
    }
    return total;
  }

  Future<DbResult> setConversationDraft(String conversationID, String draftText) =>
      updateConversation(conversationID, <String, dynamic>{
        'draftText': draftText,
        'draftTextTime': draftText.isEmpty ? 0 : DateTime.now().millisecondsSinceEpoch,
      });

  Future<DbResult> clearConversationUnreadCount(String conversationID) =>
      updateConversation(conversationID, <String, dynamic>{'unreadCount': 0});

  /// 使用 ToStore 原子表达式有界递减未读数，避免并发 read-modify-write 竞态。
  Future<DbResult> decrConversationUnreadCount(String conversationID, int decrCount) async {
    if (decrCount <= 0) {
      return DbResult.success();
    }
    final DbResult result = await store
        .update(DbTableName.localConversation, <String, dynamic>{
          'unreadCount':
              Expr.field('unreadCount') -
              Expr.min(Expr.field('unreadCount'), Expr.value(decrCount)),
        })
        .whereEqual('conversationID', conversationID);
    logIfErrors('decrConversationUnreadCount($conversationID)', result);
    return result;
  }

  Future<DbResult> clearAllUnreadCounts() async {
    final DbResult result = await store.update(DbTableName.localConversation, <String, dynamic>{
      'unreadCount': 0,
    }).allowUpdateAll();
    logIfErrors('clearAllUnreadCounts', result);
    return result;
  }

  Future<List<ConversationInfo>> searchConversations(String keyword, {int limit = 100}) async {
    if (keyword.isEmpty) {
      return <ConversationInfo>[];
    }
    final QueryResult<Map<String, dynamic>> result = await store
        .query(DbTableName.localConversation)
        .whereLike('showName', '%$keyword%')
        .limit(limit);
    return result.data.map<ConversationInfo>(fromRow).toList();
  }
}

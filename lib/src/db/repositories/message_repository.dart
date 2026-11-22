import 'dart:convert';
import 'dart:math';

import 'package:tostore/tostore.dart';

import '../../core/base_repository.dart';
import '../../enums/conversation_type.dart';
import '../../enums/message_status.dart';
import '../../models/message.dart';
import '../../utils/im_convert.dart';
import '../db_schema.dart';

/// 本地聊天记录领域仓储（`local_chat_logs`）。
///
/// 关键优化与修复：
/// - 修复 B-08：独立实现正向（向过去）与反向（向未来）历史消息查询；
/// - 修复 B-19：支持多关键词 AND/OR、发送者过滤、时间窗与 `IndexType.text` 全文索引优先检索；
/// - 修复 B-26：`messageToDbMap` 统一支持写入 `conversationID`；
/// - 消除 `whereNotEqual('isRead', true)` 全表扫描，改为索引命中 `whereEqual('isRead', false)`。
final class MessageRepository extends BaseRepository<Message> {
  String _currentUserID = '';

  /// 创建 `MessageRepository` 实例。
  ///
  /// Creates a `MessageRepository` instance.
  ///
  /// - [store] 存储 / Store.
  MessageRepository({required super.store})
    : super(
        tableName: DbTableName.localChatLog,
        primaryKeyName: 'clientMsgID',
        name: 'MessageRepository',
      );

  /// 设置Current用户ID。
  ///
  /// Set current user ID.
  ///
  /// - [userID] 用户ID / User ID.
  void setCurrentUserID(String userID) {
    _currentUserID = userID;
  }

  /// 从行数据。
  ///
  /// From row.
  ///
  /// - [row] 行数据 / Row.
  /// - Returns: `Message` 结果 / Resulting `Message`.
  @override
  Message fromRow(Map<String, dynamic> row) => convertMessage(row);

  /// 插入消息。
  ///
  /// Insert message.
  ///
  /// - [msgData] 消息数据 / Message data.
  /// - Returns: `Future<DbResult>` 结果 / Resulting `Future<DbResult>`.
  Future<DbResult> insertMessage(Map<String, dynamic> msgData) => upsertRow(msgData);

  /// 批量插入消息列表。
  ///
  /// Batch insert messages.
  ///
  /// - [msgList] 消息列表 / Message list.
  /// - Returns: `Future<DbResult>` 结果 / Resulting `Future<DbResult>`.
  Future<DbResult> batchInsertMessages(List<Map<String, dynamic>> msgList) =>
      batchUpsertRows(msgList);

  /// 获取消息。
  ///
  /// Get message.
  ///
  /// - [clientMsgID] 客户端消息ID / Client message ID.
  /// - Returns: `Future<Message?>` 结果 / Resulting `Future<Message?>`.
  Future<Message?> getMessage(String clientMsgID) => findByPrimaryKey(clientMsgID);

  /// 获取消息列表按客户端消息ID 列表。
  ///
  /// Get messages by client message i ds.
  ///
  /// - [clientMsgIDs] 客户端消息ID 列表 / Client message i ds.
  /// - Returns: `Future<List<Message>>` 列表结果 / Resulting `Future<List<Message>>` list.
  Future<List<Message>> getMessagesByClientMsgIDs(List<String> clientMsgIDs) =>
      findByPrimaryKeys(clientMsgIDs);

  /// 更新消息状态。
  ///
  /// Update message status.
  ///
  /// - [clientMsgID] 客户端消息ID / Client message ID.
  /// - [status] 状态 / Status.
  /// - Returns: `Future<DbResult>` 结果 / Resulting `Future<DbResult>`.
  Future<DbResult> updateMessageStatus(String clientMsgID, int status) =>
      updateByPrimaryKey(clientMsgID, <String, dynamic>{'status': status});

  /// 更新消息。
  ///
  /// Update message.
  ///
  /// - [clientMsgID] 客户端消息ID / Client message ID.
  /// - [data] 数据 / Data.
  /// - Returns: `Future<DbResult>` 结果 / Resulting `Future<DbResult>`.
  Future<DbResult> updateMessage(String clientMsgID, Map<String, dynamic> data) =>
      updateByPrimaryKey(clientMsgID, data);

  /// 删除消息。
  ///
  /// Delete message.
  ///
  /// - [clientMsgID] 客户端消息ID / Client message ID.
  /// - Returns: `Future<DbResult>` 结果 / Resulting `Future<DbResult>`.
  Future<DbResult> deleteMessage(String clientMsgID) => deleteByPrimaryKey(clientMsgID);

  /// 删除会话全部消息列表。
  ///
  /// Delete conversation all messages.
  ///
  /// - [conversationID] 会话ID / Conversation ID.
  /// - Returns: `Future<DbResult>` 结果 / Resulting `Future<DbResult>`.
  Future<DbResult> deleteConversationAllMessages(String conversationID) async {
    final DbResult result = await store
        .delete(DbTableName.localChatLog)
        .whereEqual('conversationID', conversationID);
    logIfErrors('deleteConversationAllMessages($conversationID)', result);
    return result;
  }

  /// 删除全部消息列表。
  ///
  /// Delete all messages.
  ///
  /// - Returns: `Future<DbResult>` 结果 / Resulting `Future<DbResult>`.
  Future<DbResult> deleteAllMessages() async {
    final DbResult result = await store.delete(DbTableName.localChatLog).allowDeleteAll();
    logIfErrors('deleteAllMessages', result);
    return result;
  }

  /// 获取会话历史消息（按发送时间倒序，向更早消息翻页）。
  ///
  /// Get history messages.
  ///
  /// - [conversationID] 会话ID / Conversation ID.
  /// - [startTime] 开始时间戳 / Start timestamp.
  /// - [startSeq] 开始序列号 / Start sequence number.
  /// - [startClientMsgID] 开始客户端消息ID / Start client message ID.
  /// - [count] 数量 / Count.
  /// - Returns: `Future<List<Message>>` 列表结果 / Resulting `Future<List<Message>>` list.
  Future<List<Message>> getHistoryMessages({
    required String conversationID,
    int startTime = 0,
    int startSeq = 0,
    String startClientMsgID = '',
    int count = 20,
  }) async {
    QueryBuilder query = store
        .query(DbTableName.localChatLog)
        .whereEqual('conversationID', conversationID);
    if (startTime > 0) {
      query = query.whereLessThanOrEqualTo('sendTime', startTime);
    }
    final int limitCount = startTime > 0 ? count + 50 : count;
    final QueryResult<Map<String, dynamic>> result = await query
        .orderByDesc('sendTime')
        .orderByDesc('seq')
        .limit(limitCount);

    List<Map<String, dynamic>> dataList = List<Map<String, dynamic>>.of(result.data);

    // 首次加载时合并发送中/失败消息（命中 idx_chat_conv_status 索引）
    if (startTime == 0 && count > 0) {
      final QueryResult<Map<String, dynamic>> pendingResult = await store
          .query(DbTableName.localChatLog)
          .whereEqual('conversationID', conversationID)
          .whereIn('status', <int>[MessageStatus.sending.value, MessageStatus.failed.value])
          .orderByDesc('seq')
          .limit(count);
      if (pendingResult.data.isNotEmpty) {
        final Set<String?> existingIds = dataList
            .map<String?>((Map<String, dynamic> m) => m['clientMsgID'] as String?)
            .toSet();
        final List<Map<String, dynamic>> pendingToPrepend = <Map<String, dynamic>>[];
        for (final Map<String, dynamic> msg in pendingResult.data) {
          final String? id = msg['clientMsgID'] as String?;
          if (id != null && !existingIds.contains(id)) {
            pendingToPrepend.add(msg);
          }
        }
        dataList.insertAll(0, pendingToPrepend);
      }
    }

    if (startTime > 0 && dataList.isNotEmpty) {
      dataList = dataList.where((Map<String, dynamic> record) {
        final int sendTime = (record['sendTime'] as num?)?.toInt() ?? 0;
        final int seq = (record['seq'] as num?)?.toInt() ?? 0;
        final String clientMsgID = record['clientMsgID'] as String? ?? '';
        if (sendTime < startTime) {
          return true;
        }
        if (sendTime == startTime) {
          if (startSeq > 0) {
            return seq < startSeq;
          }
          return seq <= startSeq && clientMsgID != startClientMsgID;
        }
        return false;
      }).toList();
    }

    return dataList.take(count).map<Message>(fromRow).toList();
  }

  /// 反向获取历史消息（按发送时间升序，查询 `startMsg` 之后更新的消息，修复 B-08）。
  ///
  /// - [conversationID] 会话ID / Conversation ID.
  /// - [startTime] 开始时间戳 / Start timestamp.
  /// - [startSeq] 开始序列号 / Start sequence number.
  /// - [startClientMsgID] 开始客户端消息ID / Start client message ID.
  /// - [count] 数量 / Count.
  /// - Returns: `Future<List<Message>>` 列表结果 / Resulting `Future<List<Message>>` list.
  Future<List<Message>> getHistoryMessagesReverse({
    required String conversationID,
    int startTime = 0,
    int startSeq = 0,
    String startClientMsgID = '',
    int count = 20,
  }) async {
    QueryBuilder query = store
        .query(DbTableName.localChatLog)
        .whereEqual('conversationID', conversationID);
    if (startTime > 0) {
      query = query.whereGreaterThanOrEqualTo('sendTime', startTime);
    }
    final int limitCount = startTime > 0 ? count + 50 : count;
    final QueryResult<Map<String, dynamic>> result = await query
        .orderByAsc('sendTime')
        .orderByAsc('seq')
        .limit(limitCount);

    List<Map<String, dynamic>> dataList = List<Map<String, dynamic>>.of(result.data);
    if (startTime > 0 && dataList.isNotEmpty) {
      dataList = dataList.where((Map<String, dynamic> record) {
        final int sendTime = (record['sendTime'] as num?)?.toInt() ?? 0;
        final int seq = (record['seq'] as num?)?.toInt() ?? 0;
        final String clientMsgID = record['clientMsgID'] as String? ?? '';
        if (sendTime > startTime) {
          return true;
        }
        if (sendTime == startTime) {
          if (startSeq > 0) {
            return seq > startSeq;
          }
          return clientMsgID != startClientMsgID;
        }
        return false;
      }).toList();
    }

    return dataList.take(count).map<Message>(fromRow).toList();
  }

  /// 本地消息搜索：支持多关键词 AND/OR、发送者过滤、时间窗与 BM25 词法检索（修复 B-19）。
  ///
  /// - [conversationID] 会话ID / Conversation ID.
  /// - [keywords] 关键词列表 / Keywords.
  /// - [matchAllKeywords] match全部关键词列表 / Match all keywords.
  /// - [senderUserIDs] 发送器用户ID 列表 / Sender user i ds.
  /// - [messageTypes] 消息Types / Message types.
  /// - [startTime] 开始时间戳 / Start timestamp.
  /// - [endTime] 结束时间戳 / End timestamp.
  /// - [offset] 偏移量 / Offset.
  /// - [count] 数量 / Count.
  /// - Returns: `Future<({List<Message> messages, int totalCount})>` 结果 / Resulting `Future<({List<Message> messages, int totalCount})>`.
  Future<({List<Message> messages, int totalCount})> searchMessages({
    String? conversationID,
    List<String> keywords = const <String>[],
    bool matchAllKeywords = false,
    List<String> senderUserIDs = const <String>[],
    List<int> messageTypes = const <int>[],
    int? startTime,
    int? endTime,
    int offset = 0,
    int count = 40,
  }) async {
    final List<String> cleanKeywords = keywords
        .map<String>((String k) => k.trim().toLowerCase())
        .where((String k) => k.isNotEmpty)
        .toList();

    QueryBuilder query = store.query(DbTableName.localChatLog);
    if (conversationID != null && conversationID.isNotEmpty) {
      query = query.whereEqual('conversationID', conversationID);
    }
    if (senderUserIDs.isNotEmpty) {
      query = query.whereIn('sendID', senderUserIDs);
    }
    if (messageTypes.isNotEmpty) {
      query = query.whereIn('contentType', messageTypes);
    }
    if (startTime != null && startTime > 0) {
      query = query.whereGreaterThanOrEqualTo('sendTime', startTime);
    }
    if (endTime != null && endTime > 0) {
      query = query.whereLessThanOrEqualTo('sendTime', endTime);
    }

    // 单关键词或多关键词均优先使用 ToStore BM25 全文索引缩小候选集，未命中时回退精确流式过滤
    List<Map<String, dynamic>> candidates = <Map<String, dynamic>>[];
    bool usedTextIndex = false;
    if (cleanKeywords.isNotEmpty) {
      try {
        final String joinedQuery = cleanKeywords.join(' ');
        final QueryResult<Map<String, dynamic>> textResult = await query
            .matchText(
              'content',
              TextQuery.text(joinedQuery),
              operator: matchAllKeywords ? TextMatchOperator.and : TextMatchOperator.or,
            )
            .limit(2000);
        if (textResult.data.isNotEmpty) {
          candidates = List<Map<String, dynamic>>.of(textResult.data);
          usedTextIndex = true;
        }
      } catch (_) {
        usedTextIndex = false;
      }
    }

    if (!usedTextIndex) {
      final QueryResult<Map<String, dynamic>> fallbackResult = await query
          .orderByDesc('sendTime')
          .limit(5000);
      candidates = List<Map<String, dynamic>>.of(fallbackResult.data);
    }

    final List<Map<String, dynamic>> matched = candidates.where((Map<String, dynamic> row) {
      if (cleanKeywords.isEmpty) {
        return true;
      }
      final String? searchableText = _extractSearchableText(row);
      if (searchableText == null) {
        return false;
      }
      if (matchAllKeywords) {
        return cleanKeywords.every((String kw) => searchableText.contains(kw));
      }
      return cleanKeywords.any((String kw) => searchableText.contains(kw));
    }).toList();

    matched.sort((Map<String, dynamic> a, Map<String, dynamic> b) {
      final int ta = (a['sendTime'] as num?)?.toInt() ?? 0;
      final int tb = (b['sendTime'] as num?)?.toInt() ?? 0;
      return tb.compareTo(ta);
    });

    final int totalCount = matched.length;
    if (offset >= totalCount) {
      return (messages: <Message>[], totalCount: totalCount);
    }
    final int end = min(offset + count, totalCount);
    final List<Message> page = matched.sublist(offset, end).map<Message>(fromRow).toList();
    return (messages: page, totalCount: totalCount);
  }

  /// 统计某会话的未读消息条数（使用 `whereEqual('isRead', false)` 命中 `idx_chat_conv_read` 索引）。
  ///
  /// - [conversationID] 会话ID / Conversation ID.
  /// - [hasReadSeq] 是否包含读取序列号 / Whether has read sequence number.
  /// - Returns: 整数结果 / Integer result.
  Future<int> countUnreadInChatLog(String conversationID, int hasReadSeq) async {
    final QueryResult<Map<String, dynamic>> result = await store
        .query(DbTableName.localChatLog)
        .whereEqual('conversationID', conversationID)
        .whereEqual('isRead', false)
        .whereGreaterThan('seq', hasReadSeq < 0 ? 0 : hasReadSeq)
        .select(<String>['sendID'])
        .limit(5000);
    int unread = 0;
    for (final Map<String, dynamic> row in result.data) {
      final String sendID = row['sendID'] as String? ?? '';
      if (_currentUserID.isEmpty || sendID != _currentUserID) {
        unread++;
      }
    }
    return unread;
  }

  /// 获取会话内尚未标记已读的非自己发送消息（供单聊标记会话已读上报 seq）。
  ///
  /// - [conversationID] 会话ID / Conversation ID.
  /// - Returns: `Future<List<Message>>` 列表结果 / Resulting `Future<List<Message>>` list.
  Future<List<Message>> getUnreadMessages(String conversationID) async {
    final QueryResult<Map<String, dynamic>> result = await store
        .query(DbTableName.localChatLog)
        .whereEqual('conversationID', conversationID)
        .whereEqual('isRead', false)
        .limit(2000);
    return result.data
        .where((Map<String, dynamic> row) {
          final String sendID = row['sendID'] as String? ?? '';
          return _currentUserID.isEmpty || sendID != _currentUserID;
        })
        .map<Message>(fromRow)
        .toList();
  }

  /// 标记消息为已读。
  ///
  /// Mark message as read.
  ///
  /// - [clientMsgID] 客户端消息ID / Client message ID.
  Future<void> markMessageAsRead(String clientMsgID) async {
    await updateMessage(clientMsgID, <String, dynamic>{
      'isRead': true,
      'hasReadTime': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// 标记消息列表为已读。
  ///
  /// Mark messages as read.
  ///
  /// - [clientMsgIDs] 客户端消息ID 列表 / Client message i ds.
  /// - Returns: 整数结果 / Integer result.
  Future<int> markMessagesAsRead(List<String> clientMsgIDs) async {
    if (clientMsgIDs.isEmpty) {
      return 0;
    }
    final int now = DateTime.now().millisecondsSinceEpoch;
    final DbResult result = await store
        .update(DbTableName.localChatLog, <String, dynamic>{'isRead': true, 'hasReadTime': now})
        .whereIn('clientMsgID', clientMsgIDs);
    logIfErrors('markMessagesAsRead', result);
    return clientMsgIDs.length;
  }

  /// 标记消息列表为已读按序列号列表。
  ///
  /// Mark messages as read by sequence numbers.
  ///
  /// - [conversationID] 会话ID / Conversation ID.
  /// - [seqs] 序列号列表 / Sequence numbers.
  /// - Returns: `Future<DbResult>` 结果 / Resulting `Future<DbResult>`.
  Future<DbResult> markMessagesAsReadBySeqs(String conversationID, List<int> seqs) async {
    if (seqs.isEmpty) {
      return DbResult.success();
    }
    final int now = DateTime.now().millisecondsSinceEpoch;
    final DbResult result = await store
        .update(DbTableName.localChatLog, <String, dynamic>{'isRead': true, 'hasReadTime': now})
        .whereEqual('conversationID', conversationID)
        .whereIn('seq', seqs);
    logIfErrors('markMessagesAsReadBySeqs($conversationID)', result);
    return result;
  }

  /// 标记消息列表DeletedBy序列号列表。
  ///
  /// Mark messages deleted by sequence numbers.
  ///
  /// - [conversationID] 会话ID / Conversation ID.
  /// - [seqs] 序列号列表 / Sequence numbers.
  /// - Returns: `Future<DbResult>` 结果 / Resulting `Future<DbResult>`.
  Future<DbResult> markMessagesDeletedBySeqs(String conversationID, List<int> seqs) async {
    if (seqs.isEmpty) {
      return DbResult.success();
    }
    final DbResult result = await store
        .update(DbTableName.localChatLog, <String, dynamic>{'status': MessageStatus.deleted.value})
        .whereEqual('conversationID', conversationID)
        .whereIn('seq', seqs);
    logIfErrors('markMessagesDeletedBySeqs($conversationID)', result);
    return result;
  }

  /// 获取消息列表按序列号列表。
  ///
  /// Get messages by sequence numbers.
  ///
  /// - [conversationID] 会话ID / Conversation ID.
  /// - [seqs] 序列号列表 / Sequence numbers.
  /// - Returns: `Future<List<Message>>` 列表结果 / Resulting `Future<List<Message>>` list.
  Future<List<Message>> getMessagesBySeqs(String conversationID, List<int> seqs) async {
    if (seqs.isEmpty) {
      return <Message>[];
    }
    final QueryResult<Map<String, dynamic>> result = await store
        .query(DbTableName.localChatLog)
        .whereEqual('conversationID', conversationID)
        .whereIn('seq', seqs)
        .orderByDesc('sendTime');
    return result.data.map<Message>(fromRow).toList();
  }

  /// 获取会话普通消息最大序列号。
  ///
  /// Get conversation normal message maximum sequence number.
  ///
  /// - [conversationID] 会话ID / Conversation ID.
  /// - Returns: 整数结果 / Integer result.
  Future<int> getConversationNormalMsgMaxSeq(String conversationID) async {
    final QueryResult<Map<String, dynamic>> result = await store
        .query(DbTableName.localChatLog)
        .whereEqual('conversationID', conversationID)
        .orderByDesc('seq')
        .select(<String>['seq'])
        .limit(1);
    if (result.data.isEmpty) {
      return 0;
    }
    return (result.data.first['seq'] as num?)?.toInt() ?? 0;
  }

  /// 获取全部会话普通消息最大序列号列表。
  ///
  /// Get all conversation normal message maximum sequence numbers.
  ///
  /// - [conversationIDs] 会话ID 列表 / Conversation i ds.
  /// - Returns: `Future<Map<String, int>>` 映射结果 / Resulting `Future<Map<String, int>>` map.
  Future<Map<String, int>> getAllConversationNormalMsgMaxSeqs(List<String> conversationIDs) async {
    if (conversationIDs.isEmpty) {
      return <String, int>{};
    }
    try {
      final QueryResult<Map<String, dynamic>> result = await store
          .query(DbTableName.localChatLog)
          .whereIn('conversationID', conversationIDs)
          .select(<dynamic>['conversationID', Agg.max('seq', alias: 'maxSeq')])
          .groupBy(<String>['conversationID']);
      final Map<String, int> seqs = <String, int>{};
      for (final Map<String, dynamic> row in result.data) {
        final String? convID = row['conversationID'] as String?;
        if (convID != null) {
          seqs[convID] = (row['maxSeq'] as num?)?.toInt() ?? 0;
        }
      }
      return seqs;
    } catch (_) {
      const int batchSize = 100;
      final Map<String, int> seqs = <String, int>{};
      for (int i = 0; i < conversationIDs.length; i += batchSize) {
        final List<String> batch = conversationIDs.sublist(
          i,
          min(i + batchSize, conversationIDs.length),
        );
        final QueryResult<Map<String, dynamic>> rows = await store
            .query(DbTableName.localChatLog)
            .whereIn('conversationID', batch)
            .select(<String>['conversationID', 'seq'])
            .limit(5000);
        for (final Map<String, dynamic> row in rows.data) {
          final String? convID = row['conversationID'] as String?;
          final int seq = (row['seq'] as num?)?.toInt() ?? 0;
          if (convID != null && seq > (seqs[convID] ?? 0)) {
            seqs[convID] = seq;
          }
        }
      }
      return seqs;
    }
  }

  /// 更新单聊聊天消息发送器信息。
  ///
  /// Update single chat message sender info.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [senderNickname] 发送器昵称 / Sender nickname.
  /// - [senderFaceUrl] 发送器头像URL 地址 / Sender avatar URL.
  /// - Returns: `Future<DbResult>` 结果 / Resulting `Future<DbResult>`.
  Future<DbResult> updateSingleChatMessageSenderInfo(
    String userID, {
    required String senderNickname,
    String? senderFaceUrl,
  }) async {
    final Map<String, dynamic> data = <String, dynamic>{'senderNickname': senderNickname};
    if (senderFaceUrl != null) {
      data['senderFaceUrl'] = senderFaceUrl;
    }
    final DbResult result = await store
        .update(DbTableName.localChatLog, data)
        .whereEqual('sessionType', ConversationType.single.value)
        .whereEqual('sendID', userID);
    logIfErrors('updateSingleChatMessageSenderInfo($userID)', result);
    return result;
  }

  /// 更新全部消息发送器信息。
  ///
  /// Update all message sender info.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [senderNickname] 发送器昵称 / Sender nickname.
  /// - [senderFaceUrl] 发送器头像URL 地址 / Sender avatar URL.
  /// - Returns: `Future<DbResult>` 结果 / Resulting `Future<DbResult>`.
  Future<DbResult> updateAllMessageSenderInfo(
    String userID, {
    required String senderNickname,
    String? senderFaceUrl,
  }) async {
    final Map<String, dynamic> data = <String, dynamic>{'senderNickname': senderNickname};
    if (senderFaceUrl != null) {
      data['senderFaceUrl'] = senderFaceUrl;
    }
    final DbResult result = await store
        .update(DbTableName.localChatLog, data)
        .whereEqual('sendID', userID);
    logIfErrors('updateAllMessageSenderInfo($userID)', result);
    return result;
  }

  /// 将 [Message] 转换为数据库行 Map（可选直接注入 `conversationID`，修复 B-26）。
  ///
  /// - [msg] 消息 / Message.
  /// - [conversationID] 会话ID / Conversation ID.
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  static Map<String, dynamic> messageToDbMap(Message msg, {String? conversationID}) {
    final String? content = encodeMessageContent(msg);
    return <String, dynamic>{
      'clientMsgID': msg.clientMsgID,
      'serverMsgID': msg.serverMsgID,
      'sendID': msg.sendID,
      'recvID': msg.recvID,
      'senderPlatformID': msg.senderPlatformID?.value,
      'senderNickname': msg.senderNickname,
      'senderFaceUrl': msg.senderFaceUrl,
      'groupID': msg.groupID,
      'sessionType': msg.sessionType?.value,
      'msgFrom': msg.msgFrom,
      'contentType': msg.contentType?.value,
      'content': content,
      'isRead': msg.isRead ?? false,
      'status': msg.status?.value,
      'seq': msg.seq ?? 0,
      'sendTime': msg.sendTime,
      'createTime': msg.createTime,
      'attachedInfo': msg.attachedInfo,
      'ex': msg.ex,
      'localEx': msg.localEx,
      'isReact': msg.isReact ?? false,
      'isExternalExtensions': msg.isExternalExtensions ?? false,
      'hasReadTime': msg.hasReadTime,
      'conversationID': ?conversationID,
    };
  }

  /// 提取并序列化消息的 Elem JSON 字符串。
  ///
  /// - [msg] 消息 / Message.
  /// - Returns: 字符串结果（可为 `null`） / String result, or `null`.
  static String? encodeMessageContent(Message msg) {
    if (msg.textElem != null) return jsonEncode(msg.textElem!.toJson());
    if (msg.pictureElem != null) return jsonEncode(msg.pictureElem!.toJson());
    if (msg.soundElem != null) return jsonEncode(msg.soundElem!.toJson());
    if (msg.videoElem != null) return jsonEncode(msg.videoElem!.toJson());
    if (msg.fileElem != null) return jsonEncode(msg.fileElem!.toJson());
    if (msg.locationElem != null) return jsonEncode(msg.locationElem!.toJson());
    if (msg.customElem != null) return jsonEncode(msg.customElem!.toJson());
    if (msg.quoteElem != null) {
      final Map<String, dynamic> quoteMap = msg.quoteElem!.toJson();
      if (msg.advancedTextElem != null) {
        quoteMap['messageEntityList'] = msg.advancedTextElem!.messageEntityList
            ?.map<Map<String, dynamic>>((MessageEntity e) => e.toJson())
            .toList();
      }
      return jsonEncode(quoteMap);
    }
    if (msg.mergeElem != null) return jsonEncode(msg.mergeElem!.toJson());
    if (msg.faceElem != null) return jsonEncode(msg.faceElem!.toJson());
    if (msg.cardElem != null) return jsonEncode(msg.cardElem!.toJson());
    if (msg.atTextElem != null) return jsonEncode(msg.atTextElem!.toJson());
    if (msg.advancedTextElem != null) return jsonEncode(msg.advancedTextElem!.toJson());
    if (msg.callSignalElem != null) return jsonEncode(msg.callSignalElem!.toJson());
    if (msg.redPacketElem != null) return jsonEncode(msg.redPacketElem!.toJson());
    if (msg.redPacketGrabNotifyElem != null) {
      return jsonEncode(msg.redPacketGrabNotifyElem!.toJson());
    }
    return null;
  }

  /// 规范化服务端原始消息 Map，将 `content` JSON 解包为对应 `*Elem` 键。
  ///
  /// - [msg] 消息 / Message.
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  static Map<String, dynamic> normalizeRawMsg(Map<String, dynamic> msg) {
    final int ct = (msg['contentType'] as num?)?.toInt() ?? 0;
    final String? elemKey = _contentTypeToElemKey(ct);
    if (elemKey == null || msg[elemKey] != null) {
      return msg;
    }
    final String? rawContent = msg['content'] as String?;
    if (rawContent == null || rawContent.isEmpty) {
      return msg;
    }
    try {
      final Map<String, dynamic> contentMap = jsonDecode(rawContent) as Map<String, dynamic>;
      return <String, dynamic>{...msg, elemKey: contentMap};
    } catch (_) {
      return msg;
    }
  }

  static String? _contentTypeToElemKey(int ct) {
    return switch (ct) {
      101 => 'textElem',
      102 => 'pictureElem',
      103 => 'soundElem',
      104 => 'videoElem',
      105 => 'fileElem',
      106 => 'atTextElem',
      107 => 'mergeElem',
      108 => 'cardElem',
      109 => 'locationElem',
      110 || 119 || 120 => 'customElem',
      114 => 'quoteElem',
      115 => 'faceElem',
      117 => 'advancedTextElem',
      124 => 'callSignalElem',
      125 => 'redPacketElem',
      126 => 'redPacketGrabNotifyElem',
      _ => null,
    };
  }

  static String? _extractSearchableText(Map<String, dynamic> msg) {
    final int ct = (msg['contentType'] as num?)?.toInt() ?? 0;
    if (ct == 102 || ct == 103 || ct == 104 || ct == 124 || ct == 126) {
      return null;
    }
    final String rawContent = msg['content'] as String? ?? '';
    if (rawContent.isEmpty) {
      return null;
    }
    try {
      final Map<String, dynamic> contentMap = jsonDecode(rawContent) as Map<String, dynamic>;
      final String text = switch (ct) {
        101 => contentMap['content'] as String? ?? '',
        106 || 114 || 117 => contentMap['text'] as String? ?? '',
        105 => contentMap['fileName'] as String? ?? '',
        107 => contentMap['title'] as String? ?? '',
        108 => contentMap['nickname'] as String? ?? '',
        109 || 110 => contentMap['description'] as String? ?? '',
        125 => contentMap['greeting'] as String? ?? '',
        _ => rawContent,
      };
      return text.toLowerCase();
    } catch (_) {
      return rawContent.toLowerCase();
    }
  }
}

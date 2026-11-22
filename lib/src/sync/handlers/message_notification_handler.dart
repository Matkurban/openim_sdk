import 'dart:convert';

import '../../core/base_notification_handler.dart';
import '../../db/db_engine.dart';
import '../../enums/conversation_type.dart';
import '../../enums/message_type.dart';
import '../../listener/advanced_msg_listener.dart';
import '../../listener/conversation_listener.dart';
import '../../models/conversation_info.dart';
import '../../models/message.dart';
import '../entity_syncers/conversation_syncer.dart';

/// 消息控制通知处理器：撤回 (2101)、删除 (2102)、已读回执 (2200)。
final class MessageNotificationHandler extends BaseNotificationHandler {
  final DbEngine db;
  final ConversationSyncer conversationSyncer;
  final String loginUserID;
  final OnAdvancedMsgListener? Function() msgListenerProvider;
  final OnConversationListener? Function() conversationListenerProvider;

  MessageNotificationHandler({
    required this.db,
    required this.conversationSyncer,
    required this.loginUserID,
    required this.msgListenerProvider,
    required this.conversationListenerProvider,
  }) : super('MessageNotificationHandler');

  @override
  bool canHandle(int contentType) =>
      contentType == 2101 || contentType == 2102 || contentType == 2200;

  @override
  Future<void> handle(int contentType, Map<String, dynamic> detail) async {
    switch (contentType) {
      case 2101:
        await _onRevoke(detail);
      case 2102:
        await _onDeleteMsgs(detail);
      case 2200:
        await _onReadReceipt(detail);
    }
  }

  Future<void> _onRevoke(Map<String, dynamic> detail) async {
    final RevokedInfo info = RevokedInfo.fromJson(detail);
    final String clientMsgID = info.clientMsgID ?? '';
    final String conversationID = detail['conversationID']?.toString() ?? '';
    if (clientMsgID.isNotEmpty) {
      final String notificationContent = jsonEncode(
        NotificationElem(detail: jsonEncode(detail)).toJson(),
      );
      await db.messages.updateMessage(clientMsgID, <String, dynamic>{
        'contentType': MessageType.revokeMessageNotification.value,
        'content': notificationContent,
      });
    }
    msgListenerProvider()?.newRecvMessageRevoked(info);
    if (conversationID.isNotEmpty) {
      await _refreshConversationLatestMsg(conversationID);
    }
  }

  Future<void> _onDeleteMsgs(Map<String, dynamic> detail) async {
    final String conversationID = detail['conversationID']?.toString() ?? '';
    final List<int> seqs = ((detail['seqs'] as List<dynamic>?) ?? const <dynamic>[])
        .map<int>((dynamic e) => (e as num).toInt())
        .toList();
    if (conversationID.isEmpty || seqs.isEmpty) {
      return;
    }
    await db.messages.markMessagesDeletedBySeqs(conversationID, seqs);
    await _refreshConversationLatestMsg(conversationID);
  }

  Future<void> _onReadReceipt(Map<String, dynamic> detail) async {
    final String conversationID = detail['conversationID']?.toString() ?? '';
    final String userID = detail['userID']?.toString() ?? '';
    final int hasReadSeq = (detail['hasReadSeq'] as num?)?.toInt() ?? 0;
    final List<int> seqs = ((detail['seqs'] as List<dynamic>?) ?? const <dynamic>[])
        .map<int>((dynamic e) => (e as num).toInt())
        .toList();

    if (conversationID.isEmpty) {
      return;
    }

    // 自己其他端触发的已读回执：同步本地 hasReadSeq 并重算未读数
    if (userID == loginUserID) {
      final int localHasRead = await db.conversations.getConversationHasReadSeq(conversationID);
      final int effectiveHasRead = hasReadSeq > localHasRead ? hasReadSeq : localHasRead;
      final int remainingUnread = await db.messages.countUnreadInChatLog(
        conversationID,
        effectiveHasRead,
      );
      await db.conversations.updateConversation(conversationID, <String, dynamic>{
        'hasReadSeq': effectiveHasRead,
        'unreadCount': remainingUnread,
      });
      if (seqs.isNotEmpty) {
        await db.messages.markMessagesAsReadBySeqs(conversationID, seqs);
      }
      final ConversationInfo? updated = await db.conversations.getConversation(conversationID);
      if (updated != null) {
        conversationListenerProvider()?.conversationChanged(<ConversationInfo>[updated]);
      }
      await conversationSyncer.fireTotalUnreadChanged();
      return;
    }

    // 对端发来的单聊已读回执：标记我方已发消息为已读并通知 UI
    if (seqs.isNotEmpty) {
      await db.messages.markMessagesAsReadBySeqs(conversationID, seqs);
      final List<Message> msgs = await db.messages.getMessagesBySeqs(conversationID, seqs);
      final List<String> msgIDList = msgs
          .map<String?>((Message m) => m.clientMsgID)
          .whereType<String>()
          .toList();
      if (msgIDList.isNotEmpty) {
        final int? rawSessionType = (detail['sessionType'] as num?)?.toInt();
        msgListenerProvider()?.recvC2CReadReceipt(<ReadReceiptInfo>[
          ReadReceiptInfo(
            userID: userID,
            msgIDList: msgIDList,
            readTime: DateTime.now().millisecondsSinceEpoch,
            sessionType: rawSessionType != null ? ConversationType.fromValue(rawSessionType) : null,
          ),
        ]);
      }
    }
  }

  Future<void> _refreshConversationLatestMsg(String conversationID) async {
    final List<Message> latest = await db.messages.getHistoryMessages(
      conversationID: conversationID,
      count: 1,
    );
    if (latest.isNotEmpty) {
      await db.conversations.updateConversation(conversationID, <String, dynamic>{
        'latestMsg': jsonEncode(latest.first.toJson()),
        'latestMsgSendTime': latest.first.sendTime,
      });
    } else {
      await db.conversations.updateConversation(conversationID, <String, dynamic>{
        'latestMsg': '',
        'latestMsgSendTime': 0,
      });
    }
    final ConversationInfo? updated = await db.conversations.getConversation(conversationID);
    if (updated != null) {
      conversationListenerProvider()?.conversationChanged(<ConversationInfo>[updated]);
    }
  }
}

import '../../core/base_notification_handler.dart';
import '../../db/db_engine.dart';
import '../../listener/conversation_listener.dart';
import '../../models/conversation_info.dart';
import '../entity_syncers/conversation_syncer.dart';

/// 会话属性变更、阅后即焚与清空会话通知处理器（contentType 1300 / 1701 / 1703 / 2001）。
final class ConversationNotificationHandler extends BaseNotificationHandler {
  final DbEngine db;
  final ConversationSyncer conversationSyncer;
  final String loginUserID;
  final OnConversationListener? Function() conversationListenerProvider;
  final void Function(String key, Map<String, dynamic> data)? onBusinessNotification;

  ConversationNotificationHandler({
    required this.db,
    required this.conversationSyncer,
    required this.loginUserID,
    required this.conversationListenerProvider,
    this.onBusinessNotification,
  }) : super('ConversationNotificationHandler');

  @override
  bool canHandle(int contentType) =>
      contentType == 1300 || contentType == 1701 || contentType == 1703 || contentType == 2001;

  @override
  Future<void> handle(int contentType, Map<String, dynamic> detail) async {
    switch (contentType) {
      case 1300: // conversationChangeNotification
        await conversationSyncer.sync(loginUserID);
      case 1701: // conversationPrivateChatNotification
        final String convID = detail['conversationID']?.toString() ?? '';
        if (convID.isNotEmpty) {
          final bool isPrivate = detail['isPrivate'] as bool? ?? false;
          await db.conversations.updateConversation(convID, <String, dynamic>{
            'isPrivateChat': isPrivate,
          });
          final ConversationInfo? updated = await db.conversations.getConversation(convID);
          if (updated != null) {
            conversationListenerProvider()?.conversationChanged(<ConversationInfo>[updated]);
          }
        }
      case 1703: // clearConversationNotification
        final List<dynamic> convIDs =
            detail['conversationIDs'] as List<dynamic>? ?? const <dynamic>[];
        final List<ConversationInfo> changed = <ConversationInfo>[];
        for (final dynamic rawID in convIDs) {
          final String convID = rawID.toString();
          if (convID.isEmpty) {
            continue;
          }
          await db.transaction(() async {
            await db.messages.deleteConversationAllMessages(convID);
            await db.conversations.clearConversation(convID);
          });
          final ConversationInfo? updated = await db.conversations.getConversation(convID);
          if (updated != null) {
            changed.add(updated);
          }
        }
        if (changed.isNotEmpty) {
          conversationListenerProvider()?.conversationChanged(changed);
          await conversationSyncer.fireTotalUnreadChanged();
        }
      case 2001: // businessNotification
        final String key = detail['key']?.toString() ?? '';
        final dynamic rawData = detail['data'];
        if (key.isNotEmpty && rawData is Map<String, dynamic>) {
          onBusinessNotification?.call(key, rawData);
        }
    }
  }
}

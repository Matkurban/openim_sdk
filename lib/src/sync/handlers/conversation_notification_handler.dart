import 'dart:convert';

import '../../core/base_notification_handler.dart';
import '../../db/db_engine.dart';
import '../../listener/conversation_listener.dart';
import '../../models/conversation_info.dart';
import '../entity_syncers/conversation_syncer.dart';

/// 会话属性变更、阅后即焚与清空会话通知处理器（contentType 1300 / 1701 / 1703 / 2001）。
final class ConversationNotificationHandler extends BaseNotificationHandler {
  /// 数据库。
  ///
  /// Database.
  final DbEngine db;

  /// 会话同步器。
  ///
  /// Conversation syncer.
  final ConversationSyncer conversationSyncer;

  /// 登录用户ID。
  ///
  /// Login user ID.
  final String loginUserID;

  /// 会话监听器Provider。
  ///
  /// Conversation listener provider.
  final OnConversationListener? Function() conversationListenerProvider;

  /// onBusiness通知。
  ///
  /// On business notification.
  final void Function(String key, Map<String, dynamic> data)? onBusinessNotification;

  /// 创建 `ConversationNotificationHandler` 实例。
  ///
  /// Creates a `ConversationNotificationHandler` instance.
  ///
  /// - [db] 数据库 / Database.
  /// - [conversationSyncer] 会话同步器 / Conversation syncer.
  /// - [loginUserID] 登录用户ID / Login user ID.
  /// - [conversationListenerProvider] 会话监听器Provider / Conversation listener provider.
  /// - [onBusinessNotification] onBusiness通知 / On business notification.
  ConversationNotificationHandler({
    required this.db,
    required this.conversationSyncer,
    required this.loginUserID,
    required this.conversationListenerProvider,
    this.onBusinessNotification,
  }) : super('ConversationNotificationHandler');

  /// 是否支持处理。
  ///
  /// Whether can handle.
  ///
  /// - [contentType] 内容类型 / Content type.
  /// - Returns: 操作结果布尔值 / Boolean result.
  @override
  bool canHandle(int contentType) =>
      contentType == 1300 || contentType == 1701 || contentType == 1703 || contentType == 2001;

  /// 处理。
  ///
  /// Handle.
  ///
  /// - [contentType] 内容类型 / Content type.
  /// - [detail] 详情 / Detail.
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
        if (key.isNotEmpty) {
          final Map<String, dynamic>? payload = _decodeBusinessPayload(rawData);
          if (payload != null) {
            onBusinessNotification?.call(key, payload);
          }
        }
    }
  }

  Map<String, dynamic>? _decodeBusinessPayload(dynamic rawData) {
    if (rawData is Map<String, dynamic>) {
      return rawData;
    }
    if (rawData is Map<dynamic, dynamic>) {
      return Map<String, dynamic>.from(rawData);
    }
    if (rawData is String) {
      if (rawData.isEmpty) {
        return <String, dynamic>{};
      }
      try {
        final Object? decoded = jsonDecode(rawData);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        }
        if (decoded is Map<dynamic, dynamic>) {
          return Map<String, dynamic>.from(decoded);
        }
        return <String, dynamic>{'value': rawData};
      } catch (_) {
        return <String, dynamic>{'value': rawData};
      }
    }
    return null;
  }
}

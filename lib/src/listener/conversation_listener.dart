import 'package:openim_sdk/openim_sdk.dart';

/// Conversation Listener
class OnConversationListener {
  void Function(List<ConversationInfo> list)? onConversationChanged;
  void Function(List<ConversationInfo> list)? onNewConversation;
  void Function(int count)? onTotalUnreadMessageCountChanged;
  void Function(bool? reinstalled)? onSyncServerStart;
  void Function(int? progress)? onSyncServerProgress;
  void Function(bool? reinstalled)? onSyncServerFinish;
  void Function(bool? reinstalled)? onSyncServerFailed;
  void Function(InputStatusChangedData data)? onInputStatusChanged;

  OnConversationListener({
    this.onConversationChanged,
    this.onNewConversation,
    this.onTotalUnreadMessageCountChanged,
    this.onSyncServerStart,
    this.onSyncServerProgress,
    this.onSyncServerFinish,
    this.onSyncServerFailed,
    this.onInputStatusChanged,
  });

  /// Conversations have changed
  void conversationChanged(List<ConversationInfo> list) {
    onConversationChanged?.call(list);
  }

  /// New conversations have been created
  void newConversation(List<ConversationInfo> list) {
    onNewConversation?.call(list);
  }

  /// Total unread message count has changed
  void totalUnreadMessageCountChanged(int count) {
    onTotalUnreadMessageCountChanged?.call(count);
  }

  void syncServerStart(bool? reinstalled) {
    onSyncServerStart?.call(reinstalled);
  }

  void syncServerProgress(int? progress) {
    onSyncServerProgress?.call(progress);
  }

  void syncServerFailed(bool? reinstalled) {
    onSyncServerFailed?.call(reinstalled);
  }

  void syncServerFinish(bool? reinstalled) {
    onSyncServerFinish?.call(reinstalled);
  }

  void conversationUserInputStatusChanged(InputStatusChangedData data) {
    onInputStatusChanged?.call(data);
  }
}

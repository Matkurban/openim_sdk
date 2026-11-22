import 'package:openim_sdk/openim_sdk.dart';

/// 会话与数据同步事件监听器。
///
/// Conversation and server synchronization event listener.
class OnConversationListener {
  /// 已有会话变更回调 / Callback invoked when existing conversations change.
  void Function(List<ConversationInfo> list)? onConversationChanged;

  /// 新增会话回调 / Callback invoked when new conversations are created.
  void Function(List<ConversationInfo> list)? onNewConversation;

  /// 未读消息总数变更回调 / Callback invoked when total unread message count changes.
  void Function(int count)? onTotalUnreadMessageCountChanged;

  /// 开始从服务端同步数据回调 / Callback invoked when server sync starts.
  void Function(bool? reinstalled)? onSyncServerStart;

  /// 服务端同步进度回调（0–100） / Callback invoked with server sync progress (`0`–`100`).
  void Function(int? progress)? onSyncServerProgress;

  /// 服务端同步完成回调 / Callback invoked when server sync finishes.
  void Function(bool? reinstalled)? onSyncServerFinish;

  /// 服务端同步失败回调 / Callback invoked when server sync fails.
  void Function(bool? reinstalled)? onSyncServerFailed;

  /// 对端输入状态变更回调 / Callback invoked when peer typing status changes.
  void Function(InputStatusChangedData data)? onInputStatusChanged;

  /// 创建会话事件监听器。
  ///
  /// Creates an [OnConversationListener] with optional conversation and sync callbacks.
  ///
  /// - [onConversationChanged] 会话变更回调 / Conversation changed callback.
  /// - [onNewConversation] 新增会话回调 / New conversation callback.
  /// - [onTotalUnreadMessageCountChanged] 总未读数变更回调 / Total unread count changed callback.
  /// - [onSyncServerStart] 同步开始回调 / Sync started callback.
  /// - [onSyncServerProgress] 同步进度回调 / Sync progress callback.
  /// - [onSyncServerFinish] 同步完成回调 / Sync finished callback.
  /// - [onSyncServerFailed] 同步失败回调 / Sync failed callback.
  /// - [onInputStatusChanged] 输入状态变更回调 / Typing status changed callback.
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

  /// 触发会话变更回调 / Dispatches [onConversationChanged].
  ///
  /// - [list] 发生变更的会话列表 / Changed conversations list.
  void conversationChanged(List<ConversationInfo> list) {
    onConversationChanged?.call(list);
  }

  /// 触发新增会话回调 / Dispatches [onNewConversation].
  ///
  /// - [list] 新增会话列表 / Newly created conversations list.
  void newConversation(List<ConversationInfo> list) {
    onNewConversation?.call(list);
  }

  /// 触发未读总数变更回调 / Dispatches [onTotalUnreadMessageCountChanged].
  ///
  /// - [count] 最新未读消息总数 / Latest total unread count.
  void totalUnreadMessageCountChanged(int count) {
    onTotalUnreadMessageCountChanged?.call(count);
  }

  /// 触发服务端同步开始回调 / Dispatches [onSyncServerStart].
  ///
  /// - [reinstalled] 是否为首次安装/重装同步 / Whether this is a first/reinstall sync.
  void syncServerStart(bool? reinstalled) {
    onSyncServerStart?.call(reinstalled);
  }

  /// 触发服务端同步进度回调 / Dispatches [onSyncServerProgress].
  ///
  /// - [progress] 同步进度百分比（0–100） / Sync progress percentage (`0`–`100`).
  void syncServerProgress(int? progress) {
    onSyncServerProgress?.call(progress);
  }

  /// 触发服务端同步失败回调 / Dispatches [onSyncServerFailed].
  ///
  /// - [reinstalled] 是否为首次安装/重装同步 / Whether this is a first/reinstall sync.
  void syncServerFailed(bool? reinstalled) {
    onSyncServerFailed?.call(reinstalled);
  }

  /// 触发服务端同步完成回调 / Dispatches [onSyncServerFinish].
  ///
  /// - [reinstalled] 是否为首次安装/重装同步 / Whether this is a first/reinstall sync.
  void syncServerFinish(bool? reinstalled) {
    onSyncServerFinish?.call(reinstalled);
  }

  /// 触发输入状态变更回调 / Dispatches [onInputStatusChanged].
  ///
  /// - [data] 对端输入状态变更数据 / Peer typing status change payload.
  void conversationUserInputStatusChanged(InputStatusChangedData data) {
    onInputStatusChanged?.call(data);
  }
}

import 'package:openim_sdk/openim_sdk.dart';

/// 高级消息事件监听器，用于接收新消息、撤回、已读回执与状态变更回调。
///
/// Advanced message event listener for new messages, revocations, read receipts, and status changes.
class OnAdvancedMsgListener {
  /// 消息被删除回调 / Callback invoked when a message is deleted.
  void Function(Message msg)? onMsgDeleted;

  /// 收到消息撤回通知回调 / Callback invoked when a message is revoked.
  void Function(RevokedInfo info)? onNewRecvMessageRevoked;

  /// 收到单聊消息已读回执回调 / Callback invoked on receiving C2C message read receipts.
  void Function(List<ReadReceiptInfo> list)? onRecvC2CReadReceipt;

  /// 收到实时新消息回调 / Callback invoked when a new realtime message arrives.
  void Function(Message msg)? onRecvNewMessage;

  /// 收到单条离线消息回调 / Callback invoked for an individual offline message.
  void Function(Message msg)? onRecvOfflineNewMessage;

  /// 批量离线消息回调（对齐 Go SDK `batchNewMessages`，同会话离线消息一次性回调）。
  ///
  /// Batch offline messages callback (aligned with Go SDK `batchNewMessages`) delivering
  /// all pulled offline messages for a conversation in one batch.
  void Function(List<Message> msgs)? onRecvOfflineNewMessages;

  /// 收到仅在线消息回调 / Callback invoked when an online-only message arrives.
  void Function(Message msg)? onRecvOnlineOnlyMessage;

  /// 消息发送状态变更回调（如 sending → failed / succeeded） / Callback invoked when message status changes.
  void Function(Message msg)? onMessageStatusChanged;

  /// 监听器唯一标识 ID / Unique identifier for this listener instance.
  String id;

  /// 创建高级消息事件监听器。
  ///
  /// Creates an [OnAdvancedMsgListener] with optional event callbacks.
  ///
  /// - [onMsgDeleted] 消息删除回调 / Message deleted callback.
  /// - [onNewRecvMessageRevoked] 消息撤回回调 / Message revoked callback.
  /// - [onRecvC2CReadReceipt] 单聊已读回执回调 / C2C read receipt callback.
  /// - [onRecvNewMessage] 实时新消息回调 / Realtime new message callback.
  /// - [onRecvOfflineNewMessage] 单条离线消息回调 / Single offline message callback.
  /// - [onRecvOfflineNewMessages] 批量离线消息回调 / Batch offline messages callback.
  /// - [onRecvOnlineOnlyMessage] 仅在线消息回调 / Online-only message callback.
  /// - [onMessageStatusChanged] 消息状态变更回调 / Message status changed callback.
  OnAdvancedMsgListener({
    this.onMsgDeleted,
    this.onNewRecvMessageRevoked,
    this.onRecvC2CReadReceipt,
    this.onRecvNewMessage,
    this.onRecvOfflineNewMessage,
    this.onRecvOfflineNewMessages,
    this.onRecvOnlineOnlyMessage,
    this.onMessageStatusChanged,
  }) : id = 'id_${DateTime.now().microsecondsSinceEpoch}';

  /// 触发消息删除回调 / Dispatches [onMsgDeleted].
  ///
  /// - [msg] 被删除的消息 / Deleted message.
  void msgDeleted(Message msg) {
    onMsgDeleted?.call(msg);
  }

  /// 触发消息撤回回调 / Dispatches [onNewRecvMessageRevoked].
  ///
  /// - [info] 撤回详情对象 / Revocation details.
  void newRecvMessageRevoked(RevokedInfo info) {
    onNewRecvMessageRevoked?.call(info);
  }

  /// 触发单聊已读回执回调 / Dispatches [onRecvC2CReadReceipt].
  ///
  /// - [list] 已读回执信息列表 / List of read receipt items.
  void recvC2CReadReceipt(List<ReadReceiptInfo> list) {
    onRecvC2CReadReceipt?.call(list);
  }

  /// 触发实时新消息回调 / Dispatches [onRecvNewMessage].
  ///
  /// - [msg] 新收到的消息 / Newly received message.
  void recvNewMessage(Message msg) {
    onRecvNewMessage?.call(msg);
  }

  /// 触发单条离线消息回调 / Dispatches [onRecvOfflineNewMessage].
  ///
  /// - [msg] 离线消息 / Pulled offline message.
  void recvOfflineNewMessage(Message msg) {
    onRecvOfflineNewMessage?.call(msg);
  }

  /// 触发批量离线消息回调 / Dispatches [onRecvOfflineNewMessages].
  ///
  /// - [msgs] 同一批次的离线消息列表 / Batch of pulled offline messages.
  void recvOfflineNewMessages(List<Message> msgs) {
    onRecvOfflineNewMessages?.call(msgs);
  }

  /// 触发仅在线消息回调 / Dispatches [onRecvOnlineOnlyMessage].
  ///
  /// - [msg] 仅在线消息 / Online-only message.
  void recvOnlineOnlyMessage(Message msg) {
    onRecvOnlineOnlyMessage?.call(msg);
  }

  /// 触发消息状态变更回调 / Dispatches [onMessageStatusChanged].
  ///
  /// - [msg] 状态更新后的消息 / Message with updated status.
  void messageStatusChanged(Message msg) {
    onMessageStatusChanged?.call(msg);
  }
}

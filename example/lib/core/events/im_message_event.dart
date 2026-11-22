import 'package:openim_sdk/openim_sdk.dart';

/// IM 消息收发、撤回、已读与发送进度事件。
///
/// IM message receive, revoke, read receipt, and send progress event.
class ImMessageEvent {
  /// 事件类型：`newMessage`、`offlineMessages`、`onlineOnly`、`deleted`、`revoked`、`readReceipt`、`statusChanged`、`sendProgress`、`sendFailure`。
  final String kind;

  /// 单条消息对象。
  final Message? message;

  /// 批量离线消息列表。
  final List<Message> messages;

  /// 撤回信息。
  final RevokedInfo? revokedInfo;

  /// 单聊已读回执列表。
  final List<ReadReceiptInfo> readReceipts;

  /// 客户端消息 ID（进度/失败事件使用）。
  final String? clientMsgID;

  /// 发送进度 0-100。
  final int? progress;

  /// 发送失败错误描述。
  final String? error;

  /// 创建消息事件。
  const ImMessageEvent({
    required this.kind,
    this.message,
    this.messages = const <Message>[],
    this.revokedInfo,
    this.readReceipts = const <ReadReceiptInfo>[],
    this.clientMsgID,
    this.progress,
    this.error,
  });
}

import 'package:openim_sdk/openim_sdk.dart';

/// IM 会话与同步事件。
///
/// IM conversation and sync event.
class ImConversationEvent {
  /// 事件类型：`changed`、`added`、`unreadChanged`、`syncStart`、`syncProgress`、`syncFinish`、`syncFailed`、`inputStatus`。
  final String kind;

  /// 变更或新增的会话列表。
  final List<ConversationInfo> conversations;

  /// 总未读数（`unreadChanged` 时有效）。
  final int? totalUnreadCount;

  /// 同步进度（`syncProgress` 时有效）。
  final int? syncProgress;

  /// 正在输入状态变更信息（`inputStatus` 时有效）。
  final InputStatusChangedData? inputStatus;

  /// 创建会话事件。
  const ImConversationEvent({
    required this.kind,
    this.conversations = const <ConversationInfo>[],
    this.totalUnreadCount,
    this.syncProgress,
    this.inputStatus,
  });
}

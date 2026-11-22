import 'package:json_annotation/json_annotation.dart';

/// 消息发送状态枚举。
///
/// Message delivery status enum.
enum MessageStatus {
  /// 发送中 / Sending in progress.
  @JsonValue(1)
  sending(1),

  /// 发送成功 / Sent successfully.
  @JsonValue(2)
  succeeded(2),

  /// 发送失败 / Send failed.
  @JsonValue(3)
  failed(3),

  /// 已删除 / Deleted.
  @JsonValue(4)
  deleted(4);

  /// 创建消息状态枚举值。
  ///
  /// Creates a [MessageStatus] with its protocol integer [value].
  ///
  /// - [value] 协议整数值 / Protocol integer value.
  const MessageStatus(this.value);

  /// 协议整数值 / Protocol integer value.
  final int value;

  /// 根据整数值解析 [MessageStatus]，未匹配时默认返回 [failed]。
  ///
  /// Resolves [MessageStatus] from integer [value], defaulting to [failed].
  ///
  /// - [value] 协议整数值 / Protocol integer value.
  /// - Returns: 对应的 [MessageStatus] 枚举值 / Matching [MessageStatus] enum value.
  factory MessageStatus.fromValue(int value) {
    return values.firstWhere((MessageStatus item) => item.value == value, orElse: () => failed);
  }
}

/// 历史消息查询视图类型枚举。
///
/// View mode enum for querying history messages.
enum GetHistoryViewType {
  /// 普通历史聊天视图 / Standard chat history view.
  @JsonValue(0)
  history(0),

  /// 搜索结果上下文视图 / Search result context view.
  @JsonValue(1)
  search(1);

  /// 创建历史消息视图类型枚举值。
  ///
  /// Creates a [GetHistoryViewType] with its protocol integer [value].
  ///
  /// - [value] 协议整数值 / Protocol integer value.
  const GetHistoryViewType(this.value);

  /// 协议整数值 / Protocol integer value.
  final int value;
}

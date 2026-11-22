import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'input_status_changed_data.g.dart';

/// 输入状态Changed数据。
///
/// Input status changed data.
@JsonSerializable()
class InputStatusChangedData extends Equatable {
  /// 用户ID。
  ///
  /// User ID.
  final String userID;

  /// 会话ID。
  ///
  /// Conversation ID.
  final String conversationID;

  /// 平台ID 列表。
  ///
  /// Platform i ds.
  final List<int>? platformIDs;

  /// 创建 `InputStatusChangedData` 实例。
  ///
  /// Creates a `InputStatusChangedData` instance.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [conversationID] 会话ID / Conversation ID.
  /// - [platformIDs] 平台ID 列表 / Platform i ds.
  const InputStatusChangedData({
    required this.userID,
    required this.conversationID,
    this.platformIDs,
  });

  /// 从 JSON 字典反序列化实例（`InputStatusChangedData.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`InputStatusChangedData.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `InputStatusChangedData` 结果 / Resulting `InputStatusChangedData`.
  factory InputStatusChangedData.fromJson(Map<String, dynamic> json) =>
      _$InputStatusChangedDataFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$InputStatusChangedDataToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [conversationID] 会话ID / Conversation ID.
  /// - [platformIDs] 平台ID 列表 / Platform i ds.
  /// - Returns: `InputStatusChangedData` 结果 / Resulting `InputStatusChangedData`.
  InputStatusChangedData copyWith({
    String? userID,
    String? conversationID,
    List<int>? platformIDs,
  }) {
    return InputStatusChangedData(
      userID: userID ?? this.userID,
      conversationID: conversationID ?? this.conversationID,
      platformIDs: platformIDs ?? this.platformIDs,
    );
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[userID, conversationID, platformIDs];
}

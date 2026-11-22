import 'package:equatable/equatable.dart';

/// 笔记信息
///
/// Note info.
class NoteInfo extends Equatable {
  /// 创建 `NoteInfo` 实例。
  ///
  /// Creates a `NoteInfo` instance.
  ///
  /// - [noteID] 笔记ID / Note ID.
  /// - [summary] 摘要 / Summary.
  /// - [content] 内容 / Content.
  /// - [createdAt] 创建时间@提及 / Created @-mention.
  const NoteInfo({
    required this.noteID,
    required this.summary,
    required this.content,
    required this.createdAt,
  });

  /// 笔记ID。
  ///
  /// Note ID.
  final String noteID;

  /// 摘要。
  ///
  /// Summary.
  final String summary;

  /// 内容。
  ///
  /// Content.
  final String content;

  /// 创建时间@提及。
  ///
  /// Created @-mention.
  final String createdAt;

  /// 从 JSON 字典反序列化实例（`NoteInfo.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`NoteInfo.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `NoteInfo` 结果 / Resulting `NoteInfo`.
  factory NoteInfo.fromJson(Map<String, dynamic> json) {
    return NoteInfo(
      noteID: json['noteID']?.toString() ?? '',
      summary: json['summary']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'noteID': noteID,
      'summary': summary,
      'content': content,
      'createdAt': createdAt,
    };
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[noteID, summary, content, createdAt];
}

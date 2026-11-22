import 'package:equatable/equatable.dart';

import '../enums/visible_type.dart';
import 'moment_media.dart';

/// 发布朋友圈请求
///
/// Moment create request.
class MomentCreateReq extends Equatable {
  /// 创建 `MomentCreateReq` 实例。
  ///
  /// Creates a `MomentCreateReq` instance.
  ///
  /// - [content] 内容 / Content.
  /// - [media] 媒体 / Media.
  /// - [visibleType] 可见类型 / Visible type.
  /// - [visibleGroupIDs] 可见群组ID 列表 / Visible group i ds.
  /// - [extra] 扩展信息 / Extra data.
  const MomentCreateReq({
    required this.content,
    this.media = const <MomentMedia>[],
    required this.visibleType,
    this.visibleGroupIDs = const <String>[],
    this.extra = '',
  });

  /// 内容。
  ///
  /// Content.
  final String content;

  /// 媒体。
  ///
  /// Media.
  final List<MomentMedia> media;

  /// 可见类型。
  ///
  /// Visible type.
  final VisibleType visibleType;

  /// 可见群组ID 列表。
  ///
  /// Visible group i ds.
  final List<String> visibleGroupIDs;

  /// 扩展信息。
  ///
  /// Extra data.
  final String extra;

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'content': content,
      if (media.isNotEmpty) 'media': media.map((MomentMedia m) => m.toJson()).toList(),
      'visibleType': visibleType.value,
      if (visibleGroupIDs.isNotEmpty) 'visibleGroupIDs': visibleGroupIDs,
      'extra': extra,
    };
  }

  /// 从 JSON 字典反序列化实例（`MomentCreateReq.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`MomentCreateReq.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `MomentCreateReq` 结果 / Resulting `MomentCreateReq`.
  factory MomentCreateReq.fromJson(Map<String, dynamic> json) {
    return MomentCreateReq(
      content: json['content'] as String? ?? '',
      media:
          (json['media'] as List<dynamic>?)
              ?.map<MomentMedia>((dynamic e) => MomentMedia.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <MomentMedia>[],
      visibleType: VisibleType.values.firstWhere(
        (VisibleType v) => v.value == (json['visibleType'] as int? ?? 1),
        orElse: () => VisibleType.friend,
      ),
      visibleGroupIDs:
          (json['visibleGroupIDs'] as List<dynamic>?)?.cast<String>() ?? const <String>[],
      extra: json['extra'] as String? ?? '',
    );
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[content, media, visibleType, visibleGroupIDs, extra];
}

import 'package:equatable/equatable.dart';

import '../enums/visible_type.dart';
import 'moment_comment.dart';
import 'moment_like.dart';
import 'moment_media.dart';

/// 朋友圈动态（含互动信息）
///
/// Moment info.
class MomentInfo extends Equatable {
  /// 创建 `MomentInfo` 实例。
  ///
  /// Creates a `MomentInfo` instance.
  ///
  /// - [momentID] 朋友圈动态ID / Moment ID.
  /// - [userID] 用户ID / User ID.
  /// - [content] 内容 / Content.
  /// - [media] 媒体 / Media.
  /// - [visibleType] 可见类型 / Visible type.
  /// - [visibleGroupIDs] 可见群组ID 列表 / Visible group i ds.
  /// - [status] 状态 / Status.
  /// - [createTime] 创建时间戳 / Create timestamp.
  /// - [updateTime] 更新时间戳 / Update timestamp.
  /// - [likeCount] 点赞数量 / Like count.
  /// - [commentCount] 评论数量 / Comment count.
  /// - [extra] 扩展信息 / Extra data.
  /// - [likes] 点赞列表 / Likes.
  /// - [comments] 评论列表 / Comments.
  const MomentInfo({
    required this.momentID,
    required this.userID,
    required this.content,
    required this.media,
    required this.visibleType,
    required this.visibleGroupIDs,
    required this.status,
    required this.createTime,
    required this.updateTime,
    required this.likeCount,
    required this.commentCount,
    required this.extra,
    required this.likes,
    required this.comments,
  });

  /// 朋友圈动态ID。
  ///
  /// Moment ID.
  final String momentID;

  /// 用户ID。
  ///
  /// User ID.
  final String userID;

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

  /// 状态。
  ///
  /// Status.
  final int status;

  /// 创建时间戳。
  ///
  /// Create timestamp.
  final String createTime;

  /// 更新时间戳。
  ///
  /// Update timestamp.
  final String updateTime;

  /// 点赞数量。
  ///
  /// Like count.
  final int likeCount;

  /// 评论数量。
  ///
  /// Comment count.
  final int commentCount;

  /// 扩展信息。
  ///
  /// Extra data.
  final String extra;

  /// 点赞列表。
  ///
  /// Likes.
  final List<MomentLikeWithUser> likes;

  /// 评论列表。
  ///
  /// Comments.
  final List<MomentCommentWithUser> comments;

  /// 从 JSON 字典反序列化实例（`MomentInfo.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`MomentInfo.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `MomentInfo` 结果 / Resulting `MomentInfo`.
  factory MomentInfo.fromJson(Map<String, dynamic> json) {
    return MomentInfo(
      momentID: json['momentID']?.toString() ?? '',
      userID: json['userID']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      media: _parseMedia(json['media']),
      visibleType: _parseVisibleType(json['visibleType']),
      visibleGroupIDs: _parseStringList(json['visibleGroupIDs']),
      status: _toInt(json['status']) ?? 0,
      createTime: json['createTime']?.toString() ?? '',
      updateTime: json['updateTime']?.toString() ?? '',
      likeCount: _toInt(json['likeCount']) ?? 0,
      commentCount: _toInt(json['commentCount']) ?? 0,
      extra: json['extra']?.toString() ?? '',
      likes: _parseLikes(json['likes']),
      comments: _parseComments(json['comments']),
    );
  }

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [likes] 点赞列表 / Likes.
  /// - [comments] 评论列表 / Comments.
  /// - [likeCount] 点赞数量 / Like count.
  /// - [commentCount] 评论数量 / Comment count.
  /// - Returns: `MomentInfo` 结果 / Resulting `MomentInfo`.
  MomentInfo copyWith({
    List<MomentLikeWithUser>? likes,
    List<MomentCommentWithUser>? comments,
    int? likeCount,
    int? commentCount,
  }) {
    return MomentInfo(
      momentID: momentID,
      userID: userID,
      content: content,
      media: media,
      visibleType: visibleType,
      visibleGroupIDs: visibleGroupIDs,
      status: status,
      createTime: createTime,
      updateTime: updateTime,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      extra: extra,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
    );
  }

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'momentID': momentID,
      'userID': userID,
      'content': content,
      'media': media.map((MomentMedia item) => item.toJson()).toList(),
      'visibleType': visibleType.value,
      'visibleGroupIDs': visibleGroupIDs,
      'status': status,
      'createTime': createTime,
      'updateTime': updateTime,
      'likeCount': likeCount,
      'commentCount': commentCount,
      'extra': extra,
      'likes': likes.map((MomentLikeWithUser item) => item.toJson()).toList(),
      'comments': comments.map((MomentCommentWithUser item) => item.toJson()).toList(),
    };
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[
    momentID,
    userID,
    content,
    media,
    visibleType,
    visibleGroupIDs,
    status,
    createTime,
    updateTime,
    likeCount,
    commentCount,
    extra,
    likes,
    comments,
  ];
}

VisibleType _parseVisibleType(dynamic value) {
  if (value is int) {
    return VisibleType.values.firstWhere(
      (VisibleType item) => item.value == value,
      orElse: () => VisibleType.friend,
    );
  }
  return VisibleType.friend;
}

List<MomentMedia> _parseMedia(dynamic value) {
  if (value is List<dynamic>) {
    return value
        .whereType<Map<dynamic, dynamic>>()
        .map<MomentMedia>(
          (Map<dynamic, dynamic> item) => MomentMedia.fromJson(item.cast<String, dynamic>()),
        )
        .toList();
  }
  return <MomentMedia>[];
}

List<MomentLikeWithUser> _parseLikes(dynamic value) {
  if (value is List<dynamic>) {
    return value
        .whereType<Map<dynamic, dynamic>>()
        .map<MomentLikeWithUser>(
          (Map<dynamic, dynamic> item) => MomentLikeWithUser.fromJson(item.cast<String, dynamic>()),
        )
        .toList();
  }
  return <MomentLikeWithUser>[];
}

List<MomentCommentWithUser> _parseComments(dynamic value) {
  if (value is List<dynamic>) {
    return value
        .whereType<Map<dynamic, dynamic>>()
        .map<MomentCommentWithUser>(
          (Map<dynamic, dynamic> item) =>
              MomentCommentWithUser.fromJson(item.cast<String, dynamic>()),
        )
        .toList();
  }
  return <MomentCommentWithUser>[];
}

List<String> _parseStringList(dynamic value) {
  if (value is List<dynamic>) {
    return value.map<String>((dynamic item) => item.toString()).toList();
  }
  return <String>[];
}

int? _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

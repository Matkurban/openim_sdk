import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../enums/visible_type.dart';
import 'moment_comment.dart';
import 'moment_like.dart';
import 'moment_media.dart';
import 'moment_user_info.dart';

/// 朋友圈动态（含互动信息与全局时序序号）。
///
/// Moment info with interaction summaries and timeline sequence numbers.
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
  /// - [visibleGroupIDs] 可见群组ID 列表 / Visible group IDs.
  /// - [status] 状态 / Status.
  /// - [createTime] 创建时间戳 / Create timestamp.
  /// - [updateTime] 更新时间戳 / Update timestamp.
  /// - [likeCount] 点赞数量 / Like count.
  /// - [commentCount] 评论数量 / Comment count.
  /// - [extra] 扩展信息 / Extra data.
  /// - [likes] 点赞列表 / Likes.
  /// - [comments] 评论列表 / Comments.
  /// - [timelineSeq] 全局严格单调递增的时间线发布序号 / Monotonic timeline publish sequence number.
  /// - [updateSeq] 全局增量同步变更序号 / Monotonic mutation sync sequence number.
  /// - [userInfo] 发布者信息 / Author user info.
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
    this.timelineSeq = 0,
    this.updateSeq = 0,
    this.userInfo,
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
  /// Visible group IDs.
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

  /// 全局严格单调递增的时间线发布序号（用于严格时序排序与游标分页）。
  ///
  /// Globally monotonic timeline publish sequence number used for ordering and cursor paging.
  final int timelineSeq;

  /// 全局增量同步变更序号（发布、删除、点赞、评论时递增）。
  ///
  /// Globally monotonic mutation sequence number bumped on publish, delete, like, or comment.
  final int updateSeq;

  /// 发布者信息。
  ///
  /// Author user info.
  final MomentUserInfo? userInfo;

  /// 创建时间对应的毫秒级 Unix 时间戳（无法解析时返回 `0`）。
  ///
  /// Milliseconds since epoch parsed from [createTime], or `0` if unavailable.
  int get createTimeMs {
    if (createTime.isEmpty) {
      return 0;
    }
    final int? numeric = int.tryParse(createTime);
    if (numeric != null) {
      return numeric > 100000000000 ? numeric : numeric * 1000;
    }
    final DateTime? parsed = DateTime.tryParse(createTime);
    return parsed?.millisecondsSinceEpoch ?? 0;
  }

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
      timelineSeq: _toInt(json['timelineSeq']) ?? 0,
      updateSeq: _toInt(json['updateSeq']) ?? 0,
      userInfo: _parseUserInfo(json['userInfo']),
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
  /// - [timelineSeq] 时间线序号 / Timeline sequence number.
  /// - [updateSeq] 增量同步序号 / Update sequence number.
  /// - [userInfo] 发布者信息 / Author user info.
  /// - [status] 状态 / Status.
  /// - [updateTime] 更新时间戳 / Update timestamp.
  /// - Returns: `MomentInfo` 结果 / Resulting `MomentInfo`.
  MomentInfo copyWith({
    List<MomentLikeWithUser>? likes,
    List<MomentCommentWithUser>? comments,
    int? likeCount,
    int? commentCount,
    int? timelineSeq,
    int? updateSeq,
    MomentUserInfo? userInfo,
    int? status,
    String? updateTime,
  }) {
    return MomentInfo(
      momentID: momentID,
      userID: userID,
      content: content,
      media: media,
      visibleType: visibleType,
      visibleGroupIDs: visibleGroupIDs,
      status: status ?? this.status,
      createTime: createTime,
      updateTime: updateTime ?? this.updateTime,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      extra: extra,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      timelineSeq: timelineSeq ?? this.timelineSeq,
      updateSeq: updateSeq ?? this.updateSeq,
      userInfo: userInfo ?? this.userInfo,
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
      'timelineSeq': timelineSeq,
      'updateSeq': updateSeq,
      if (userInfo != null) 'userInfo': userInfo!.toJson(),
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
    timelineSeq,
    updateSeq,
    userInfo,
  ];
}

VisibleType _parseVisibleType(dynamic value) {
  final int? parsed = _toInt(value);
  if (parsed != null) {
    return VisibleType.values.firstWhere(
      (VisibleType item) => item.value == parsed,
      orElse: () => VisibleType.friend,
    );
  }
  return VisibleType.friend;
}

dynamic _decodeJsonIfString(dynamic value) {
  if (value is String && value.isNotEmpty) {
    try {
      return jsonDecode(value);
    } on FormatException {
      return value;
    }
  }
  return value;
}

MomentUserInfo? _parseUserInfo(dynamic value) {
  final dynamic decoded = _decodeJsonIfString(value);
  if (decoded is Map<dynamic, dynamic>) {
    return MomentUserInfo.fromJson(decoded.cast<String, dynamic>());
  }
  return null;
}

List<MomentMedia> _parseMedia(dynamic value) {
  final dynamic decoded = _decodeJsonIfString(value);
  if (decoded is List<dynamic>) {
    return decoded
        .whereType<Map<dynamic, dynamic>>()
        .map<MomentMedia>(
          (Map<dynamic, dynamic> item) => MomentMedia.fromJson(item.cast<String, dynamic>()),
        )
        .toList();
  }
  return <MomentMedia>[];
}

List<MomentLikeWithUser> _parseLikes(dynamic value) {
  final dynamic decoded = _decodeJsonIfString(value);
  if (decoded is List<dynamic>) {
    return decoded
        .whereType<Map<dynamic, dynamic>>()
        .map<MomentLikeWithUser>(
          (Map<dynamic, dynamic> item) => MomentLikeWithUser.fromJson(item.cast<String, dynamic>()),
        )
        .toList();
  }
  return <MomentLikeWithUser>[];
}

List<MomentCommentWithUser> _parseComments(dynamic value) {
  final dynamic decoded = _decodeJsonIfString(value);
  if (decoded is List<dynamic>) {
    return decoded
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
  final dynamic decoded = _decodeJsonIfString(value);
  if (decoded is List<dynamic>) {
    return decoded.map<String>((dynamic item) => item.toString()).toList();
  }
  return <String>[];
}

int? _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

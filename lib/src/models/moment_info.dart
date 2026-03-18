import 'package:equatable/equatable.dart';

import '../enums/visible_type.dart';
import 'moment_comment.dart';
import 'moment_like.dart';
import 'moment_media.dart';

/// 朋友圈动态（含互动信息）
class MomentInfo extends Equatable {
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

  final String momentID;
  final String userID;
  final String content;
  final List<MomentMedia> media;
  final VisibleType visibleType;
  final List<String> visibleGroupIDs;
  final int status;
  final String createTime;
  final String updateTime;
  final int likeCount;
  final int commentCount;
  final String extra;
  final List<MomentLikeWithUser> likes;
  final List<MomentCommentWithUser> comments;

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

  Map<String, dynamic> toJson() {
    return {
      'momentID': momentID,
      'userID': userID,
      'content': content,
      'media': media.map((item) => item.toJson()).toList(),
      'visibleType': visibleType.value,
      'visibleGroupIDs': visibleGroupIDs,
      'status': status,
      'createTime': createTime,
      'updateTime': updateTime,
      'likeCount': likeCount,
      'commentCount': commentCount,
      'extra': extra,
      'likes': likes.map((item) => item.toJson()).toList(),
      'comments': comments.map((item) => item.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
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
      (item) => item.value == value,
      orElse: () => VisibleType.friend,
    );
  }
  return VisibleType.friend;
}

List<MomentMedia> _parseMedia(dynamic value) {
  if (value is List) {
    return value
        .whereType<Map>()
        .map((item) => MomentMedia.fromJson(item.cast<String, dynamic>()))
        .toList();
  }
  return <MomentMedia>[];
}

List<MomentLikeWithUser> _parseLikes(dynamic value) {
  if (value is List) {
    return value
        .whereType<Map>()
        .map((item) => MomentLikeWithUser.fromJson(item.cast<String, dynamic>()))
        .toList();
  }
  return <MomentLikeWithUser>[];
}

List<MomentCommentWithUser> _parseComments(dynamic value) {
  if (value is List) {
    return value
        .whereType<Map>()
        .map((item) => MomentCommentWithUser.fromJson(item.cast<String, dynamic>()))
        .toList();
  }
  return <MomentCommentWithUser>[];
}

List<String> _parseStringList(dynamic value) {
  if (value is List) {
    return value.map((item) => item.toString()).toList();
  }
  return <String>[];
}

int? _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

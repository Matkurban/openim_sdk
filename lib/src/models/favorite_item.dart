import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'favorite_type.dart';
import 'link_info.dart';
import 'message.dart';
import 'moment_info.dart';
import 'moment_comment.dart';
import 'note_info.dart';

/// 收藏项
class FavoriteItem extends Equatable {
  const FavoriteItem({
    required this.favoriteID,
    required this.userID,
    required this.favoriteType,
    required this.targetID,
    required this.data,
    required this.createTime,
    this.message,
    this.momentInfo,
    this.momentComment,
    this.linkInfo,
    this.noteInfo,
  });

  final String favoriteID;
  final String userID;
  final FavoriteType favoriteType;
  final String targetID;
  final String data;
  final int createTime;

  /// 收藏的消息（当 favoriteType == FavoriteType.message 时可用）
  final Message? message;

  /// 收藏的朋友圈动态（当 favoriteType == FavoriteType.momentContent 时可用）
  final MomentInfo? momentInfo;

  /// 收藏的朋友圈评论（当 favoriteType == FavoriteType.momentComment 时可用）
  final MomentCommentWithUser? momentComment;

  /// 收藏的链接（当 favoriteType == FavoriteType.link 时可用）
  final LinkInfo? linkInfo;

  /// 收藏的笔记（当 favoriteType == FavoriteType.note 时可用）
  final NoteInfo? noteInfo;

  /// 兼容旧版 targetType 字段
  String get targetType => favoriteType.value;

  /// 返回毫秒级时间戳（自动处理秒级/毫秒级）
  int get createTimeMs {
    if (createTime < 4102444800) {
      return createTime * 1000;
    }
    return createTime;
  }

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    final type = FavoriteType.fromValue(
      json['targetType']?.toString() ?? json['favoriteType']?.toString(),
    );
    final rawData = _parseData(json['data']);
    final dataMap = _tryDecodeJson(rawData);

    return FavoriteItem(
      favoriteID: json['favoriteID']?.toString() ?? '',
      userID: json['userID']?.toString() ?? '',
      favoriteType: type,
      targetID: json['targetID']?.toString() ?? '',
      data: rawData,
      createTime: _parseCreateTime(json['createTime']),
      message: type == FavoriteType.message && dataMap != null ? _tryParseMessage(dataMap) : null,
      momentInfo: type == FavoriteType.momentContent && dataMap != null
          ? _tryParseMomentInfo(dataMap)
          : null,
      momentComment: type == FavoriteType.momentComment && dataMap != null
          ? _tryParseMomentComment(dataMap)
          : null,
      linkInfo: type == FavoriteType.link && dataMap != null ? _tryParseLinkInfo(dataMap) : null,
      noteInfo: type == FavoriteType.note && dataMap != null ? NoteInfo.fromJson(dataMap) : null,
    );
  }

  /// 快速创建消息收藏
  factory FavoriteItem.fromMessage({
    required String favoriteID,
    required String userID,
    required Message msg,
  }) {
    final dataJson = jsonEncode(msg.toJson());
    return FavoriteItem(
      favoriteID: favoriteID,
      userID: userID,
      favoriteType: FavoriteType.message,
      targetID: msg.clientMsgID ?? '',
      data: dataJson,
      createTime: DateTime.now().millisecondsSinceEpoch,
      message: msg,
    );
  }

  /// 快速创建朋友圈动态收藏
  factory FavoriteItem.fromMoment({
    required String favoriteID,
    required String userID,
    required MomentInfo moment,
  }) {
    final dataJson = jsonEncode(moment.toJson());
    return FavoriteItem(
      favoriteID: favoriteID,
      userID: userID,
      favoriteType: FavoriteType.momentContent,
      targetID: moment.momentID,
      data: dataJson,
      createTime: DateTime.now().millisecondsSinceEpoch,
      momentInfo: moment,
    );
  }

  /// 快速创建朋友圈评论收藏
  factory FavoriteItem.fromMomentComment({
    required String favoriteID,
    required String userID,
    required MomentCommentWithUser comment,
  }) {
    final dataJson = jsonEncode(comment.toJson());
    return FavoriteItem(
      favoriteID: favoriteID,
      userID: userID,
      favoriteType: FavoriteType.momentComment,
      targetID: comment.commentID,
      data: dataJson,
      createTime: DateTime.now().millisecondsSinceEpoch,
      momentComment: comment,
    );
  }

  /// 快速创建笔记收藏
  factory FavoriteItem.fromNote({
    required String favoriteID,
    required String userID,
    required NoteInfo note,
  }) {
    final dataJson = jsonEncode(note.toJson());
    return FavoriteItem(
      favoriteID: favoriteID,
      userID: userID,
      favoriteType: FavoriteType.note,
      targetID: note.noteID,
      data: dataJson,
      createTime: DateTime.now().millisecondsSinceEpoch,
      noteInfo: note,
    );
  }

  /// 快速创建链接收藏
  factory FavoriteItem.fromLink({
    required String favoriteID,
    required String userID,
    required LinkInfo link,
  }) {
    final dataJson = jsonEncode(link.toJson());
    return FavoriteItem(
      favoriteID: favoriteID,
      userID: userID,
      favoriteType: FavoriteType.link,
      targetID: link.url,
      data: dataJson,
      createTime: DateTime.now().millisecondsSinceEpoch,
      linkInfo: link,
    );
  }

  static String _parseData(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    if (value is Map || value is List) {
      return jsonEncode(value);
    }
    return value.toString();
  }

  static int _parseCreateTime(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) {
      final intValue = int.tryParse(value);
      if (intValue != null) return intValue;
      final dateTime = DateTime.tryParse(value);
      if (dateTime != null) return dateTime.millisecondsSinceEpoch;
    }
    return 0;
  }

  static Map<String, dynamic>? _tryDecodeJson(String data) {
    if (data.isEmpty) return null;
    try {
      final decoded = jsonDecode(data);
      if (decoded is Map<String, dynamic>) return decoded;
    } catch (_) {}
    return null;
  }

  static Message? _tryParseMessage(Map<String, dynamic> map) {
    try {
      // data 中可能直接是 Message JSON，也可能包裹在 messageData 字段中
      final msgData = map['messageData'] as Map<String, dynamic>? ?? map;
      return Message.fromJson(msgData);
    } catch (_) {
      return null;
    }
  }

  static MomentInfo? _tryParseMomentInfo(Map<String, dynamic> map) {
    try {
      return MomentInfo.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  static MomentCommentWithUser? _tryParseMomentComment(Map<String, dynamic> map) {
    try {
      return MomentCommentWithUser.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  static LinkInfo? _tryParseLinkInfo(Map<String, dynamic> map) {
    try {
      return LinkInfo.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'favoriteID': favoriteID,
      'userID': userID,
      'targetType': favoriteType.value,
      'targetID': targetID,
      'data': data,
      'createTime': createTime,
    };
  }

  @override
  List<Object?> get props => [
    favoriteID,
    userID,
    favoriteType,
    targetID,
    data,
    createTime,
    message,
    momentInfo,
    momentComment,
    linkInfo,
    noteInfo,
  ];
}

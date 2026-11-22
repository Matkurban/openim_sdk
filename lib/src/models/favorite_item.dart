import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'favorite_type.dart';
import 'link_info.dart';
import 'message.dart';
import 'moment_info.dart';
import 'moment_comment.dart';
import 'note_info.dart';

/// 收藏项
///
/// Favorite item.
class FavoriteItem extends Equatable {
  /// 创建 `FavoriteItem` 实例。
  ///
  /// Creates a `FavoriteItem` instance.
  ///
  /// - [favoriteID] 收藏ID / Favorite ID.
  /// - [userID] 用户ID / User ID.
  /// - [favoriteType] 收藏类型 / Favorite type.
  /// - [targetID] 目标ID / Target ID.
  /// - [data] 数据 / Data.
  /// - [createTime] 创建时间戳 / Create timestamp.
  /// - [message] 消息 / Message.
  /// - [momentInfo] 朋友圈动态信息 / Moment info.
  /// - [momentComment] 朋友圈动态评论 / Moment comment.
  /// - [linkInfo] 链接信息 / Link info.
  /// - [noteInfo] 笔记信息 / Note info.
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

  /// 收藏ID。
  ///
  /// Favorite ID.
  final String favoriteID;

  /// 用户ID。
  ///
  /// User ID.
  final String userID;

  /// 收藏类型。
  ///
  /// Favorite type.
  final FavoriteType favoriteType;

  /// 目标ID。
  ///
  /// Target ID.
  final String targetID;

  /// 数据。
  ///
  /// Data.
  final String data;

  /// 创建时间戳。
  ///
  /// Create timestamp.
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
  ///
  /// Create timestamp ms.
  int get createTimeMs {
    if (createTime < 4102444800) {
      return createTime * 1000;
    }
    return createTime;
  }

  /// 从 JSON 字典反序列化实例（`FavoriteItem.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`FavoriteItem.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `FavoriteItem` 结果 / Resulting `FavoriteItem`.
  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    final FavoriteType type = FavoriteType.fromValue(
      json['targetType']?.toString() ?? json['favoriteType']?.toString(),
    );
    final String rawData = _parseData(json['data']);
    final Map<String, dynamic>? dataMap = _tryDecodeJson(rawData);

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
  ///
  /// From message (`FavoriteItem.fromMessage`).
  ///
  /// - [favoriteID] 收藏ID / Favorite ID.
  /// - [userID] 用户ID / User ID.
  /// - [msg] 消息 / Message.
  /// - Returns: `FavoriteItem` 结果 / Resulting `FavoriteItem`.
  factory FavoriteItem.fromMessage({
    required String favoriteID,
    required String userID,
    required Message msg,
  }) {
    final String dataJson = jsonEncode(msg.toJson());
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
  ///
  /// From moment (`FavoriteItem.fromMoment`).
  ///
  /// - [favoriteID] 收藏ID / Favorite ID.
  /// - [userID] 用户ID / User ID.
  /// - [moment] 朋友圈动态 / Moment.
  /// - Returns: `FavoriteItem` 结果 / Resulting `FavoriteItem`.
  factory FavoriteItem.fromMoment({
    required String favoriteID,
    required String userID,
    required MomentInfo moment,
  }) {
    final String dataJson = jsonEncode(moment.toJson());
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
  ///
  /// From moment comment (`FavoriteItem.fromMomentComment`).
  ///
  /// - [favoriteID] 收藏ID / Favorite ID.
  /// - [userID] 用户ID / User ID.
  /// - [comment] 评论 / Comment.
  /// - Returns: `FavoriteItem` 结果 / Resulting `FavoriteItem`.
  factory FavoriteItem.fromMomentComment({
    required String favoriteID,
    required String userID,
    required MomentCommentWithUser comment,
  }) {
    final String dataJson = jsonEncode(comment.toJson());
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
  ///
  /// From note (`FavoriteItem.fromNote`).
  ///
  /// - [favoriteID] 收藏ID / Favorite ID.
  /// - [userID] 用户ID / User ID.
  /// - [note] 笔记 / Note.
  /// - Returns: `FavoriteItem` 结果 / Resulting `FavoriteItem`.
  factory FavoriteItem.fromNote({
    required String favoriteID,
    required String userID,
    required NoteInfo note,
  }) {
    final String dataJson = jsonEncode(note.toJson());
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
  ///
  /// From link (`FavoriteItem.fromLink`).
  ///
  /// - [favoriteID] 收藏ID / Favorite ID.
  /// - [userID] 用户ID / User ID.
  /// - [link] 链接 / Link.
  /// - Returns: `FavoriteItem` 结果 / Resulting `FavoriteItem`.
  factory FavoriteItem.fromLink({
    required String favoriteID,
    required String userID,
    required LinkInfo link,
  }) {
    final String dataJson = jsonEncode(link.toJson());
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
      final int? intValue = int.tryParse(value);
      if (intValue != null) return intValue;
      final DateTime? dateTime = DateTime.tryParse(value);
      if (dateTime != null) return dateTime.millisecondsSinceEpoch;
    }
    return 0;
  }

  static Map<String, dynamic>? _tryDecodeJson(String data) {
    if (data.isEmpty) return null;
    try {
      final Object? decoded = jsonDecode(data);
      if (decoded is Map<String, dynamic>) return decoded;
    } catch (_) {}
    return null;
  }

  static Message? _tryParseMessage(Map<String, dynamic> map) {
    try {
      // data 中可能直接是 Message JSON，也可能包裹在 messageData 字段中
      final Map<String, dynamic> msgData = map['messageData'] as Map<String, dynamic>? ?? map;
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

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'favoriteID': favoriteID,
      'userID': userID,
      'targetType': favoriteType.value,
      'targetID': targetID,
      'data': data,
      'createTime': createTime,
    };
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[
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

import 'dart:convert';

/// 收藏项
class FavoriteItem {
  const FavoriteItem({
    required this.favoriteID,
    required this.userID,
    required this.targetType,
    required this.targetID,
    required this.data,
    required this.createTime,
  });

  final String favoriteID;
  final String userID;
  final String targetType;
  final String targetID;
  final String data;
  final int createTime;

  /// 返回毫秒级时间戳（自动处理秒级/毫秒级）
  int get createTimeMs {
    if (createTime < 4102444800) {
      return createTime * 1000;
    }
    return createTime;
  }

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
      favoriteID: json['favoriteID']?.toString() ?? '',
      userID: json['userID']?.toString() ?? '',
      targetType: json['targetType']?.toString() ?? '',
      targetID: json['targetID']?.toString() ?? '',
      data: _parseData(json['data']),
      createTime: _parseCreateTime(json['createTime']),
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

  Map<String, dynamic> toJson() {
    return {
      'favoriteID': favoriteID,
      'userID': userID,
      'targetType': targetType,
      'targetID': targetID,
      'data': data,
      'createTime': createTime,
    };
  }
}

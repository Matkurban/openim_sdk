import 'package:equatable/equatable.dart';

import 'favorite_item.dart';

/// 收藏列表分页响应
///
/// Favorite list response.
class FavoriteListResponse extends Equatable {
  /// 创建 `FavoriteListResponse` 实例。
  ///
  /// Creates a `FavoriteListResponse` instance.
  ///
  /// - [total] 总计 / Total.
  /// - [favorites] 收藏列表 / Favorites.
  const FavoriteListResponse({required this.total, required this.favorites});

  /// 总计。
  ///
  /// Total.
  final int total;

  /// 收藏列表。
  ///
  /// Favorites.
  final List<FavoriteItem> favorites;

  /// 从 JSON 字典反序列化实例（`FavoriteListResponse.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`FavoriteListResponse.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `FavoriteListResponse` 结果 / Resulting `FavoriteListResponse`.
  factory FavoriteListResponse.fromJson(Map<String, dynamic> json) {
    return FavoriteListResponse(
      total: _toInt(json['total']) ?? 0,
      favorites: _parseFavorites(json['favorites']),
    );
  }

  /// empty（`FavoriteListResponse.empty`）。
  ///
  /// Empty (`FavoriteListResponse.empty`).
  ///
  /// - Returns: `FavoriteListResponse` 结果 / Resulting `FavoriteListResponse`.
  factory FavoriteListResponse.empty() {
    return const FavoriteListResponse(total: 0, favorites: <FavoriteItem>[]);
  }

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'total': total,
      'favorites': favorites.map((FavoriteItem item) => item.toJson()).toList(),
    };
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[total, favorites];
}

List<FavoriteItem> _parseFavorites(dynamic value) {
  if (value is List<dynamic>) {
    return value
        .whereType<Map<dynamic, dynamic>>()
        .map<FavoriteItem>(
          (Map<dynamic, dynamic> item) => FavoriteItem.fromJson(item.cast<String, dynamic>()),
        )
        .toList();
  }
  return <FavoriteItem>[];
}

int? _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

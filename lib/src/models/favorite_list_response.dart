import 'favorite_item.dart';

/// 收藏列表分页响应
class FavoriteListResponse {
  const FavoriteListResponse({required this.total, required this.favorites});

  final int total;
  final List<FavoriteItem> favorites;

  factory FavoriteListResponse.fromJson(Map<String, dynamic> json) {
    return FavoriteListResponse(
      total: _toInt(json['total']) ?? 0,
      favorites: _parseFavorites(json['favorites']),
    );
  }

  factory FavoriteListResponse.empty() {
    return const FavoriteListResponse(total: 0, favorites: <FavoriteItem>[]);
  }

  Map<String, dynamic> toJson() {
    return {'total': total, 'favorites': favorites.map((item) => item.toJson()).toList()};
  }
}

List<FavoriteItem> _parseFavorites(dynamic value) {
  if (value is List) {
    return value
        .whereType<Map>()
        .map((item) => FavoriteItem.fromJson(item.cast<String, dynamic>()))
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

import 'package:equatable/equatable.dart';

import 'favorite_item.dart';

/// 收藏列表分页响应
class FavoriteListResponse extends Equatable {
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
    return <String, dynamic>{
      'total': total,
      'favorites': favorites.map((FavoriteItem item) => item.toJson()).toList(),
    };
  }

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

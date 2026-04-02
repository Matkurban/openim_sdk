import 'package:openim_sdk/src/models/favorite_item.dart';

/// 收藏夹监听器
class OnFavoriteListener {
  /// 新增收藏
  void Function(FavoriteItem item)? onFavoriteAdded;

  /// 移除收藏
  void Function(String targetType, String targetID)? onFavoriteRemoved;

  /// 更新收藏
  void Function(FavoriteItem item)? onFavoriteUpdated;

  OnFavoriteListener({this.onFavoriteAdded, this.onFavoriteRemoved, this.onFavoriteUpdated});

  void favoriteAdded(FavoriteItem item) {
    onFavoriteAdded?.call(item);
  }

  void favoriteRemoved(String targetType, String targetID) {
    onFavoriteRemoved?.call(targetType, targetID);
  }

  void favoriteUpdated(FavoriteItem item) {
    onFavoriteUpdated?.call(item);
  }
}

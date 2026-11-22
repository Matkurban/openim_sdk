import 'package:openim_sdk/src/models/favorite_item.dart';

/// 收藏夹变更事件监听器。
///
/// Favorites change event listener.
class OnFavoriteListener {
  /// 新增收藏回调 / Callback invoked when a favorite item is added.
  void Function(FavoriteItem item)? onFavoriteAdded;

  /// 移除收藏回调 / Callback invoked when a favorite item is removed.
  void Function(String targetType, String targetID)? onFavoriteRemoved;

  /// 更新收藏回调 / Callback invoked when a favorite item is updated.
  void Function(FavoriteItem item)? onFavoriteUpdated;

  /// 创建收藏夹监听器。
  ///
  /// Creates an [OnFavoriteListener].
  ///
  /// - [onFavoriteAdded] 新增收藏回调 / Favorite added callback.
  /// - [onFavoriteRemoved] 移除收藏回调 / Favorite removed callback.
  /// - [onFavoriteUpdated] 更新收藏回调 / Favorite updated callback.
  OnFavoriteListener({this.onFavoriteAdded, this.onFavoriteRemoved, this.onFavoriteUpdated});

  /// 触发新增收藏回调 / Dispatches [onFavoriteAdded].
  ///
  /// - [item] 新增的收藏项 / Newly added favorite item.
  void favoriteAdded(FavoriteItem item) {
    onFavoriteAdded?.call(item);
  }

  /// 触发移除收藏回调 / Dispatches [onFavoriteRemoved].
  ///
  /// - [targetType] 被移除收藏的类型标识 / Target type of the removed favorite.
  /// - [targetID] 被移除收藏的目标 ID / Target ID of the removed favorite.
  void favoriteRemoved(String targetType, String targetID) {
    onFavoriteRemoved?.call(targetType, targetID);
  }

  /// 触发更新收藏回调 / Dispatches [onFavoriteUpdated].
  ///
  /// - [item] 更新后的收藏项 / Updated favorite item.
  void favoriteUpdated(FavoriteItem item) {
    onFavoriteUpdated?.call(item);
  }
}

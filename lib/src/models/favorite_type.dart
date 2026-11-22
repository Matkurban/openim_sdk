/// 收藏类型
///
/// Favorite type enum.
enum FavoriteType {
  /// 聊天消息
  ///
  /// Message.
  message('message'),

  /// 朋友圈动态
  ///
  /// Moment content.
  momentContent('moment_content'),

  /// 朋友圈评论
  ///
  /// Moment comment.
  momentComment('moment_comment'),

  /// 链接
  ///
  /// Link.
  link('link'),

  /// 笔记
  ///
  /// Note.
  note('note');

  /// 创建 `FavoriteType` 实例。
  ///
  /// Creates a `FavoriteType` instance.
  ///
  /// - [value] 值 / Value.
  const FavoriteType(this.value);

  /// 值。
  ///
  /// Value.
  final String value;

  /// 从字符串值解析为枚举，未匹配时默认返回 [FavoriteType.message]
  ///
  /// - [value] 值 / Value.
  /// - Returns: `FavoriteType` 结果 / Resulting `FavoriteType`.
  static FavoriteType fromValue(String? value) {
    return FavoriteType.values.firstWhere(
      (FavoriteType e) => e.value == value,
      orElse: () => FavoriteType.message,
    );
  }
}

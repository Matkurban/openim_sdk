/// 收藏类型
enum FavoriteType {
  /// 聊天消息
  message('message'),

  /// 朋友圈动态
  momentContent('moment_content'),

  /// 朋友圈评论
  momentComment('moment_comment'),

  /// 链接
  link('link'),

  /// 笔记
  note('note');

  const FavoriteType(this.value);

  final String value;

  /// 从字符串值解析为枚举，未匹配时默认返回 [FavoriteType.message]
  static FavoriteType fromValue(String? value) {
    return FavoriteType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => FavoriteType.message,
    );
  }
}

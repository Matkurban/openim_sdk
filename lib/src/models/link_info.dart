import 'package:equatable/equatable.dart';

/// 链接信息
///
/// Link info.
class LinkInfo extends Equatable {
  /// 创建 `LinkInfo` 实例。
  ///
  /// Creates a `LinkInfo` instance.
  ///
  /// - [url] URL 地址 / URL.
  /// - [title] 标题 / Title.
  /// - [description] 描述 / Description.
  /// - [imageUrl] 图片URL 地址 / Image URL.
  const LinkInfo({required this.url, required this.title, this.description, this.imageUrl});

  /// 链接地址
  ///
  /// URL.
  final String url;

  /// 链接标题
  ///
  /// Title.
  final String title;

  /// 链接描述
  ///
  /// Description.
  final String? description;

  /// 链接预览图
  ///
  /// Image URL.
  final String? imageUrl;

  /// 从 JSON 字典反序列化实例（`LinkInfo.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`LinkInfo.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `LinkInfo` 结果 / Resulting `LinkInfo`.
  factory LinkInfo.fromJson(Map<String, dynamic> json) {
    return LinkInfo(
      url: json['url']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'url': url,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[url, title, description, imageUrl];
}

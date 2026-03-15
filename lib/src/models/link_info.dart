/// 链接信息
class LinkInfo {
  const LinkInfo({required this.url, required this.title, this.description, this.imageUrl});

  /// 链接地址
  final String url;

  /// 链接标题
  final String title;

  /// 链接描述
  final String? description;

  /// 链接预览图
  final String? imageUrl;

  factory LinkInfo.fromJson(Map<String, dynamic> json) {
    return LinkInfo(
      url: json['url']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'url': url, 'title': title, 'description': description, 'imageUrl': imageUrl};
  }
}

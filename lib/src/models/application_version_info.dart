import 'package:equatable/equatable.dart';

/// 应用版本信息（来自 openim-chat /application/latest_version）
class ApplicationVersionInfo extends Equatable {
  /// 创建 `ApplicationVersionInfo` 实例。
  ///
  /// Creates a `ApplicationVersionInfo` instance.
  ///
  /// - [id] ID / ID.
  /// - [platform] 平台 / Platform.
  /// - [version] 版本 / Version.
  /// - [url] URL 地址 / URL.
  /// - [text] 文本 / Text.
  /// - [force] 是否强制 / Whether forced.
  /// - [latest] 最新 / Latest.
  /// - [hot] hot / Hot.
  /// - [createTime] 创建时间戳 / Create timestamp.
  const ApplicationVersionInfo({
    required this.id,
    required this.platform,
    required this.version,
    required this.url,
    required this.text,
    required this.force,
    required this.latest,
    required this.hot,
    required this.createTime,
  });

  /// 记录 ID
  ///
  /// ID.
  final String id;

  /// 平台标识：android / ios / windows / macos / linux
  final String platform;

  /// 版本号（建议使用语义化版本，例如 1.2.3）
  ///
  /// Version.
  final String version;

  /// 安装包下载链接
  ///
  /// URL.
  final String url;

  /// 更新说明
  ///
  /// Text.
  final String text;

  /// 是否强制更新
  ///
  /// Whether forced.
  final bool force;

  /// 是否为最新版本
  ///
  /// Latest.
  final bool latest;

  /// 是否热更新
  ///
  /// Hot.
  final bool hot;

  /// 发布时间（毫秒时间戳）
  ///
  /// Create timestamp.
  final int createTime;

  /// 从 JSON 字典反序列化实例（`ApplicationVersionInfo.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`ApplicationVersionInfo.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `ApplicationVersionInfo` 结果 / Resulting `ApplicationVersionInfo`.
  factory ApplicationVersionInfo.fromJson(Map<String, dynamic> json) {
    return ApplicationVersionInfo(
      id: json['id']?.toString() ?? '',
      platform: json['platform']?.toString() ?? '',
      version: json['version']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      text: json['text']?.toString() ?? '',
      force: json['force'] == true,
      latest: json['latest'] == true,
      hot: json['hot'] == true,
      createTime: switch (json['createTime']) {
        final int v => v,
        final String v => int.tryParse(v) ?? 0,
        _ => 0,
      },
    );
  }

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'platform': platform,
    'version': version,
    'url': url,
    'text': text,
    'force': force,
    'latest': latest,
    'hot': hot,
    'createTime': createTime,
  };

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[
    id,
    platform,
    version,
    url,
    text,
    force,
    latest,
    hot,
    createTime,
  ];
}

import 'package:equatable/equatable.dart';

/// 应用版本信息（来自 openim-chat /application/latest_version）
class ApplicationVersionInfo extends Equatable {
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
  final String id;

  /// 平台标识：android / ios / windows / macos / linux
  final String platform;

  /// 版本号（建议使用语义化版本，例如 1.2.3）
  final String version;

  /// 安装包下载链接
  final String url;

  /// 更新说明
  final String text;

  /// 是否强制更新
  final bool force;

  /// 是否为最新版本
  final bool latest;

  /// 是否热更新
  final bool hot;

  /// 发布时间（毫秒时间戳）
  final int createTime;

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

  Map<String, dynamic> toJson() => {
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

  @override
  List<Object?> get props => [id, platform, version, url, text, force, latest, hot, createTime];
}

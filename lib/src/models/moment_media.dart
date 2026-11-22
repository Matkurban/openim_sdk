import 'package:equatable/equatable.dart';

/// 朋友圈媒体（图片/视频）
///
/// Moment media.
class MomentMedia extends Equatable {
  /// 创建 `MomentMedia` 实例。
  ///
  /// Creates a `MomentMedia` instance.
  ///
  /// - [type] 类型 / Type.
  /// - [url] URL 地址 / URL.
  /// - [localPath] 本地路径 / Local path.
  /// - [localCoverPath] 本地Cover路径 / Local cover path.
  /// - [coverUrl] coverURL 地址 / Cover URL.
  /// - [duration] 时长 / Duration.
  /// - [extra] 扩展信息 / Extra data.
  const MomentMedia({
    required this.type,
    required this.url,
    this.localPath,
    this.localCoverPath,
    this.coverUrl,
    this.duration,
    this.extra,
  });

  /// 类型。
  ///
  /// Type.
  final String type;

  /// URL 地址。
  ///
  /// URL.
  final String url;

  /// 上传前的本地文件路径
  ///
  /// Local path.
  final String? localPath;

  /// 上传前的视频封面本地路径
  ///
  /// Local cover path.
  final String? localCoverPath;

  /// coverURL 地址。
  ///
  /// Cover URL.
  final String? coverUrl;

  /// 时长。
  ///
  /// Duration.
  final int? duration;

  /// 扩展信息。
  ///
  /// Extra data.
  final String? extra;

  /// 是否视频。
  ///
  /// Whether video.
  bool get isVideo => type == 'video';

  /// 是否需要上传（url 为空且有本地路径）
  bool get needsUpload => url.isEmpty && localPath != null;

  /// 从 JSON 字典反序列化实例（`MomentMedia.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`MomentMedia.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `MomentMedia` 结果 / Resulting `MomentMedia`.
  factory MomentMedia.fromJson(Map<String, dynamic> json) {
    return MomentMedia(
      type: json['type']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      coverUrl: json['coverURL']?.toString(),
      duration: _toInt(json['duration']),
      extra: json['extra']?.toString(),
    );
  }

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': type,
      'url': url,
      if (coverUrl != null) 'coverURL': coverUrl,
      if (duration != null) 'duration': duration,
      if (extra != null) 'extra': extra,
    };
  }

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [type] 类型 / Type.
  /// - [url] URL 地址 / URL.
  /// - [localPath] 本地路径 / Local path.
  /// - [localCoverPath] 本地Cover路径 / Local cover path.
  /// - [coverUrl] coverURL 地址 / Cover URL.
  /// - [duration] 时长 / Duration.
  /// - [extra] 扩展信息 / Extra data.
  /// - Returns: `MomentMedia` 结果 / Resulting `MomentMedia`.
  MomentMedia copyWith({
    String? type,
    String? url,
    String? localPath,
    String? localCoverPath,
    String? coverUrl,
    int? duration,
    String? extra,
  }) {
    return MomentMedia(
      type: type ?? this.type,
      url: url ?? this.url,
      localPath: localPath ?? this.localPath,
      localCoverPath: localCoverPath ?? this.localCoverPath,
      coverUrl: coverUrl ?? this.coverUrl,
      duration: duration ?? this.duration,
      extra: extra ?? this.extra,
    );
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[
    type,
    url,
    localPath,
    localCoverPath,
    coverUrl,
    duration,
    extra,
  ];
}

int? _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

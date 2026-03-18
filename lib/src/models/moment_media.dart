import 'package:equatable/equatable.dart';

/// 朋友圈媒体（图片/视频）
class MomentMedia extends Equatable {
  const MomentMedia({
    required this.type,
    required this.url,
    this.localPath,
    this.localCoverPath,
    this.coverUrl,
    this.duration,
    this.extra,
  });

  final String type;
  final String url;

  /// 上传前的本地文件路径
  final String? localPath;

  /// 上传前的视频封面本地路径
  final String? localCoverPath;

  final String? coverUrl;
  final int? duration;
  final String? extra;

  bool get isVideo => type == 'video';

  /// 是否需要上传（url 为空且有本地路径）
  bool get needsUpload => url.isEmpty && localPath != null;

  factory MomentMedia.fromJson(Map<String, dynamic> json) {
    return MomentMedia(
      type: json['type']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      coverUrl: json['coverURL']?.toString(),
      duration: _toInt(json['duration']),
      extra: json['extra']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'url': url,
      if (coverUrl != null) 'coverURL': coverUrl,
      if (duration != null) 'duration': duration,
      if (extra != null) 'extra': extra,
    };
  }

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

  @override
  List<Object?> get props => [type, url, localPath, localCoverPath, coverUrl, duration, extra];
}

int? _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

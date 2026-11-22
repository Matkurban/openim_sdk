part of '../message.dart';

/// 图片元素。
///
/// Image message content
@JsonSerializable()
class PictureElem extends Equatable {
  /// 来源路径。
  ///
  /// Source path.
  final String? sourcePath;

  /// 来源图片。
  ///
  /// Source picture.
  final PictureInfo? sourcePicture;

  /// big图片。
  ///
  /// Big picture.
  final PictureInfo? bigPicture;

  /// 缩略图图片。
  ///
  /// Snapshot picture.
  final PictureInfo? snapshotPicture;

  /// 创建 `PictureElem` 实例。
  ///
  /// Creates a `PictureElem` instance.
  ///
  /// - [sourcePath] 来源路径 / Source path.
  /// - [sourcePicture] 来源图片 / Source picture.
  /// - [bigPicture] big图片 / Big picture.
  /// - [snapshotPicture] 缩略图图片 / Snapshot picture.
  const PictureElem({this.sourcePath, this.sourcePicture, this.bigPicture, this.snapshotPicture});

  /// 从 JSON 字典反序列化实例（`PictureElem.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`PictureElem.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `PictureElem` 结果 / Resulting `PictureElem`.
  factory PictureElem.fromJson(Map<String, dynamic> json) => _$PictureElemFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$PictureElemToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [sourcePath] 来源路径 / Source path.
  /// - [sourcePicture] 来源图片 / Source picture.
  /// - [bigPicture] big图片 / Big picture.
  /// - [snapshotPicture] 缩略图图片 / Snapshot picture.
  /// - Returns: `PictureElem` 结果 / Resulting `PictureElem`.
  PictureElem copyWith({
    String? sourcePath,
    PictureInfo? sourcePicture,
    PictureInfo? bigPicture,
    PictureInfo? snapshotPicture,
  }) {
    return PictureElem(
      sourcePath: sourcePath ?? this.sourcePath,
      sourcePicture: sourcePicture ?? this.sourcePicture,
      bigPicture: bigPicture ?? this.bigPicture,
      snapshotPicture: snapshotPicture ?? this.snapshotPicture,
    );
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[sourcePath, sourcePicture, bigPicture, snapshotPicture];
}

/// 图片信息。
///
/// Image information
@JsonSerializable()
class PictureInfo extends Equatable {
  /// UUID。
  ///
  /// UUID.
  final String? uuid;

  /// 类型。
  ///
  /// Type.
  final String? type;

  /// 大小。
  ///
  /// Size.
  final int? size;

  /// 宽度。
  ///
  /// Width.
  final int? width;

  /// 高度。
  ///
  /// Height.
  final int? height;

  /// URL 地址。
  ///
  /// URL.
  final String? url;

  /// 创建 `PictureInfo` 实例。
  ///
  /// Creates a `PictureInfo` instance.
  ///
  /// - [uuid] UUID / UUID.
  /// - [type] 类型 / Type.
  /// - [size] 大小 / Size.
  /// - [width] 宽度 / Width.
  /// - [height] 高度 / Height.
  /// - [url] URL 地址 / URL.
  const PictureInfo({this.uuid, this.type, this.size, this.width, this.height, this.url});

  /// 从 JSON 字典反序列化实例（`PictureInfo.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`PictureInfo.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `PictureInfo` 结果 / Resulting `PictureInfo`.
  factory PictureInfo.fromJson(Map<String, dynamic> json) => _$PictureInfoFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$PictureInfoToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [uuid] UUID / UUID.
  /// - [type] 类型 / Type.
  /// - [size] 大小 / Size.
  /// - [width] 宽度 / Width.
  /// - [height] 高度 / Height.
  /// - [url] URL 地址 / URL.
  /// - Returns: `PictureInfo` 结果 / Resulting `PictureInfo`.
  PictureInfo copyWith({
    String? uuid,
    String? type,
    int? size,
    int? width,
    int? height,
    String? url,
  }) {
    return PictureInfo(
      uuid: uuid ?? this.uuid,
      type: type ?? this.type,
      size: size ?? this.size,
      width: width ?? this.width,
      height: height ?? this.height,
      url: url ?? this.url,
    );
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[uuid, type, size, width, height, url];
}

/// 语音元素。
///
/// Voice message content
@JsonSerializable()
class SoundElem extends Equatable {
  /// UUID。
  ///
  /// UUID.
  final String? uuid;

  /// 语音路径。
  ///
  /// Voice audio path.
  final String? soundPath;

  /// 来源URL 地址。
  ///
  /// Source URL.
  final String? sourceUrl;

  /// 数据大小。
  ///
  /// Data size.
  final int? dataSize;

  /// 时长。
  ///
  /// Duration.
  final int? duration;

  /// 语音类型。
  ///
  /// Voice audio type.
  final String? soundType;

  /// 创建 `SoundElem` 实例。
  ///
  /// Creates a `SoundElem` instance.
  ///
  /// - [uuid] UUID / UUID.
  /// - [soundPath] 语音路径 / Voice audio path.
  /// - [sourceUrl] 来源URL 地址 / Source URL.
  /// - [dataSize] 数据大小 / Data size.
  /// - [duration] 时长 / Duration.
  /// - [soundType] 语音类型 / Voice audio type.
  const SoundElem({
    this.uuid,
    this.soundPath,
    this.sourceUrl,
    this.dataSize,
    this.duration,
    this.soundType,
  });

  /// 从 JSON 字典反序列化实例（`SoundElem.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`SoundElem.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `SoundElem` 结果 / Resulting `SoundElem`.
  factory SoundElem.fromJson(Map<String, dynamic> json) => _$SoundElemFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$SoundElemToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [uuid] UUID / UUID.
  /// - [soundPath] 语音路径 / Voice audio path.
  /// - [sourceUrl] 来源URL 地址 / Source URL.
  /// - [dataSize] 数据大小 / Data size.
  /// - [duration] 时长 / Duration.
  /// - [soundType] 语音类型 / Voice audio type.
  /// - Returns: `SoundElem` 结果 / Resulting `SoundElem`.
  SoundElem copyWith({
    String? uuid,
    String? soundPath,
    String? sourceUrl,
    int? dataSize,
    int? duration,
    String? soundType,
  }) {
    return SoundElem(
      uuid: uuid ?? this.uuid,
      soundPath: soundPath ?? this.soundPath,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      dataSize: dataSize ?? this.dataSize,
      duration: duration ?? this.duration,
      soundType: soundType ?? this.soundType,
    );
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[uuid, soundPath, sourceUrl, dataSize, duration, soundType];
}

/// 视频元素。
///
/// Video message content
@JsonSerializable()
class VideoElem extends Equatable {
  /// 视频路径。
  ///
  /// Video path.
  final String? videoPath;

  /// 视频UUID。
  ///
  /// Video UUID.
  final String? videoUUID;

  /// 视频URL 地址。
  ///
  /// Video URL.
  final String? videoUrl;

  /// 视频类型。
  ///
  /// Video type.
  final String? videoType;

  /// 视频大小。
  ///
  /// Video size.
  final int? videoSize;

  /// 时长。
  ///
  /// Duration.
  final int? duration;

  /// 缩略图路径。
  ///
  /// Snapshot path.
  final String? snapshotPath;

  /// 缩略图UUID。
  ///
  /// Snapshot UUID.
  final String? snapshotUUID;

  /// 缩略图大小。
  ///
  /// Snapshot size.
  final int? snapshotSize;

  /// 缩略图URL 地址。
  ///
  /// Snapshot URL.
  final String? snapshotUrl;

  /// 缩略图宽度。
  ///
  /// Snapshot width.
  final int? snapshotWidth;

  /// 缩略图高度。
  ///
  /// Snapshot height.
  final int? snapshotHeight;

  /// 缩略图类型。
  ///
  /// Snapshot type.
  final String? snapshotType;

  /// 创建 `VideoElem` 实例。
  ///
  /// Creates a `VideoElem` instance.
  ///
  /// - [videoPath] 视频路径 / Video path.
  /// - [videoUUID] 视频UUID / Video UUID.
  /// - [videoUrl] 视频URL 地址 / Video URL.
  /// - [videoType] 视频类型 / Video type.
  /// - [videoSize] 视频大小 / Video size.
  /// - [duration] 时长 / Duration.
  /// - [snapshotPath] 缩略图路径 / Snapshot path.
  /// - [snapshotUUID] 缩略图UUID / Snapshot UUID.
  /// - [snapshotSize] 缩略图大小 / Snapshot size.
  /// - [snapshotUrl] 缩略图URL 地址 / Snapshot URL.
  /// - [snapshotWidth] 缩略图宽度 / Snapshot width.
  /// - [snapshotHeight] 缩略图高度 / Snapshot height.
  /// - [snapshotType] 缩略图类型 / Snapshot type.
  const VideoElem({
    this.videoPath,
    this.videoUUID,
    this.videoUrl,
    this.videoType,
    this.videoSize,
    this.duration,
    this.snapshotPath,
    this.snapshotUUID,
    this.snapshotSize,
    this.snapshotUrl,
    this.snapshotWidth,
    this.snapshotHeight,
    this.snapshotType,
  });

  /// 从 JSON 字典反序列化实例（`VideoElem.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`VideoElem.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `VideoElem` 结果 / Resulting `VideoElem`.
  factory VideoElem.fromJson(Map<String, dynamic> json) => _$VideoElemFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$VideoElemToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [videoPath] 视频路径 / Video path.
  /// - [videoUUID] 视频UUID / Video UUID.
  /// - [videoUrl] 视频URL 地址 / Video URL.
  /// - [videoType] 视频类型 / Video type.
  /// - [videoSize] 视频大小 / Video size.
  /// - [duration] 时长 / Duration.
  /// - [snapshotPath] 缩略图路径 / Snapshot path.
  /// - [snapshotUUID] 缩略图UUID / Snapshot UUID.
  /// - [snapshotSize] 缩略图大小 / Snapshot size.
  /// - [snapshotUrl] 缩略图URL 地址 / Snapshot URL.
  /// - [snapshotWidth] 缩略图宽度 / Snapshot width.
  /// - [snapshotHeight] 缩略图高度 / Snapshot height.
  /// - [snapshotType] 缩略图类型 / Snapshot type.
  /// - Returns: `VideoElem` 结果 / Resulting `VideoElem`.
  VideoElem copyWith({
    String? videoPath,
    String? videoUUID,
    String? videoUrl,
    String? videoType,
    int? videoSize,
    int? duration,
    String? snapshotPath,
    String? snapshotUUID,
    int? snapshotSize,
    String? snapshotUrl,
    int? snapshotWidth,
    int? snapshotHeight,
    String? snapshotType,
  }) {
    return VideoElem(
      videoPath: videoPath ?? this.videoPath,
      videoUUID: videoUUID ?? this.videoUUID,
      videoUrl: videoUrl ?? this.videoUrl,
      videoType: videoType ?? this.videoType,
      videoSize: videoSize ?? this.videoSize,
      duration: duration ?? this.duration,
      snapshotPath: snapshotPath ?? this.snapshotPath,
      snapshotUUID: snapshotUUID ?? this.snapshotUUID,
      snapshotSize: snapshotSize ?? this.snapshotSize,
      snapshotUrl: snapshotUrl ?? this.snapshotUrl,
      snapshotWidth: snapshotWidth ?? this.snapshotWidth,
      snapshotHeight: snapshotHeight ?? this.snapshotHeight,
      snapshotType: snapshotType ?? this.snapshotType,
    );
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[
    videoPath,
    videoUUID,
    videoUrl,
    videoType,
    videoSize,
    duration,
    snapshotPath,
    snapshotUUID,
    snapshotSize,
    snapshotUrl,
    snapshotWidth,
    snapshotHeight,
    snapshotType,
  ];
}

/// 文件元素。
///
/// File message content
@JsonSerializable()
class FileElem extends Equatable {
  /// 文件路径。
  ///
  /// File path.
  final String? filePath;

  /// UUID。
  ///
  /// UUID.
  final String? uuid;

  /// 来源URL 地址。
  ///
  /// Source URL.
  final String? sourceUrl;

  /// 文件名称。
  ///
  /// File name.
  final String? fileName;

  /// 文件大小。
  ///
  /// File size.
  final int? fileSize;

  /// 文件类型。
  ///
  /// File type.
  final String? fileType;

  /// 创建 `FileElem` 实例。
  ///
  /// Creates a `FileElem` instance.
  ///
  /// - [filePath] 文件路径 / File path.
  /// - [uuid] UUID / UUID.
  /// - [sourceUrl] 来源URL 地址 / Source URL.
  /// - [fileName] 文件名称 / File name.
  /// - [fileSize] 文件大小 / File size.
  /// - [fileType] 文件类型 / File type.
  const FileElem({
    this.filePath,
    this.uuid,
    this.sourceUrl,
    this.fileName,
    this.fileSize,
    this.fileType,
  });

  /// 从 JSON 字典反序列化实例（`FileElem.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`FileElem.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `FileElem` 结果 / Resulting `FileElem`.
  factory FileElem.fromJson(Map<String, dynamic> json) => _$FileElemFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$FileElemToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [filePath] 文件路径 / File path.
  /// - [uuid] UUID / UUID.
  /// - [sourceUrl] 来源URL 地址 / Source URL.
  /// - [fileName] 文件名称 / File name.
  /// - [fileSize] 文件大小 / File size.
  /// - [fileType] 文件类型 / File type.
  /// - Returns: `FileElem` 结果 / Resulting `FileElem`.
  FileElem copyWith({
    String? filePath,
    String? uuid,
    String? sourceUrl,
    String? fileName,
    int? fileSize,
    String? fileType,
  }) {
    return FileElem(
      filePath: filePath ?? this.filePath,
      uuid: uuid ?? this.uuid,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
      fileType: fileType ?? this.fileType,
    );
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[filePath, uuid, sourceUrl, fileName, fileSize, fileType];
}

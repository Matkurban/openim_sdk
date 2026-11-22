part of '../message.dart';

/// Image message content
@JsonSerializable()
class PictureElem extends Equatable {
  final String? sourcePath;
  final PictureInfo? sourcePicture;
  final PictureInfo? bigPicture;
  final PictureInfo? snapshotPicture;

  const PictureElem({this.sourcePath, this.sourcePicture, this.bigPicture, this.snapshotPicture});

  factory PictureElem.fromJson(Map<String, dynamic> json) => _$PictureElemFromJson(json);

  Map<String, dynamic> toJson() => _$PictureElemToJson(this);

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

  @override
  List<Object?> get props => <Object?>[sourcePath, sourcePicture, bigPicture, snapshotPicture];
}

/// Image information
@JsonSerializable()
class PictureInfo extends Equatable {
  final String? uuid;
  final String? type;
  final int? size;
  final int? width;
  final int? height;
  final String? url;

  const PictureInfo({this.uuid, this.type, this.size, this.width, this.height, this.url});

  factory PictureInfo.fromJson(Map<String, dynamic> json) => _$PictureInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PictureInfoToJson(this);

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

  @override
  List<Object?> get props => <Object?>[uuid, type, size, width, height, url];
}

/// Voice message content
@JsonSerializable()
class SoundElem extends Equatable {
  final String? uuid;
  final String? soundPath;
  final String? sourceUrl;
  final int? dataSize;
  final int? duration;
  final String? soundType;

  const SoundElem({
    this.uuid,
    this.soundPath,
    this.sourceUrl,
    this.dataSize,
    this.duration,
    this.soundType,
  });

  factory SoundElem.fromJson(Map<String, dynamic> json) => _$SoundElemFromJson(json);

  Map<String, dynamic> toJson() => _$SoundElemToJson(this);

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

  @override
  List<Object?> get props => <Object?>[uuid, soundPath, sourceUrl, dataSize, duration, soundType];
}

/// Video message content
@JsonSerializable()
class VideoElem extends Equatable {
  final String? videoPath;
  final String? videoUUID;
  final String? videoUrl;
  final String? videoType;
  final int? videoSize;
  final int? duration;
  final String? snapshotPath;
  final String? snapshotUUID;
  final int? snapshotSize;
  final String? snapshotUrl;
  final int? snapshotWidth;
  final int? snapshotHeight;
  final String? snapshotType;

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

  factory VideoElem.fromJson(Map<String, dynamic> json) => _$VideoElemFromJson(json);

  Map<String, dynamic> toJson() => _$VideoElemToJson(this);

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

/// File message content
@JsonSerializable()
class FileElem extends Equatable {
  final String? filePath;
  final String? uuid;
  final String? sourceUrl;
  final String? fileName;
  final int? fileSize;
  final String? fileType;

  const FileElem({
    this.filePath,
    this.uuid,
    this.sourceUrl,
    this.fileName,
    this.fileSize,
    this.fileType,
  });

  factory FileElem.fromJson(Map<String, dynamic> json) => _$FileElemFromJson(json);

  Map<String, dynamic> toJson() => _$FileElemToJson(this);

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

  @override
  List<Object?> get props => <Object?>[filePath, uuid, sourceUrl, fileName, fileSize, fileType];
}

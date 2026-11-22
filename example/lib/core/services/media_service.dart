import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:signal_wire/signal_wire.dart';
import 'package:xue_hua_file_operations/xue_hua_file_operations.dart';
import 'package:xue_hua_media_compression/xue_hua_media_compression.dart';
import 'package:xue_hua_media_info/xue_hua_media_info.dart' as media_info;
import 'package:xue_hua_navite_video_player/xue_hua_navite_video_player.dart';

/// 媒体选择、元信息读取与压缩编排服务。
///
/// Media picking, metadata probing, and compression pipeline service.
class MediaService extends WireService {
  static final Logger _logger = Logger('MediaService');

  /// 初始化视频缓存配置并恢复可能的拍摄丢失文件。
  Future<void> initialize() async {
    try {
      await XueHuaNaviteVideoPlayer.instance.configureCache(
        const VideoCacheConfig(),
      );
      await XueHuaFileOperations.instance.retrieveLostCapture();
    } on Object catch (error, stackTrace) {
      _logger.fine('MediaService initialize skipped', error, stackTrace);
    }
  }

  /// 选择单张图片。
  Future<PlatformFile?> pickSingleImage() async {
    try {
      return await XueHuaFileOperations.instance.pickFile(
        type: FileType.image,
        withData: kIsWeb,
      );
    } on FileOperationsException catch (error) {
      _logger.warning('pickSingleImage failed: ${error.code} ${error.message}');
      return null;
    }
  }

  /// 选择多张图片（最多 9 张）。
  Future<List<PlatformFile>> pickMultipleImages({int maxFiles = 9}) async {
    try {
      final List<PlatformFile>? picked = await XueHuaFileOperations.instance
          .pickFiles(
            type: FileType.image,
            maxFiles: maxFiles,
            withData: kIsWeb,
          );
      return picked ?? <PlatformFile>[];
    } on FileOperationsException catch (error) {
      _logger.warning(
        'pickMultipleImages failed: ${error.code} ${error.message}',
      );
      return <PlatformFile>[];
    }
  }

  /// 选择单个视频。
  Future<PlatformFile?> pickVideo() async {
    try {
      return await XueHuaFileOperations.instance.pickFile(
        type: FileType.video,
        withData: kIsWeb,
      );
    } on FileOperationsException catch (error) {
      _logger.warning('pickVideo failed: ${error.code} ${error.message}');
      return null;
    }
  }

  /// 选择任意文件。
  Future<PlatformFile?> pickAnyFile() async {
    try {
      return await XueHuaFileOperations.instance.pickFile(
        type: FileType.any,
        withData: kIsWeb,
      );
    } on FileOperationsException catch (error) {
      _logger.warning('pickAnyFile failed: ${error.code} ${error.message}');
      return null;
    }
  }

  /// 调用系统相机拍照。
  Future<PlatformFile?> capturePhoto() async {
    try {
      return await XueHuaFileOperations.instance.capturePhoto(
        maxWidth: 1920,
        imageQuality: 88,
      );
    } on FileOperationsException catch (error) {
      _logger.warning('capturePhoto failed: ${error.code} ${error.message}');
      return null;
    }
  }

  /// 调用系统相机录制视频。
  Future<PlatformFile?> captureVideo() async {
    try {
      return await XueHuaFileOperations.instance.captureVideo(
        maxDuration: const Duration(seconds: 60),
      );
    } on FileOperationsException catch (error) {
      _logger.warning('captureVideo failed: ${error.code} ${error.message}');
      return null;
    }
  }

  /// 读取图片元信息（宽高、格式等）。
  Future<media_info.ImageMetadata?> readImageInfo(String filePath) async {
    if (kIsWeb || filePath.isEmpty) {
      return null;
    }
    try {
      return await media_info.MediaInfo.readImage(
        media_info.MediaSource.file(filePath),
      );
    } on Object catch (error, stackTrace) {
      _logger.fine('readImageInfo failed', error, stackTrace);
      return null;
    }
  }

  /// 读取音视频元信息（时长、分辨率等）。
  Future<media_info.AvMetadata?> readAvInfo(String filePath) async {
    if (kIsWeb || filePath.isEmpty) {
      return null;
    }
    try {
      return await media_info.MediaInfo.readAv(
        media_info.MediaSource.file(filePath),
      );
    } on Object catch (error, stackTrace) {
      _logger.fine('readAvInfo failed', error, stackTrace);
      return null;
    }
  }

  /// 压缩本地图片并返回压缩后的输出路径（失败或不支持时回退原路径）。
  Future<String> compressImageIfSupported(
    String inputPath,
    String outputPath,
  ) async {
    if (kIsWeb || inputPath.isEmpty) {
      return inputPath;
    }
    try {
      final ImageCompressionCapabilities caps = await XueHuaMediaCompression
          .image
          .queryCapabilities();
      if (caps.outputFormats.isEmpty) {
        return inputPath;
      }
      final ImageFormat format = caps.outputFormats.contains(ImageFormat.jpeg)
          ? ImageFormat.jpeg
          : caps.outputFormats.first;
      final CompressionSession<ImageCompressResult> session =
          XueHuaMediaCompression.image.compress(
            source: MediaSource.path(inputPath),
            destination: MediaDestination.path(outputPath),
            options: ImageCompressOptions(format: format, quality: 82),
          );
      try {
        final ImageCompressResult result = await session.result;
        return result.outputPath ?? outputPath;
      } finally {
        await session.dispose();
      }
    } on Object catch (error, stackTrace) {
      _logger.fine('compressImage fallback to original', error, stackTrace);
      return inputPath;
    }
  }

  /// 压缩本地视频为 MP4（失败或不支持时回退原路径）。
  Future<String> compressVideoIfSupported(
    String inputPath,
    String outputPath,
  ) async {
    if (kIsWeb || inputPath.isEmpty) {
      return inputPath;
    }
    try {
      final VideoCompressionCapabilities caps = await XueHuaMediaCompression
          .video
          .queryCapabilities();
      if (caps.codecs.isEmpty) {
        return inputPath;
      }
      final VideoCodec codec = caps.codecs.contains(VideoCodec.h264)
          ? VideoCodec.h264
          : caps.codecs.first;
      final CompressionSession<VideoCompressResult> session =
          XueHuaMediaCompression.video.compress(
            inputPath: inputPath,
            outputPath: outputPath,
            options: VideoCompressOptions(
              codec: codec,
              bitrate: 2000 * 1000,
              keepAudio: true,
            ),
          );
      try {
        final VideoCompressResult result = await session.result;
        return result.outputPath;
      } finally {
        await session.dispose();
      }
    } on Object catch (error, stackTrace) {
      _logger.fine('compressVideo fallback to original', error, stackTrace);
      return inputPath;
    }
  }

  /// 保存图片或视频到系统相册。
  Future<bool> saveToGallery({
    String? sourcePath,
    Uint8List? bytes,
    String? fileName,
    GalleryMediaType? type,
  }) async {
    try {
      final GalleryPermissionStatus status = await XueHuaFileOperations.instance
          .galleryPermissionStatus();
      if (status == GalleryPermissionStatus.denied) {
        await XueHuaFileOperations.instance.requestGalleryPermission();
      }
      await XueHuaFileOperations.instance.saveToGallery(
        sourcePath: sourcePath,
        bytes: bytes,
        fileName: fileName ?? 'media_${DateTime.now().millisecondsSinceEpoch}',
        type: type,
      );
      return true;
    } on Object catch (error, stackTrace) {
      _logger.warning('saveToGallery failed', error, stackTrace);
      return false;
    }
  }

  /// 调用系统默认程序打开文件。
  Future<bool> openLocalFile({String? path, String? identifier}) async {
    try {
      await XueHuaFileOperations.instance.openFile(
        path: path,
        identifier: identifier,
      );
      return true;
    } on Object catch (error, stackTrace) {
      _logger.warning('openLocalFile failed', error, stackTrace);
      return false;
    }
  }

  /// 另存为本地文件。
  Future<String?> saveFileAs({
    required String fileName,
    String? sourcePath,
    Uint8List? bytes,
  }) async {
    try {
      final SaveFileResult? res = await XueHuaFileOperations.instance.saveFile(
        fileName: fileName,
        sourcePath: sourcePath,
        bytes: bytes,
      );
      return res?.path;
    } on Object catch (error, stackTrace) {
      _logger.warning('saveFileAs failed', error, stackTrace);
      return null;
    }
  }
}

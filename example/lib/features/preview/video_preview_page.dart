import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:xue_hua_navite_video_player/xue_hua_navite_video_player.dart';

/// 视频全屏沉浸式播放页（`Stack` 布局，使用 `VideoPlayer` 自带音量与播放控制）。
///
/// Full-screen immersive `Stack`-based video preview page using built-in player controls.
class VideoPreviewPage extends StatefulWidget {
  /// 视频 URL 或本地文件路径。
  final String videoUrl;

  /// 视频标题（可选）。
  final String? title;

  /// 创建视频播放页。
  const VideoPreviewPage({super.key, required this.videoUrl, this.title});

  @override
  State<VideoPreviewPage> createState() => _VideoPreviewPageState();
}

class _VideoPreviewPageState extends State<VideoPreviewPage> {
  late final VideoPlayerController _playerController;

  @override
  void initState() {
    super.initState();
    final VideoSource source = widget.videoUrl.startsWith('http')
        ? VideoSource.network(widget.videoUrl)
        : VideoSource.file(widget.videoUrl);
    _playerController = VideoPlayerController();
    unawaited(
      _playerController.initialize().then((_) async {
        if (mounted) {
          await _playerController.playSource(source);
        }
      }),
    );
  }

  @override
  void dispose() {
    unawaited(_playerController.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: VideoPlayer(controller: _playerController),
    );
  }
}

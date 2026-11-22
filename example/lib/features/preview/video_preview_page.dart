import 'dart:async';

import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:material_ui/material_ui.dart';
import 'package:xue_hua_navite_share/xue_hua_navite_share.dart';
import 'package:xue_hua_navite_video_player/xue_hua_navite_video_player.dart';
import 'package:xue_hua_navite_volume_controller/xue_hua_navite_volume_controller.dart';

/// 视频全屏播放页（集成 `xue_hua_navite_video_player` 与 `xue_hua_navite_volume_controller`）。
///
/// Full-screen video player page with native volume/mute controls and casting.
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
  double _volume = 0.8;
  bool _muted = false;

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
    unawaited(_loadVolume());
  }

  Future<void> _loadVolume() async {
    try {
      final VolumeState state = await XueHuaNaviteVolumeController.instance
          .getVolumeState();
      if (mounted) {
        setState(() {
          _volume = state.volume;
          _muted = state.isMuted;
        });
      }
    } on Object catch (_) {}
  }

  Future<void> _setVolume(double value) async {
    setState(() {
      _volume = value;
      _muted = value == 0;
    });
    try {
      await XueHuaNaviteVolumeController.instance.setVolume(value);
    } on Object catch (_) {}
  }

  Future<void> _toggleMute() async {
    try {
      await XueHuaNaviteVolumeController.instance.toggleMute();
      await _loadVolume();
    } on Object catch (_) {}
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
      appBar: AppBar(
        backgroundColor: Colors.black54,
        foregroundColor: Colors.white,
        title: Text(widget.title ?? '视频播放'),
        actions: <Widget>[
          IconButton(
            tooltip: '投屏',
            icon: const Icon(Icons.cast),
            onPressed: () async {
              await _playerController.showCastPicker();
            },
          ),
          IconButton(
            tooltip: '分享视频链接',
            icon: const Icon(Icons.share_outlined),
            onPressed: () async {
              await XueHuaNaviteShare.instance.shareUri(
                Uri.parse(widget.videoUrl),
                subject: widget.title ?? '视频分享',
              );
              await FlutterToastPro.info('已调用系统分享');
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(child: VideoPlayer(controller: _playerController)),
          ),
          SafeArea(
            top: false,
            child: Container(
              color: Colors.black87,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      _muted ? Icons.volume_off : Icons.volume_up,
                      color: Colors.white,
                    ),
                    onPressed: _toggleMute,
                  ),
                  Expanded(
                    child: Slider(
                      value: _volume.clamp(0.0, 1.0),
                      onChanged: _setVolume,
                    ),
                  ),
                  Text(
                    '${(_volume * 100).round()}%',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

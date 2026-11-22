import 'dart:async';

import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:material_ui/material_ui.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';
import 'package:xue_hua_navite_share/xue_hua_navite_share.dart';
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
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned.fill(child: VideoPlayer(controller: _playerController)),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[Colors.black54, Colors.transparent],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => AdaptiveRouter.of(context).pop(),
                    ),
                    Expanded(
                      child: Text(
                        widget.title ?? '视频播放',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: '投屏',
                      icon: const Icon(Icons.cast, color: Colors.white),
                      onPressed: () async {
                        await _playerController.showCastPicker();
                      },
                    ),
                    IconButton(
                      tooltip: '外部分享',
                      icon: const Icon(
                        Icons.share_outlined,
                        color: Colors.white,
                      ),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}

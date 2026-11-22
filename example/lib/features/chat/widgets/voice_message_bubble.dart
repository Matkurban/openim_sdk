import 'dart:async';

import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:xue_hua_audio/xue_hua_audio.dart';
import 'package:xue_hua_navite_volume_controller/xue_hua_navite_volume_controller.dart';

/// 语音消息气泡（基于 `xue_hua_audio` 播放与 `xue_hua_navite_volume_controller` 音量调节）。
///
/// Voice message bubble powered by `xue_hua_audio` and `xue_hua_navite_volume_controller`.
class VoiceMessageBubble extends StatefulWidget {
  /// 消息对象。
  final Message message;

  /// 是否为我方发送。
  final bool isSelf;

  /// 创建语音消息气泡。
  const VoiceMessageBubble({
    super.key,
    required this.message,
    required this.isSelf,
  });

  @override
  State<VoiceMessageBubble> createState() => _VoiceMessageBubbleState();
}

class _VoiceMessageBubbleState extends State<VoiceMessageBubble> {
  AudioPlayer? _player;
  StreamSubscription<void>? _completeSub;
  bool _playing = false;

  Future<void> _togglePlay() async {
    if (_playing) {
      await _player?.stop();
      if (mounted) {
        setState(() => _playing = false);
      }
      return;
    }
    final SoundElem? elem = widget.message.soundElem;
    final String? path = elem?.soundPath;
    final String? url = elem?.sourceUrl;
    if ((path == null || path.isEmpty) && (url == null || url.isEmpty)) {
      await FlutterToastPro.warning('语音文件不可用');
      return;
    }
    try {
      final double currentVol = await XueHuaNaviteVolumeController.instance
          .getVolume();
      if (currentVol < 0.05) {
        await XueHuaNaviteVolumeController.instance.setVolume(0.5);
      }
      final AudioPlayer player = _player ??= AudioPlayer();
      _completeSub?.cancel();
      _completeSub = player.onPlayerComplete.listen((void _) {
        if (mounted) {
          setState(() => _playing = false);
        }
      });
      final AudioSource source = (path != null && path.isNotEmpty)
          ? AudioSource.file(path)
          : AudioSource.url(url!);
      await player.setSource(source);
      await player.play();
      if (mounted) {
        setState(() => _playing = true);
      }
    } on Object catch (error) {
      await FlutterToastPro.error('播放语音失败：$error');
    }
  }

  @override
  void dispose() {
    _completeSub?.cancel();
    if (_player != null) {
      unawaited(_player!.dispose());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int duration = widget.message.soundElem?.duration ?? 1;
    final double bubbleWidth = (80 + duration * 3.0).clamp(80, 210);
    return InkWell(
      onTap: _togglePlay,
      child: SizedBox(
        width: bubbleWidth,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: widget.isSelf
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: <Widget>[
            if (!widget.isSelf) ...<Widget>[
              Icon(
                _playing ? Icons.graphic_eq : Icons.volume_up_outlined,
                size: 20,
              ),
              const SizedBox(width: 8),
            ],
            Text('$duration"'),
            if (widget.isSelf) ...<Widget>[
              const SizedBox(width: 8),
              Icon(
                _playing ? Icons.graphic_eq : Icons.volume_up_outlined,
                size: 20,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

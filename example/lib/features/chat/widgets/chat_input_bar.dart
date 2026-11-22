import 'dart:async';

import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:signal_wire/signal_wire.dart';
import 'package:xue_hua_audio/xue_hua_audio.dart';

import 'chat_emoji_panel.dart';
import 'chat_more_panel.dart';

/// 仿微信聊天底部输入栏（支持语音按住说话、文本、引用条、表情/SVG 动效与 `+` 扩展面板）。
///
/// WeChat-style bottom chat composer bar with voice recorder, emoji, and attachment panels.
class ChatInputBar extends StatefulWidget {
  /// 文本输入控制器。
  final TextEditingController textController;

  /// 当前引用的消息（非空时展示引用预览条）。
  final Message? quotingMessage;

  /// 取消引用回调。
  final VoidCallback onCancelQuote;

  /// 文本变更回调（用于发送正在输入状态或群聊 `@` 触发）。
  final ValueChanged<String> onTextChanged;

  /// 发送文本回调。
  final VoidCallback onSendText;

  /// 发送语音回调（本地路径 + 时长秒）。
  final void Function(String path, int durationSeconds) onSendVoice;

  /// 发送 SVG 动效贴纸回调。
  final ValueChanged<String> onSendSvgSticker;

  /// 扩展面板回调集合。
  final VoidCallback onPickImage;
  final VoidCallback onCapturePhoto;
  final VoidCallback onPickVideo;
  final VoidCallback onPickFile;
  final VoidCallback onPickLocation;
  final VoidCallback onPickCard;
  final VoidCallback onSendRedPacket;
  final VoidCallback onStartCall;

  /// 创建底部输入栏。
  const ChatInputBar({
    super.key,
    required this.textController,
    required this.quotingMessage,
    required this.onCancelQuote,
    required this.onTextChanged,
    required this.onSendText,
    required this.onSendVoice,
    required this.onSendSvgSticker,
    required this.onPickImage,
    required this.onCapturePhoto,
    required this.onPickVideo,
    required this.onPickFile,
    required this.onPickLocation,
    required this.onPickCard,
    required this.onSendRedPacket,
    required this.onStartCall,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  late final Signal<bool> _voiceMode = signal<bool>(false);
  late final Signal<bool> _recording = signal<bool>(false);
  late final Signal<bool> _showEmoji = signal<bool>(false);
  late final Signal<bool> _showMore = signal<bool>(false);
  DateTime? _recordStartAt;
  AudioRecorder? _recorder;

  @override
  void dispose() {
    if (_recorder != null) {
      unawaited(_recorder!.dispose());
    }
    super.dispose();
  }

  Future<void> _startRecord() async {
    try {
      final AudioRecorder recorder = _recorder ??= AudioRecorder();
      final bool permitted = await recorder.hasPermission();
      if (!permitted) {
        await FlutterToastPro.warning('请先授予麦克风权限');
        return;
      }
      final String path =
          '/tmp/openim_voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
      await recorder.start(const RecordConfig(), path: path);
      _recordStartAt = DateTime.now();
      if (mounted) {
        _recording.value = true;
      }
    } on Object catch (error) {
      await FlutterToastPro.error('录音启动失败：$error');
    }
  }

  Future<void> _stopRecord() async {
    if (!_recording.value || _recorder == null) {
      return;
    }
    try {
      final String? path = await _recorder!.stop();
      final int secs = _recordStartAt != null
          ? DateTime.now().difference(_recordStartAt!).inSeconds.clamp(1, 60)
          : 1;
      if (mounted) {
        _recording.value = false;
      }
      if (path != null && path.isNotEmpty) {
        widget.onSendVoice(path, secs);
      }
    } on Object catch (error) {
      if (mounted) {
        _recording.value = false;
      }
      await FlutterToastPro.error('结束录音失败：$error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return SafeArea(
      top: false,
      child: SignalBuilder(
        builder: (BuildContext _) {
          final bool voiceMode = _voiceMode.value;
          final bool recording = _recording.value;
          final bool showEmoji = _showEmoji.value;
          final bool showMore = _showMore.value;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (widget.quotingMessage != null)
                Container(
                  color: theme.colorScheme.surfaceContainerHighest,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          '回复 ${widget.quotingMessage!.senderNickname ?? ''}: '
                          '${widget.quotingMessage!.textElem?.content ?? '[消息]'}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 16),
                        onPressed: widget.onCancelQuote,
                      ),
                    ],
                  ),
                ),
              Container(
                color: theme.appBarTheme.backgroundColor,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      tooltip: voiceMode ? '切换键盘' : '语音输入',
                      icon: Icon(
                        voiceMode
                            ? Icons.keyboard_alt_outlined
                            : Icons.mic_none,
                      ),
                      onPressed: () {
                        batch(() {
                          _voiceMode.value = !voiceMode;
                          _showEmoji.value = false;
                          _showMore.value = false;
                        });
                      },
                    ),
                    Expanded(
                      child: voiceMode
                          ? GestureDetector(
                              onLongPressStart: (LongPressStartDetails _) =>
                                  _startRecord(),
                              onLongPressEnd: (LongPressEndDetails _) =>
                                  _stopRecord(),
                              child: Container(
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: recording
                                      ? theme.colorScheme.primaryContainer
                                      : theme.colorScheme.surface,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  recording ? '正在录音，松开发送...' : '按住 说话',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                          : TextField(
                              controller: widget.textController,
                              minLines: 1,
                              maxLines: 4,
                              onChanged: widget.onTextChanged,
                              onTap: () {
                                if (showEmoji || showMore) {
                                  batch(() {
                                    _showEmoji.value = false;
                                    _showMore.value = false;
                                  });
                                }
                              },
                              onSubmitted: (String _) => widget.onSendText(),
                              decoration: const InputDecoration(
                                hintText: '输入消息...',
                                isDense: true,
                              ),
                            ),
                    ),
                    IconButton(
                      tooltip: '表情与动效',
                      icon: const Icon(Icons.emoji_emotions_outlined),
                      onPressed: () {
                        batch(() {
                          _showEmoji.value = !showEmoji;
                          _showMore.value = false;
                          _voiceMode.value = false;
                        });
                      },
                    ),
                    IconButton(
                      tooltip: '更多功能',
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () {
                        batch(() {
                          _showMore.value = !showMore;
                          _showEmoji.value = false;
                          _voiceMode.value = false;
                        });
                      },
                    ),
                    FilledButton(
                      onPressed: widget.onSendText,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(54, 36),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                      ),
                      child: const Text('发送'),
                    ),
                  ],
                ),
              ),
              if (showEmoji)
                ChatEmojiPanel(
                  onSelectEmoji: (String emoji) {
                    widget.textController.text =
                        '${widget.textController.text}$emoji';
                  },
                  onSelectSvgSticker: widget.onSendSvgSticker,
                ),
              if (showMore)
                ChatMorePanel(
                  onPickImage: widget.onPickImage,
                  onCapturePhoto: widget.onCapturePhoto,
                  onPickVideo: widget.onPickVideo,
                  onPickFile: widget.onPickFile,
                  onPickLocation: widget.onPickLocation,
                  onPickCard: widget.onPickCard,
                  onSendRedPacket: widget.onSendRedPacket,
                  onStartCall: widget.onStartCall,
                ),
            ],
          );
        },
      ),
    );
  }
}

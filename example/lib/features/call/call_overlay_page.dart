import 'dart:async';

import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:signal_wire/signal_wire.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';
import 'package:xue_hua_navite_volume_controller/xue_hua_navite_volume_controller.dart';

import '../../app/theme/app_colors.dart';
import '../../core/events/im_event_bus.dart';
import '../../core/events/im_social_event.dart';
import '../../shared/widgets/cached_avatar.dart';

/// 音视频通话全屏页（对接 `CallManager` 与 `XueHuaNaviteVolumeController`）。
///
/// Full-screen audio/video call overlay page.
class CallOverlayPage extends StatefulWidget {
  /// 当前通话会话。
  final CallSession? session;

  /// 创建通话全屏页。
  const CallOverlayPage({super.key, this.session});

  @override
  State<CallOverlayPage> createState() => _CallOverlayPageState();
}

class _CallOverlayPageState extends State<CallOverlayPage> {
  CallSession? _session;
  bool _muted = false;
  int _elapsedSeconds = 0;
  Timer? _timer;
  StreamSubscription<ImSocialEvent>? _callSub;

  @override
  void initState() {
    super.initState();
    _session = widget.session ?? OpenIM.iMManager.callManager.currentSession;
    _callSub = Wire.find<ImEventBus>().socialStream.listen((
      ImSocialEvent event,
    ) {
      if (!event.kind.startsWith('call')) {
        return;
      }
      if (event.kind == 'callConnected' || event.kind == 'callAccepted') {
        _startTimer();
      } else if (event.kind == 'callEnded' ||
          event.kind == 'callCancelled' ||
          event.kind == 'callRejected' ||
          event.kind == 'callTimeout') {
        if (mounted) {
          AdaptiveRouter.of(context).pop();
        }
      }
      if (event.callSession != null && mounted) {
        setState(() => _session = event.callSession);
      }
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer _) {
      if (mounted) {
        setState(() => _elapsedSeconds += 1);
      }
    });
  }

  Future<void> _toggleMute() async {
    await XueHuaNaviteVolumeController.instance.toggleMute();
    if (mounted) {
      setState(() => _muted = !_muted);
    }
  }

  Future<void> _accept() async {
    final String roomId = _session?.roomID ?? '';
    if (roomId.isEmpty) {
      return;
    }
    try {
      await OpenIM.iMManager.callManager.accept(roomID: roomId);
      _startTimer();
    } on Object catch (error) {
      await FlutterToastPro.error('接听失败：$error');
    }
  }

  Future<void> _hangupOrCancel() async {
    try {
      final CallState state = OpenIM.iMManager.callManager.callState;
      if (state == CallState.calling) {
        await OpenIM.iMManager.callManager.cancel();
      } else if (state == CallState.incoming) {
        await OpenIM.iMManager.callManager.reject(
          roomID: _session?.roomID ?? '',
        );
      } else {
        await OpenIM.iMManager.callManager.hangup();
      }
    } on Object catch (_) {}
    if (mounted) {
      AdaptiveRouter.of(context).pop();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _callSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CallState state = OpenIM.iMManager.callManager.callState;
    final bool isIncoming = state == CallState.incoming;
    final String peerLabel = _session?.inviterUserID ?? '对方';

    return Scaffold(
      backgroundColor: const Color(0xFF1A1C1E),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CachedAvatar(fallbackName: peerLabel, size: 88, borderRadius: 44),
              const SizedBox(height: 18),
              Text(
                peerLabel,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _elapsedSeconds > 0
                    ? '通话中 ${_elapsedSeconds}s'
                    : (isIncoming ? '邀请你通话...' : '正在等待对方接听...'),
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 64),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FloatingActionButton(
                    heroTag: 'call_mute',
                    backgroundColor: Colors.white24,
                    onPressed: _toggleMute,
                    child: Icon(
                      _muted ? Icons.mic_off : Icons.mic,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 28),
                  if (isIncoming) ...<Widget>[
                    FloatingActionButton(
                      heroTag: 'call_accept',
                      backgroundColor: AppColors.primary,
                      onPressed: _accept,
                      child: const Icon(Icons.call, color: Colors.white),
                    ),
                    const SizedBox(width: 28),
                  ],
                  FloatingActionButton(
                    heroTag: 'call_end',
                    backgroundColor: AppColors.danger,
                    onPressed: _hangupOrCancel,
                    child: const Icon(Icons.call_end, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

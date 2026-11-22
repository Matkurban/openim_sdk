import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:signal_wire/signal_wire.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';
import 'package:xue_hua_file_operations/xue_hua_file_operations.dart';
import 'package:xue_hua_media_info/xue_hua_media_info.dart' as media_info;

import '../../core/services/media_service.dart';

/// 发布朋友圈动态页（图文九宫格 / 短视频经媒体压缩与信息解析后上传，支持可见范围设置）。
///
/// Moment composer page supporting compressed images/video and visibility settings.
class MomentPublishPage extends StatefulWidget {
  /// 创建发布动态页。
  const MomentPublishPage({super.key});

  @override
  State<MomentPublishPage> createState() => _MomentPublishPageState();
}

class _MomentPublishPageState extends State<MomentPublishPage> {
  final TextEditingController _contentController = TextEditingController();
  final List<PlatformFile> _selectedMedia = <PlatformFile>[];
  bool _isVideo = false;
  VisibleType _visibleType = VisibleType.friend;
  bool _publishing = false;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final List<PlatformFile> picked = await Wire.find<MediaService>()
        .pickMultipleImages(maxFiles: 9);
    if (picked.isNotEmpty && mounted) {
      setState(() {
        _isVideo = false;
        _selectedMedia
          ..clear()
          ..addAll(picked);
      });
    }
  }

  Future<void> _pickVideo() async {
    final PlatformFile? picked = await Wire.find<MediaService>().pickVideo();
    if (picked != null && mounted) {
      setState(() {
        _isVideo = true;
        _selectedMedia
          ..clear()
          ..add(picked);
      });
    }
  }

  Future<void> _publish() async {
    final String text = _contentController.text.trim();
    if (text.isEmpty && _selectedMedia.isEmpty) {
      await FlutterToastPro.warning('请输入文字或选择图片/视频');
      return;
    }
    setState(() => _publishing = true);
    FlutterToastPro.loading(message: '正在压缩并上传动态...');
    try {
      final MediaService media = Wire.find<MediaService>();
      final List<MomentMedia> uploaded = <MomentMedia>[];
      for (final PlatformFile file in _selectedMedia) {
        final String rawPath = file.path ?? '';
        if (rawPath.isEmpty) {
          continue;
        }
        String finalPath = rawPath;
        int? duration;
        if (_isVideo) {
          finalPath = await media.compressVideoIfSupported(
            rawPath,
            '/tmp/moment_vid_${DateTime.now().millisecondsSinceEpoch}.mp4',
          );
          final media_info.AvMetadata? av = await media.readAvInfo(finalPath);
          duration = av?.duration?.inSeconds ?? 1;
        } else {
          finalPath = await media.compressImageIfSupported(
            rawPath,
            '/tmp/moment_img_${DateTime.now().millisecondsSinceEpoch}.jpg',
          );
          await media.readImageInfo(finalPath);
        }
        final String url = await OpenIM.iMManager.uploadFile(
          id: 'moment_${DateTime.now().millisecondsSinceEpoch}',
          filePath: finalPath,
          fileName: file.name,
        );
        uploaded.add(
          MomentMedia(
            type: _isVideo ? 'video' : 'image',
            url: url,
            duration: duration,
          ),
        );
      }

      await OpenIM.iMManager.momentsManager.createMoment(
        request: MomentCreateReq(
          content: text,
          media: uploaded,
          visibleType: _visibleType,
        ),
      );
      FlutterToastPro.hideLoading();
      await FlutterToastPro.success('动态发布成功');
      if (mounted) {
        AdaptiveRouter.of(context).pop();
      }
    } on Object catch (error) {
      FlutterToastPro.hideLoading();
      await FlutterToastPro.error('发布失败：$error');
    } finally {
      if (mounted) {
        setState(() => _publishing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('发表朋友圈'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilledButton(
              onPressed: _publishing ? null : _publish,
              child: const Text('发表'),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          TextField(
            controller: _contentController,
            maxLines: 5,
            decoration: const InputDecoration(hintText: '这一刻的想法...'),
          ),
          const SizedBox(height: 14),
          Row(
            children: <Widget>[
              OutlinedButton.icon(
                onPressed: _pickImages,
                icon: const Icon(Icons.photo_library_outlined),
                label: const Text('选择图片(最多9张)'),
              ),
              const SizedBox(width: 10),
              OutlinedButton.icon(
                onPressed: _pickVideo,
                icon: const Icon(Icons.videocam_outlined),
                label: const Text('选择视频'),
              ),
            ],
          ),
          if (_selectedMedia.isNotEmpty) ...<Widget>[
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                for (final PlatformFile f in _selectedMedia)
                  Chip(
                    avatar: Icon(
                      _isVideo ? Icons.videocam : Icons.image,
                      size: 16,
                    ),
                    label: Text(f.name),
                    onDeleted: () {
                      setState(() => _selectedMedia.remove(f));
                    },
                  ),
              ],
            ),
          ],
          const Divider(height: 28),
          ListTile(
            leading: const Icon(Icons.visibility_outlined),
            title: const Text('谁可以看'),
            trailing: SegmentedButton<VisibleType>(
              segments: const <ButtonSegment<VisibleType>>[
                ButtonSegment<VisibleType>(
                  value: VisibleType.friend,
                  label: Text('公开'),
                ),
                ButtonSegment<VisibleType>(
                  value: VisibleType.self,
                  label: Text('仅自己'),
                ),
              ],
              selected: <VisibleType>{_visibleType},
              onSelectionChanged: (Set<VisibleType> next) {
                setState(() => _visibleType = next.first);
              },
            ),
          ),
        ],
      ),
    );
  }
}

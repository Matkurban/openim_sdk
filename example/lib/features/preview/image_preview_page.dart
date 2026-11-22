import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:material_ui/material_ui.dart';
import 'package:signal_wire/signal_wire.dart';
import 'package:xue_hua_file_operations/xue_hua_file_operations.dart';
import 'package:xue_hua_navite_cache_manager/xue_hua_navite_cache_manager.dart';
import 'package:xue_hua_navite_share/xue_hua_navite_share.dart';

import '../../core/services/media_service.dart';

/// 图片全屏预览页（支持手势缩放、多图滑动、保存至相册与外部分享）。
///
/// Full-screen zoomable image preview page with gallery save and OS share.
class ImagePreviewPage extends StatefulWidget {
  /// 图片 URL 列表。
  final List<String> imageUrls;

  /// 初始展示索引。
  final int initialIndex;

  /// 创建图片全屏预览页。
  const ImagePreviewPage({
    super.key,
    required this.imageUrls,
    this.initialIndex = 0,
  });

  @override
  State<ImagePreviewPage> createState() => _ImagePreviewPageState();
}

class _ImagePreviewPageState extends State<ImagePreviewPage> {
  late final PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(
      0,
      widget.imageUrls.isEmpty ? 0 : widget.imageUrls.length - 1,
    );
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String get _currentUrl =>
      widget.imageUrls.isEmpty ? '' : widget.imageUrls[_currentIndex];

  Future<void> _saveCurrent() async {
    if (_currentUrl.isEmpty) {
      return;
    }
    FlutterToastPro.loading(message: '正在保存到相册...');
    try {
      final CacheEntry entry = await XueHuaNaviteCacheManager.instance
          .getSingleFile(_currentUrl);
      final bool saved = await Wire.find<MediaService>().saveToGallery(
        sourcePath: entry.filePath,
        type: GalleryMediaType.image,
      );
      FlutterToastPro.hideLoading();
      if (saved) {
        await FlutterToastPro.success('已保存到系统相册');
      } else {
        await FlutterToastPro.error('保存失败');
      }
    } on Object catch (error) {
      FlutterToastPro.hideLoading();
      await FlutterToastPro.error('保存失败：$error');
    }
  }

  Future<void> _shareCurrent() async {
    if (_currentUrl.isEmpty) {
      return;
    }
    await XueHuaNaviteShare.instance.shareUri(
      Uri.parse(_currentUrl),
      subject: '分享图片',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black54,
        foregroundColor: Colors.white,
        title: Text(
          widget.imageUrls.length > 1
              ? '${_currentIndex + 1} / ${widget.imageUrls.length}'
              : '图片预览',
        ),
        actions: <Widget>[
          IconButton(
            tooltip: '保存到相册',
            icon: const Icon(Icons.download_outlined),
            onPressed: _saveCurrent,
          ),
          IconButton(
            tooltip: '外部分享',
            icon: const Icon(Icons.share_outlined),
            onPressed: _shareCurrent,
          ),
        ],
      ),
      body: widget.imageUrls.isEmpty
          ? const Center(
              child: Text('无图片可预览', style: TextStyle(color: Colors.white70)),
            )
          : PageView.builder(
              controller: _pageController,
              itemCount: widget.imageUrls.length,
              onPageChanged: (int idx) => setState(() => _currentIndex = idx),
              itemBuilder: (BuildContext _, int index) {
                return Center(
                  child: InteractiveViewer(
                    minScale: 0.8,
                    maxScale: 4.0,
                    child: CachedNetworkImage(
                      imageUrl: widget.imageUrls[index],
                      tag: 'chat_images',
                      fit: BoxFit.contain,
                      errorBuilder:
                          (BuildContext _, String _, Object _, StackTrace? _) {
                            return const Icon(
                              Icons.broken_image_outlined,
                              color: Colors.white54,
                              size: 64,
                            );
                          },
                    ),
                  ),
                );
              },
            ),
    );
  }
}

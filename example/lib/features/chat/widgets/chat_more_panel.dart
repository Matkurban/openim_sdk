import 'package:material_ui/material_ui.dart';

/// 聊天底部 `+` 号扩展功能面板（相册/拍摄/视频/文件/位置/名片/红包/音视频通话）。
///
/// WeChat-style chat `+` attachment grid panel.
class ChatMorePanel extends StatelessWidget {
  /// 选择图片。
  final VoidCallback onPickImage;

  /// 拍摄照片。
  final VoidCallback onCapturePhoto;

  /// 选择或拍摄视频。
  final VoidCallback onPickVideo;

  /// 选择文件。
  final VoidCallback onPickFile;

  /// 发送位置。
  final VoidCallback onPickLocation;

  /// 发送名片。
  final VoidCallback onPickCard;

  /// 发送积分红包。
  final VoidCallback onSendRedPacket;

  /// 发起音视频通话。
  final VoidCallback onStartCall;

  /// 创建扩展面板。
  const ChatMorePanel({
    super.key,
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
  Widget build(BuildContext context) {
    final List<(IconData, String, VoidCallback)> items =
        <(IconData, String, VoidCallback)>[
          (Icons.photo_outlined, '相册', onPickImage),
          (Icons.camera_alt_outlined, '拍摄', onCapturePhoto),
          (Icons.videocam_outlined, '视频', onPickVideo),
          (Icons.insert_drive_file_outlined, '文件', onPickFile),
          (Icons.location_on_outlined, '位置', onPickLocation),
          (Icons.contact_mail_outlined, '名片', onPickCard),
          (Icons.card_giftcard, '积分红包', onSendRedPacket),
          (Icons.call_outlined, '音视频通话', onStartCall),
        ];

    return Container(
      height: 210,
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.all(14),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.0,
        ),
        itemCount: items.length,
        itemBuilder: (BuildContext _, int index) {
          final (IconData icon, String label, VoidCallback tap) = items[index];
          return InkWell(
            onTap: tap,
            borderRadius: BorderRadius.circular(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 24),
                ),
                const SizedBox(height: 6),
                Text(label, style: const TextStyle(fontSize: 12)),
              ],
            ),
          );
        },
      ),
    );
  }
}

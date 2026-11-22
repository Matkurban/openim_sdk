import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:signal_wire/signal_wire.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';
import 'package:xue_hua_file_operations/xue_hua_file_operations.dart';

import '../../core/services/auth_session_service.dart';
import '../../core/services/media_service.dart';
import '../../shared/widgets/cached_avatar.dart';

/// 个人资料编辑页（修改头像、昵称、性别）。
///
/// Personal profile editor page (avatar upload, nickname, gender).
class EditProfilePage extends StatefulWidget {
  /// 创建编辑资料页。
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController _nicknameController;
  late final Signal<String?> _faceURL;
  late final Signal<int> _gender = signal<int>(1);
  late final Signal<bool> _saving = signal<bool>(false);

  @override
  void initState() {
    super.initState();
    final UserInfo? self = Wire.find<AuthSessionService>().currentUser.value;
    _nicknameController = TextEditingController(text: self?.nickname ?? '');
    _faceURL = signal<String?>(self?.faceURL);
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final MediaService media = Wire.find<MediaService>();
    final PlatformFile? file = await media.pickSingleImage();
    if (file == null || (file.path ?? '').isEmpty) {
      return;
    }
    FlutterToastPro.loading(message: '正在上传头像...');
    try {
      final String compressed = await media.compressImageIfSupported(
        file.path!,
        '/tmp/avatar_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      final String url = await OpenIM.iMManager.uploadFile(
        id: 'avatar_${DateTime.now().millisecondsSinceEpoch}',
        filePath: compressed,
        fileName: file.name,
      );
      FlutterToastPro.hideLoading();
      if (mounted) {
        _faceURL.value = url;
      }
      await FlutterToastPro.success('头像已上传');
    } on Object catch (error) {
      FlutterToastPro.hideLoading();
      await FlutterToastPro.error('上传失败：$error');
    }
  }

  Future<void> _save() async {
    _saving.value = true;
    try {
      await OpenIM.iMManager.userManager.setSelfInfo(
        nickname: _nicknameController.text.trim(),
        faceURL: _faceURL.value,
      );
      await OpenIM.iMManager.userManager.updateChatUserInfo(
        nickname: _nicknameController.text.trim(),
        faceURL: _faceURL.value,
        gender: _gender.value,
      );
      await Wire.find<AuthSessionService>().refreshSelfInfo();
      await FlutterToastPro.success('个人资料已保存');
      if (mounted) {
        AdaptiveRouter.of(context).pop();
      }
    } on Object catch (error) {
      await FlutterToastPro.error('保存失败：$error');
    } finally {
      if (mounted) {
        _saving.value = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('个人资料'),
        actions: <Widget>[
          SignalBuilder(
            builder: (BuildContext _) {
              return TextButton(
                onPressed: _saving.value ? null : _save,
                child: const Text('保存'),
              );
            },
          ),
        ],
      ),
      body: SignalBuilder(
        builder: (BuildContext _) {
          final String? faceURL = _faceURL.value;
          final int gender = _gender.value;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              Center(
                child: GestureDetector(
                  onTap: _pickAvatar,
                  child: Column(
                    children: <Widget>[
                      CachedAvatar(
                        imageUrl: faceURL,
                        fallbackName: _nicknameController.text,
                        size: 80,
                      ),
                      const SizedBox(height: 8),
                      const Text('点击更换头像'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _nicknameController,
                decoration: const InputDecoration(labelText: '昵称'),
              ),
              const SizedBox(height: 16),
              SegmentedButton<int>(
                segments: const <ButtonSegment<int>>[
                  ButtonSegment<int>(value: 1, label: Text('男')),
                  ButtonSegment<int>(value: 2, label: Text('女')),
                  ButtonSegment<int>(value: 0, label: Text('保密')),
                ],
                selected: <int>{gender},
                onSelectionChanged: (Set<int> next) {
                  _gender.value = next.first;
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

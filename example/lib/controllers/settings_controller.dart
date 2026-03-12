import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openim_sdk/openim_sdk.dart';

class SettingsController extends GetxController {
  final userInfo = Rxn<UserInfo>();
  final isEditing = false.obs;
  final nicknameCtrl = TextEditingController();
  final faceURLCtrl = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _loadUserInfo();
    _setupListener();
  }

  @override
  void onClose() {
    nicknameCtrl.dispose();
    faceURLCtrl.dispose();
    super.onClose();
  }

  void _setupListener() {
    OpenIM.iMManager.userManager.setUserListener(
      OnUserListener(
        onSelfInfoUpdated: (info) {
          userInfo.value = info;
        },
      ),
    );
  }

  Future<void> _loadUserInfo() async {
    try {
      final info = OpenIM.iMManager.getLoginUserInfo();
      userInfo.value = info;
      nicknameCtrl.text = info.nickname ?? '';
      faceURLCtrl.text = info.faceURL ?? '';
    } catch (_) {}
  }

  Future<void> updateProfile() async {
    try {
      await OpenIM.iMManager.userManager.setSelfInfo(
        nickname: nicknameCtrl.text.trim(),
        faceURL: faceURLCtrl.text.trim(),
      );
      await _loadUserInfo();
      isEditing.value = false;
      Get.snackbar('成功', '个人信息已更新', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('失败', '$e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> subscribeUserStatus(String userID) async {
    try {
      final statuses = await OpenIM.iMManager.userManager.subscribeUsersStatus([userID]);
      if (statuses.isNotEmpty) {
        final s = statuses.first;
        Get.snackbar(
          '用户状态',
          '${s.userID}: ${s.status == 1 ? "在线" : "离线"}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar('失败', '$e', snackPosition: SnackPosition.BOTTOM);
    }
  }
}

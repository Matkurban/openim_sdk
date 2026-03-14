import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'im_listener_service.dart';

class SettingsController extends GetxController {
  final userInfo = Rxn<UserInfo>();
  final isEditing = false.obs;
  final nicknameCtrl = TextEditingController();
  final faceURLCtrl = TextEditingController();

  // SDK 信息
  final sdkVersion = ''.obs;
  final isBackground = false.obs;
  final clientConfig = Rxn<Map<String, String>>();

  final _subs = <StreamSubscription>[];

  @override
  void onInit() {
    super.onInit();
    _loadUserInfo();
    _loadSdkInfo();
    _setupListener();
  }

  @override
  void onClose() {
    for (final s in _subs) {
      s.cancel();
    }
    nicknameCtrl.dispose();
    faceURLCtrl.dispose();
    super.onClose();
  }

  void _setupListener() {
    final svc = Get.find<IMListenerService>();
    _subs.add(
      svc.selfInfoUpdated.stream.listen((info) {
        userInfo.value = info;
      }),
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

  void _loadSdkInfo() {
    sdkVersion.value = OpenIM.iMManager.getSdkVersion();
  }

  /// 更新个人资料
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

  /// 从服务器获取个人信息
  Future<void> getSelfUserInfo() async {
    try {
      final info = await OpenIM.iMManager.userManager.getSelfUserInfo();
      if (info != null) {
        userInfo.value = info;
        Get.snackbar('成功', '已从服务器刷新', snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('失败', '$e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// 订阅用户在线状态
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

  /// 取消订阅用户状态
  Future<void> unsubscribeUserStatus(String userID) async {
    try {
      await OpenIM.iMManager.userManager.unsubscribeUsersStatus([userID]);
      Get.snackbar('成功', '已取消订阅', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('失败', '$e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// 获取已订阅用户状态
  Future<void> getSubscribedStatuses() async {
    try {
      final list = await OpenIM.iMManager.userManager.getSubscribeUsersStatus();
      if (list.isEmpty) {
        Get.snackbar('结果', '暂无订阅的用户', snackPosition: SnackPosition.BOTTOM);
        return;
      }
      final text = list.map((s) => '${s.userID}: ${s.status == 1 ? "在线" : "离线"}').join('\n');
      Get.snackbar(
        '已订阅用户状态',
        text,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
    } catch (e) {
      Get.snackbar('失败', '$e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// 查询用户状态（无需订阅）
  Future<void> getUserStatus(String userID) async {
    try {
      final list = await OpenIM.iMManager.userManager.getUserStatus([userID]);
      if (list.isNotEmpty) {
        final s = list.first;
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

  /// 获取用户客户端配置
  Future<void> loadClientConfig() async {
    try {
      clientConfig.value = await OpenIM.iMManager.userManager.getUserClientConfig();
      Get.snackbar(
        '配置已加载',
        '共 ${clientConfig.value?.length ?? 0} 项',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('失败', '$e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// 获取用户信息（带缓存）
  Future<List<UserInfo>> getUsersInfoWithCache(List<String> userIDs) async {
    try {
      return await OpenIM.iMManager.userManager.getUsersInfoWithCache(userIDList: userIDs);
    } catch (_) {
      return [];
    }
  }

  /// 从服务器获取用户信息
  Future<List<UserInfo>> getUsersInfoFromSrv(List<String> userIDs) async {
    try {
      return await OpenIM.iMManager.userManager.getUsersInfoFromSrv(userIDList: userIDs);
    } catch (_) {
      return [];
    }
  }

  // ---- SDK 控制 ----

  /// 设置前后台状态
  Future<void> setBackgroundStatus(bool bg) async {
    try {
      await OpenIM.iMManager.setAppBackgroundStatus(isBackground: bg);
      isBackground.value = bg;
      Get.snackbar('成功', bg ? '已进入后台模式' : '已恢复前台模式', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('失败', '$e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// 通知网络状态变化
  Future<void> notifyNetworkChanged() async {
    try {
      await OpenIM.iMManager.networkStatusChanged();
      Get.snackbar('成功', '网络重连已触发', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('失败', '$e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// 设置应用角标数
  Future<void> setAppBadge(int count) async {
    try {
      await OpenIM.iMManager.setAppBadge(appUnreadCount: count);
      Get.snackbar('成功', '角标已设置为 $count', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('失败', '$e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// 更新 FCM Token
  Future<void> updateFcmToken(String token) async {
    try {
      await OpenIM.iMManager.updateFcmToken(fcmToken: token);
      Get.snackbar('成功', 'FCM Token 已更新', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('失败', '$e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// 上传文件
  Future<void> uploadFile(String filePath, String fileName) async {
    try {
      final url = await OpenIM.iMManager.uploadFile(
        id: 'upload_${DateTime.now().millisecondsSinceEpoch}',
        filePath: filePath,
        fileName: fileName,
      );
      Get.snackbar(
        '上传成功',
        url,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
    } catch (e) {
      Get.snackbar('上传失败', '$e', snackPosition: SnackPosition.BOTTOM);
    }
  }
}

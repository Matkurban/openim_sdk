import 'dart:developer' as dev;

import 'package:get/get.dart';
import 'package:openim_sdk/openim_sdk.dart';
import '../routes/app_routes.dart';

class SplashController extends GetxController {
  final statusText = '正在初始化...'.obs;

  // 默认服务器地址（与登录页一致）
  static const defaultApiAddr = 'http://115.190.173.31:10002';
  static const defaultWsAddr = 'ws://115.190.173.31:10001';
  static const defaultChatAddr = 'http://115.190.173.31:10008';

  @override
  void onInit() {
    super.onInit();
    _initSdk();
  }

  Future<void> _initSdk() async {
    dev.log('[Splash] 开始初始化 SDK...');
    try {
      final ok = await OpenIM.iMManager.initSDK(
        apiAddr: defaultApiAddr,
        wsAddr: defaultWsAddr,
        chatAddr: defaultChatAddr,
        listener: OnConnectListener(
          onConnectSuccess: () => dev.log('[Splash] WS 已连接'),
          onConnecting: () => dev.log('[Splash] WS 连接中...'),
          onConnectFailed: (code, msg) =>
              dev.log('[Splash] WS 连接失败: $code $msg'),
          onKickedOffline: () {
            Get.snackbar(
              '提示',
              '账号在其他设备登录',
              snackPosition: SnackPosition.BOTTOM,
            );
            Get.offAllNamed(AppRoutes.login);
          },
          onUserTokenExpired: () {
            Get.snackbar('提示', 'Token已过期', snackPosition: SnackPosition.BOTTOM);
            Get.offAllNamed(AppRoutes.login);
          },
          onUserTokenInvalid: () {
            Get.snackbar('提示', 'Token无效', snackPosition: SnackPosition.BOTTOM);
            Get.offAllNamed(AppRoutes.login);
          },
        ),
      );

      if (!ok) {
        dev.log('[Splash] SDK 初始化失败');
        statusText.value = 'SDK初始化失败，请重启应用';
        return;
      }

      dev.log('[Splash] SDK 初始化成功, 跳转登录页');
      Get.offAllNamed(AppRoutes.login);
    } catch (e, s) {
      dev.log('[Splash] 初始化异常: $e');
      dev.log('[Splash] StackTrace: $s');
      statusText.value = '初始化失败: $e';
    }
  }
}

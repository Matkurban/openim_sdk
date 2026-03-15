import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openim_sdk/openim_sdk.dart';
import '../routes/app_routes.dart';
import 'im_listener_service.dart';

class LoginController extends GetxController {
  final accountCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final areaCodeCtrl = TextEditingController(text: '+86');

  /// 0 = 手机号, 1 = 邮箱
  final loginMode = 0.obs;

  final isLoading = false.obs;
  final statusText = ''.obs;

  @override
  void onClose() {
    accountCtrl.dispose();
    passwordCtrl.dispose();
    areaCodeCtrl.dispose();
    super.onClose();
  }

  void toggleLoginMode() {
    loginMode.value = loginMode.value == 0 ? 1 : 0;
    accountCtrl.clear();
  }

  Future<void> login() async {
    final account = accountCtrl.text.trim();
    final password = passwordCtrl.text.trim();
    final areaCode = areaCodeCtrl.text.trim();

    if (account.isEmpty || password.isEmpty) {
      Get.snackbar('错误', '请填写账号和密码', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (loginMode.value == 0 && areaCode.isEmpty) {
      Get.snackbar('错误', '请填写区号', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;
    statusText.value = '正在登录...';

    dev.log('[Login] loginMode=${loginMode.value == 0 ? "phone" : "email"}');
    dev.log('[Login] account=$account, areaCode=$areaCode');

    try {
      // 在 login 之前注册所有 SDK 监听，确保 doConnectedSync 的回调不会丢失
      Get.put(IMListenerService(), permanent: true).initialize();

      if (loginMode.value == 0) {
        dev.log('[Login] calling loginByPhone(areaCode=$areaCode, phone=$account)');
        await OpenIM.iMManager.loginByPhone(
          areaCode: areaCode,
          phoneNumber: account,
          password: password,
        );
      } else {
        dev.log('[Login] calling loginByEmail(email=$account)');
        await OpenIM.iMManager.loginByEmail(email: account, password: password);
      }

      statusText.value = '';
      Get.offAllNamed(AppRoutes.home);
    } catch (e, s) {
      dev.log('[Login] ERROR: $e');
      dev.log('[Login] StackTrace: $s');
      statusText.value = '登录失败';
      Get.snackbar('错误', '$e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}

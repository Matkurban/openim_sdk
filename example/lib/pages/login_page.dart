import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo
                Icon(
                  Icons.chat_bubble_rounded,
                  size: 72,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 12),
                Text(
                  'OpenIM',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'SDK Demo',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 32),

                // Login mode toggle
                Obx(
                  () => Row(
                    children: [
                      Expanded(
                        child: ChoiceChip(
                          label: const Text('手机号'),
                          selected: controller.loginMode.value == 0,
                          onSelected: (_) {
                            if (controller.loginMode.value != 0) controller.toggleLoginMode();
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ChoiceChip(
                          label: const Text('邮箱'),
                          selected: controller.loginMode.value == 1,
                          onSelected: (_) {
                            if (controller.loginMode.value != 1) controller.toggleLoginMode();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Account fields
                Obx(() {
                  if (controller.loginMode.value == 0) {
                    // Phone mode
                    return Row(
                      children: [
                        SizedBox(
                          width: 80,
                          child: TextField(
                            controller: controller.areaCodeCtrl,
                            decoration: const InputDecoration(
                              labelText: '区号',
                              prefixIcon: Icon(Icons.language, size: 20),
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: controller.accountCtrl,
                            decoration: const InputDecoration(
                              labelText: '手机号',
                              prefixIcon: Icon(Icons.phone),
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                      ],
                    );
                  } else {
                    // Email mode
                    return TextField(
                      controller: controller.accountCtrl,
                      decoration: const InputDecoration(
                        labelText: '邮箱',
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    );
                  }
                }),
                const SizedBox(height: 12),

                // Password
                TextField(
                  controller: controller.passwordCtrl,
                  decoration: const InputDecoration(labelText: '密码', prefixIcon: Icon(Icons.lock)),
                  obscureText: true,
                ),
                const SizedBox(height: 32),

                // Login button
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      onPressed: controller.isLoading.value ? null : controller.login,
                      child: controller.isLoading.value
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Text('登录', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ),

                // Status
                Obx(() {
                  if (controller.statusText.isEmpty) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      controller.statusText.value,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

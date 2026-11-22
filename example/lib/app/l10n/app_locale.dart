import 'package:flutter/widgets.dart';

/// 应用支持的界面语言枚举。
///
/// Supported application UI locales.
enum AppLocale {
  /// 简体中文。
  zhCN('zh', 'CN', '简体中文'),

  /// English (US)。
  enUS('en', 'US', 'English');

  /// 语言代码。
  final String languageCode;

  /// 地区代码。
  final String countryCode;

  /// 显示名称。
  final String displayName;

  const AppLocale(this.languageCode, this.countryCode, this.displayName);

  /// 转换为 Flutter [Locale]。
  Locale toLocale() => Locale(languageCode, countryCode);

  /// 从持久化代码恢复语言。
  static AppLocale fromCode(String? code) {
    if (code == 'en_US' || code == 'en') {
      return AppLocale.enUS;
    }
    return AppLocale.zhCN;
  }

  /// 序列化为存储代码。
  String get storageCode => '${languageCode}_$countryCode';
}

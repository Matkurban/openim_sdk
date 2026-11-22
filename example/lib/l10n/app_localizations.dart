import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @appName.
  ///
  /// In zh, this message translates to:
  /// **'OpenIM 聊天'**
  String get appName;

  /// No description provided for @tabChats.
  ///
  /// In zh, this message translates to:
  /// **'消息'**
  String get tabChats;

  /// No description provided for @tabContacts.
  ///
  /// In zh, this message translates to:
  /// **'通讯录'**
  String get tabContacts;

  /// No description provided for @tabMoments.
  ///
  /// In zh, this message translates to:
  /// **'朋友圈'**
  String get tabMoments;

  /// No description provided for @tabMe.
  ///
  /// In zh, this message translates to:
  /// **'我'**
  String get tabMe;

  /// No description provided for @login.
  ///
  /// In zh, this message translates to:
  /// **'登录'**
  String get login;

  /// No description provided for @register.
  ///
  /// In zh, this message translates to:
  /// **'注册'**
  String get register;

  /// No description provided for @logout.
  ///
  /// In zh, this message translates to:
  /// **'退出登录'**
  String get logout;

  /// No description provided for @emailLogin.
  ///
  /// In zh, this message translates to:
  /// **'邮箱 + 密码'**
  String get emailLogin;

  /// No description provided for @accountLogin.
  ///
  /// In zh, this message translates to:
  /// **'账号 + 密码'**
  String get accountLogin;

  /// No description provided for @email.
  ///
  /// In zh, this message translates to:
  /// **'邮箱地址'**
  String get email;

  /// No description provided for @account.
  ///
  /// In zh, this message translates to:
  /// **'登录账号'**
  String get account;

  /// No description provided for @password.
  ///
  /// In zh, this message translates to:
  /// **'密码'**
  String get password;

  /// No description provided for @nickname.
  ///
  /// In zh, this message translates to:
  /// **'昵称'**
  String get nickname;

  /// No description provided for @verifyCode.
  ///
  /// In zh, this message translates to:
  /// **'验证码'**
  String get verifyCode;

  /// No description provided for @sendCode.
  ///
  /// In zh, this message translates to:
  /// **'获取验证码'**
  String get sendCode;

  /// No description provided for @serverConfig.
  ///
  /// In zh, this message translates to:
  /// **'服务器设置'**
  String get serverConfig;

  /// No description provided for @forgotPassword.
  ///
  /// In zh, this message translates to:
  /// **'忘记密码'**
  String get forgotPassword;

  /// No description provided for @accountAppeal.
  ///
  /// In zh, this message translates to:
  /// **'账号申诉'**
  String get accountAppeal;

  /// No description provided for @search.
  ///
  /// In zh, this message translates to:
  /// **'搜索'**
  String get search;

  /// No description provided for @addContact.
  ///
  /// In zh, this message translates to:
  /// **'添加联系人'**
  String get addContact;

  /// No description provided for @createGroup.
  ///
  /// In zh, this message translates to:
  /// **'创建群聊'**
  String get createGroup;

  /// No description provided for @joinGroup.
  ///
  /// In zh, this message translates to:
  /// **'加入群聊'**
  String get joinGroup;

  /// No description provided for @scanQr.
  ///
  /// In zh, this message translates to:
  /// **'扫一扫'**
  String get scanQr;

  /// No description provided for @selectFromAlbum.
  ///
  /// In zh, this message translates to:
  /// **'从相册选择'**
  String get selectFromAlbum;

  /// No description provided for @newFriends.
  ///
  /// In zh, this message translates to:
  /// **'新的朋友'**
  String get newFriends;

  /// No description provided for @groupNotifications.
  ///
  /// In zh, this message translates to:
  /// **'群通知'**
  String get groupNotifications;

  /// No description provided for @myGroups.
  ///
  /// In zh, this message translates to:
  /// **'我的群聊'**
  String get myGroups;

  /// No description provided for @favorites.
  ///
  /// In zh, this message translates to:
  /// **'我的收藏'**
  String get favorites;

  /// No description provided for @pointsCenter.
  ///
  /// In zh, this message translates to:
  /// **'积分中心'**
  String get pointsCenter;

  /// No description provided for @settings.
  ///
  /// In zh, this message translates to:
  /// **'通用与安全设置'**
  String get settings;

  /// No description provided for @themeMode.
  ///
  /// In zh, this message translates to:
  /// **'主题模式'**
  String get themeMode;

  /// No description provided for @language.
  ///
  /// In zh, this message translates to:
  /// **'界面语言'**
  String get language;

  /// No description provided for @screenProtection.
  ///
  /// In zh, this message translates to:
  /// **'屏幕保护（防截屏 / 录屏与切后台模糊）'**
  String get screenProtection;

  /// No description provided for @cacheManagement.
  ///
  /// In zh, this message translates to:
  /// **'缓存管理与清理'**
  String get cacheManagement;

  /// No description provided for @checkUpdate.
  ///
  /// In zh, this message translates to:
  /// **'检查更新'**
  String get checkUpdate;

  /// No description provided for @deviceInfo.
  ///
  /// In zh, this message translates to:
  /// **'设备信息'**
  String get deviceInfo;

  /// No description provided for @downloads.
  ///
  /// In zh, this message translates to:
  /// **'后台下载管理'**
  String get downloads;

  /// No description provided for @accountSecurity.
  ///
  /// In zh, this message translates to:
  /// **'账号与安全'**
  String get accountSecurity;

  /// No description provided for @send.
  ///
  /// In zh, this message translates to:
  /// **'发送'**
  String get send;

  /// No description provided for @cancel.
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In zh, this message translates to:
  /// **'确认'**
  String get confirm;

  /// No description provided for @save.
  ///
  /// In zh, this message translates to:
  /// **'保存'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In zh, this message translates to:
  /// **'删除'**
  String get delete;

  /// No description provided for @qrLoginTitle.
  ///
  /// In zh, this message translates to:
  /// **'使用手机 OpenIM 扫码登录'**
  String get qrLoginTitle;

  /// No description provided for @qrLoginHint.
  ///
  /// In zh, this message translates to:
  /// **'请打开手机端 OpenIM 扫一扫确认登录'**
  String get qrLoginHint;

  /// No description provided for @qrLoginScanned.
  ///
  /// In zh, this message translates to:
  /// **'已扫描，请在手机端点击确认登录'**
  String get qrLoginScanned;

  /// No description provided for @qrLoginExpired.
  ///
  /// In zh, this message translates to:
  /// **'二维码已过期，请刷新重试'**
  String get qrLoginExpired;

  /// No description provided for @qrLoginLoading.
  ///
  /// In zh, this message translates to:
  /// **'正在生成登录二维码...'**
  String get qrLoginLoading;

  /// No description provided for @qrLoginRefresh.
  ///
  /// In zh, this message translates to:
  /// **'刷新二维码'**
  String get qrLoginRefresh;

  /// No description provided for @switchToQrLogin.
  ///
  /// In zh, this message translates to:
  /// **'扫码登录'**
  String get switchToQrLogin;

  /// No description provided for @switchToPasswordLogin.
  ///
  /// In zh, this message translates to:
  /// **'账号密码登录'**
  String get switchToPasswordLogin;

  /// No description provided for @qrLoginConfirmTitle.
  ///
  /// In zh, this message translates to:
  /// **'桌面端登录确认'**
  String get qrLoginConfirmTitle;

  /// No description provided for @qrLoginConfirmMessage.
  ///
  /// In zh, this message translates to:
  /// **'确认登录 OpenIM {platform} 客户端吗？'**
  String qrLoginConfirmMessage(String platform);

  /// No description provided for @qrLoginConfirmIp.
  ///
  /// In zh, this message translates to:
  /// **'登录 IP：{ip}'**
  String qrLoginConfirmIp(String ip);

  /// No description provided for @qrLoginConfirmButton.
  ///
  /// In zh, this message translates to:
  /// **'确认登录'**
  String get qrLoginConfirmButton;

  /// No description provided for @qrLoginConfirming.
  ///
  /// In zh, this message translates to:
  /// **'正在授权登录...'**
  String get qrLoginConfirming;

  /// No description provided for @qrLoginConfirmSuccess.
  ///
  /// In zh, this message translates to:
  /// **'已授权桌面端登录'**
  String get qrLoginConfirmSuccess;

  /// No description provided for @qrLoginPlatformWindows.
  ///
  /// In zh, this message translates to:
  /// **'Windows'**
  String get qrLoginPlatformWindows;

  /// No description provided for @qrLoginPlatformMac.
  ///
  /// In zh, this message translates to:
  /// **'macOS'**
  String get qrLoginPlatformMac;

  /// No description provided for @qrLoginPlatformLinux.
  ///
  /// In zh, this message translates to:
  /// **'Linux'**
  String get qrLoginPlatformLinux;

  /// No description provided for @qrLoginPlatformDesktop.
  ///
  /// In zh, this message translates to:
  /// **'桌面端'**
  String get qrLoginPlatformDesktop;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

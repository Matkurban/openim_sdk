// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => 'OpenIM 聊天';

  @override
  String get tabChats => '消息';

  @override
  String get tabContacts => '通讯录';

  @override
  String get tabMoments => '朋友圈';

  @override
  String get tabMe => '我';

  @override
  String get login => '登录';

  @override
  String get register => '注册';

  @override
  String get logout => '退出登录';

  @override
  String get emailLogin => '邮箱 + 密码';

  @override
  String get accountLogin => '账号 + 密码';

  @override
  String get email => '邮箱地址';

  @override
  String get account => '登录账号';

  @override
  String get password => '密码';

  @override
  String get nickname => '昵称';

  @override
  String get verifyCode => '验证码';

  @override
  String get sendCode => '获取验证码';

  @override
  String get serverConfig => '服务器设置';

  @override
  String get forgotPassword => '忘记密码';

  @override
  String get accountAppeal => '账号申诉';

  @override
  String get search => '搜索';

  @override
  String get addContact => '添加联系人';

  @override
  String get createGroup => '创建群聊';

  @override
  String get joinGroup => '加入群聊';

  @override
  String get scanQr => '扫一扫';

  @override
  String get selectFromAlbum => '从相册选择';

  @override
  String get newFriends => '新的朋友';

  @override
  String get groupNotifications => '群通知';

  @override
  String get myGroups => '我的群聊';

  @override
  String get favorites => '我的收藏';

  @override
  String get pointsCenter => '积分中心';

  @override
  String get settings => '通用与安全设置';

  @override
  String get themeMode => '主题模式';

  @override
  String get language => '界面语言';

  @override
  String get screenProtection => '屏幕保护（防截屏 / 录屏与切后台模糊）';

  @override
  String get cacheManagement => '缓存管理与清理';

  @override
  String get checkUpdate => '检查更新';

  @override
  String get deviceInfo => '设备信息';

  @override
  String get downloads => '后台下载管理';

  @override
  String get accountSecurity => '账号与安全';

  @override
  String get send => '发送';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '确认';

  @override
  String get save => '保存';

  @override
  String get delete => '删除';

  @override
  String get qrLoginTitle => '使用手机 OpenIM 扫码登录';

  @override
  String get qrLoginHint => '请打开手机端 OpenIM 扫一扫确认登录';

  @override
  String get qrLoginScanned => '已扫描，请在手机端点击确认登录';

  @override
  String get qrLoginExpired => '二维码已过期，请刷新重试';

  @override
  String get qrLoginLoading => '正在生成登录二维码...';

  @override
  String get qrLoginRefresh => '刷新二维码';

  @override
  String get switchToQrLogin => '扫码登录';

  @override
  String get switchToPasswordLogin => '账号密码登录';

  @override
  String get qrLoginConfirmTitle => '桌面端登录确认';

  @override
  String qrLoginConfirmMessage(String platform) {
    return '确认登录 OpenIM $platform 客户端吗？';
  }

  @override
  String qrLoginConfirmIp(String ip) {
    return '登录 IP：$ip';
  }

  @override
  String get qrLoginConfirmButton => '确认登录';

  @override
  String get qrLoginConfirming => '正在授权登录...';

  @override
  String get qrLoginConfirmSuccess => '已授权桌面端登录';

  @override
  String get qrLoginPlatformWindows => 'Windows';

  @override
  String get qrLoginPlatformMac => 'macOS';

  @override
  String get qrLoginPlatformLinux => 'Linux';

  @override
  String get qrLoginPlatformDesktop => '桌面端';
}

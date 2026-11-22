// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'OpenIM Chat';

  @override
  String get tabChats => 'Chats';

  @override
  String get tabContacts => 'Contacts';

  @override
  String get tabMoments => 'Moments';

  @override
  String get tabMe => 'Me';

  @override
  String get login => 'Sign In';

  @override
  String get register => 'Sign Up';

  @override
  String get logout => 'Sign Out';

  @override
  String get emailLogin => 'Email + Password';

  @override
  String get accountLogin => 'Account + Password';

  @override
  String get email => 'Email';

  @override
  String get account => 'Account';

  @override
  String get password => 'Password';

  @override
  String get nickname => 'Nickname';

  @override
  String get verifyCode => 'Verification Code';

  @override
  String get sendCode => 'Send Code';

  @override
  String get serverConfig => 'Server Settings';

  @override
  String get forgotPassword => 'Forgot Password';

  @override
  String get accountAppeal => 'Account Appeal';

  @override
  String get search => 'Search';

  @override
  String get addContact => 'Add Contact';

  @override
  String get createGroup => 'New Group';

  @override
  String get joinGroup => 'Join Group';

  @override
  String get scanQr => 'Scan QR';

  @override
  String get selectFromAlbum => 'Album';

  @override
  String get newFriends => 'New Friends';

  @override
  String get groupNotifications => 'Group Notices';

  @override
  String get myGroups => 'My Groups';

  @override
  String get favorites => 'Favorites';

  @override
  String get pointsCenter => 'Points Center';

  @override
  String get settings => 'General & Security';

  @override
  String get themeMode => 'Theme';

  @override
  String get language => 'Language';

  @override
  String get screenProtection => 'Screen Protection (Anti-Capture & Blur)';

  @override
  String get cacheManagement => 'Cache Management';

  @override
  String get checkUpdate => 'Check for Updates';

  @override
  String get deviceInfo => 'Device Info';

  @override
  String get downloads => 'Downloads';

  @override
  String get accountSecurity => 'Account & Security';

  @override
  String get send => 'Send';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get qrLoginTitle => 'Scan QR Code with Mobile OpenIM';

  @override
  String get qrLoginHint => 'Open OpenIM on your phone and scan to sign in';

  @override
  String get qrLoginScanned => 'Scanned. Please confirm on your phone';

  @override
  String get qrLoginExpired => 'QR code expired. Tap to refresh';

  @override
  String get qrLoginLoading => 'Generating QR code...';

  @override
  String get qrLoginRefresh => 'Refresh QR Code';

  @override
  String get switchToQrLogin => 'QR Code Login';

  @override
  String get switchToPasswordLogin => 'Password Login';

  @override
  String get qrLoginConfirmTitle => 'Desktop Login Confirmation';

  @override
  String qrLoginConfirmMessage(String platform) {
    return 'Confirm signing in to OpenIM $platform?';
  }

  @override
  String qrLoginConfirmIp(String ip) {
    return 'Client IP: $ip';
  }

  @override
  String get qrLoginConfirmButton => 'Confirm Sign In';

  @override
  String get qrLoginConfirming => 'Authorizing desktop login...';

  @override
  String get qrLoginConfirmSuccess => 'Desktop login authorized';

  @override
  String get qrLoginPlatformWindows => 'Windows';

  @override
  String get qrLoginPlatformMac => 'macOS';

  @override
  String get qrLoginPlatformLinux => 'Linux';

  @override
  String get qrLoginPlatformDesktop => 'Desktop';
}

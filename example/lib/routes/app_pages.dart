import 'package:get/get.dart';
import 'app_routes.dart';
import '../pages/splash_page.dart';
import '../pages/login_page.dart';
import '../controllers/splash_controller.dart';
import '../pages/home_page.dart';
import '../pages/chat_page.dart';
import '../pages/contacts_page.dart';
import '../pages/add_friend_page.dart';
import '../pages/friend_requests_page.dart';
import '../pages/user_profile_page.dart';
import '../pages/create_group_page.dart';
import '../pages/group_info_page.dart';
import '../pages/settings_page.dart';
import '../controllers/login_controller.dart';
import '../controllers/home_controller.dart';
import '../controllers/chat_controller.dart';
import '../controllers/contacts_controller.dart';
import '../controllers/settings_controller.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
      binding: BindingsBuilder(() {
        Get.put(SplashController());
      }),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: BindingsBuilder(() => Get.lazyPut(() => LoginController())),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: BindingsBuilder(() => Get.lazyPut(() => HomeController())),
    ),
    GetPage(
      name: AppRoutes.chat,
      page: () => const ChatPage(),
      binding: BindingsBuilder(() => Get.lazyPut(() => ChatController())),
    ),
    GetPage(
      name: AppRoutes.contacts,
      page: () => const ContactsPage(),
      binding: BindingsBuilder(() => Get.lazyPut(() => ContactsController())),
    ),
    GetPage(name: AppRoutes.addFriend, page: () => const AddFriendPage()),
    GetPage(
      name: AppRoutes.friendRequests,
      page: () => const FriendRequestsPage(),
    ),
    GetPage(name: AppRoutes.userProfile, page: () => const UserProfilePage()),
    GetPage(name: AppRoutes.createGroup, page: () => const CreateGroupPage()),
    GetPage(name: AppRoutes.groupInfo, page: () => const GroupInfoPage()),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsPage(),
      binding: BindingsBuilder(() => Get.lazyPut(() => SettingsController())),
    ),
  ];
}

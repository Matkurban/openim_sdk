import 'package:get/get.dart';
import 'package:openim_sdk/openim_sdk.dart';

class ContactsController extends GetxController {
  final friends = <FriendInfo>[].obs;
  final groups = <GroupInfo>[].obs;
  final blacklist = <BlacklistInfo>[].obs;
  final friendRequests = <FriendApplicationInfo>[].obs;
  final groupRequests = <GroupApplicationInfo>[].obs;
  final isLoading = false.obs;
  final tabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _setupListeners();
    refresh();
  }

  void _setupListeners() {
    OpenIM.iMManager.friendshipManager.setFriendshipListener(
      OnFriendshipListener(
        onFriendAdded: (_) => _loadFriends(),
        onFriendDeleted: (_) => _loadFriends(),
        onFriendInfoChanged: (_) => _loadFriends(),
        onBlackAdded: (_) => _loadBlacklist(),
        onBlackDeleted: (_) => _loadBlacklist(),
        onFriendApplicationAdded: (_) => _loadFriendRequests(),
        onFriendApplicationAccepted: (_) {
          _loadFriendRequests();
          _loadFriends();
        },
        onFriendApplicationRejected: (_) => _loadFriendRequests(),
      ),
    );

    OpenIM.iMManager.groupManager.setGroupListener(
      OnGroupListener(
        onJoinedGroupAdded: (_) => _loadGroups(),
        onJoinedGroupDeleted: (_) => _loadGroups(),
        onGroupInfoChanged: (_) => _loadGroups(),
        onGroupApplicationAdded: (_) => _loadGroupRequests(),
        onGroupApplicationAccepted: (_) {
          _loadGroupRequests();
          _loadGroups();
        },
        onGroupApplicationRejected: (_) => _loadGroupRequests(),
      ),
    );
  }

  @override
  Future<void> refresh() async {
    isLoading.value = true;
    await Future.wait([
      _loadFriends(),
      _loadGroups(),
      _loadBlacklist(),
      _loadFriendRequests(),
      _loadGroupRequests(),
    ]);
    isLoading.value = false;
  }

  Future<void> _loadFriends() async {
    try {
      friends.value = await OpenIM.iMManager.friendshipManager.getFriendList();
    } catch (_) {}
  }

  Future<void> _loadGroups() async {
    try {
      groups.value = await OpenIM.iMManager.groupManager.getJoinedGroupList();
    } catch (_) {}
  }

  Future<void> _loadBlacklist() async {
    try {
      blacklist.value = await OpenIM.iMManager.friendshipManager.getBlacklist();
    } catch (_) {}
  }

  Future<void> _loadFriendRequests() async {
    try {
      friendRequests.value = await OpenIM.iMManager.friendshipManager
          .getFriendApplicationListAsRecipient();
    } catch (_) {}
  }

  Future<void> _loadGroupRequests() async {
    try {
      groupRequests.value = await OpenIM.iMManager.groupManager
          .getGroupApplicationListAsRecipient();
    } catch (_) {}
  }

  Future<void> deleteFriend(String userID) async {
    try {
      await OpenIM.iMManager.friendshipManager.deleteFriend(userID: userID);
      friends.removeWhere((f) => f.friendUserID == userID);
      Get.snackbar('成功', '已删除好友', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('失败', '$e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> addToBlacklist(String userID) async {
    try {
      await OpenIM.iMManager.friendshipManager.addBlacklist(userID: userID);
      await _loadBlacklist();
      Get.snackbar('成功', '已加入黑名单', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('失败', '$e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> removeFromBlacklist(String userID) async {
    try {
      await OpenIM.iMManager.friendshipManager.removeBlacklist(userID: userID);
      blacklist.removeWhere((b) => b.blockUserID == userID);
      Get.snackbar('成功', '已移除黑名单', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('失败', '$e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> acceptFriendRequest(FriendApplicationInfo info) async {
    try {
      await OpenIM.iMManager.friendshipManager.acceptFriendApplication(userID: info.fromUserID!);
      await _loadFriendRequests();
      await _loadFriends();
      Get.snackbar('成功', '已接受好友请求', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('失败', '$e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> rejectFriendRequest(FriendApplicationInfo info) async {
    try {
      await OpenIM.iMManager.friendshipManager.refuseFriendApplication(userID: info.fromUserID!);
      await _loadFriendRequests();
      Get.snackbar('成功', '已拒绝好友请求', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('失败', '$e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> acceptGroupRequest(GroupApplicationInfo info) async {
    try {
      await OpenIM.iMManager.groupManager.acceptGroupApplication(
        groupID: info.groupID!,
        userID: info.userID!,
      );
      await _loadGroupRequests();
      await _loadGroups();
      Get.snackbar('成功', '已接受入群请求', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('失败', '$e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> rejectGroupRequest(GroupApplicationInfo info) async {
    try {
      await OpenIM.iMManager.groupManager.refuseGroupApplication(
        groupID: info.groupID!,
        userID: info.userID!,
      );
      await _loadGroupRequests();
      Get.snackbar('成功', '已拒绝入群请求', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('失败', '$e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> quitGroup(String groupID) async {
    try {
      await OpenIM.iMManager.groupManager.quitGroup(groupID: groupID);
      groups.removeWhere((g) => g.groupID == groupID);
      Get.snackbar('成功', '已退出群组', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('失败', '$e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// Start a chat with a friend
  Future<void> startChat(FriendInfo friend) async {
    try {
      final conv = await OpenIM.iMManager.conversationManager.getOneConversation(
        sourceID: friend.friendUserID!,
        sessionType: ConversationType.single.value,
      );
      Get.toNamed('/chat', arguments: conv);
    } catch (e) {
      Get.snackbar('失败', '$e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// Start a group chat
  Future<void> startGroupChat(GroupInfo group) async {
    try {
      final conv = await OpenIM.iMManager.conversationManager.getOneConversation(
        sourceID: group.groupID,
        sessionType: ConversationType.superGroup.value,
      );
      Get.toNamed('/chat', arguments: conv);
    } catch (e) {
      Get.snackbar('失败', '$e', snackPosition: SnackPosition.BOTTOM);
    }
  }
}

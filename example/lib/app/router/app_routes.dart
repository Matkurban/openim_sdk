/// 全局路由路径常量定义。
///
/// Global route path constants for `AdaptiveRouter`.
abstract final class AppRoutes {
  /// 启动页。
  static const String splash = '/splash';

  /// 引导页。
  static const String onboarding = '/onboarding';

  /// 登录页。
  static const String login = '/login';

  /// 邮箱注册页。
  static const String register = '/register';

  /// 忘记密码页。
  static const String forgotPassword = '/forgot-password';

  /// 账号申诉页。
  static const String appeal = '/appeal';

  /// 桌面端扫码登录授权确认页。
  static const String qrDesktopLoginConfirm = '/qr-desktop-login-confirm';

  /// Tab 1：会话列表。
  static const String conversations = '/conversations';

  /// 全局聚合搜索。
  static const String globalSearch = '/conversations/search';

  /// 添加联系人。
  static const String addContact = '/conversations/add-contact';

  /// 创建群聊。
  static const String createGroup = '/conversations/create-group';

  /// 加入群聊。
  static const String joinGroup = '/conversations/join-group';

  /// 聊天页路径模板。
  static const String chatPath = '/conversations/chat/:conversationId';

  /// 构造聊天页路径。
  static String chat(String conversationId) =>
      '/conversations/chat/${Uri.encodeComponent(conversationId)}';

  /// 构造私聊详情路径。
  static String privateChatDetail(String conversationId) =>
      '${chat(conversationId)}/private-detail';

  /// 构造群聊详情路径。
  static String groupChatDetail(String conversationId) =>
      '${chat(conversationId)}/group-detail';

  /// 构造群管理路径。
  static String groupManagement(String conversationId) =>
      '${chat(conversationId)}/group-management';

  /// 构造群管理员路径。
  static String groupAdmins(String conversationId) =>
      '${chat(conversationId)}/group-admins';

  /// 构造转让群主路径。
  static String groupTransfer(String conversationId) =>
      '${chat(conversationId)}/group-transfer';

  /// 构造群成员管理路径。
  static String groupMembers(String conversationId) =>
      '${chat(conversationId)}/group-members';

  /// 构造单成员详情路径。
  static String groupMemberDetail(String conversationId, String userId) =>
      '${chat(conversationId)}/group-member/${Uri.encodeComponent(userId)}';

  /// 构造群公告路径。
  static String groupAnnouncement(String conversationId) =>
      '${chat(conversationId)}/group-announcement';

  /// 构造群二维码路径。
  static String groupQr(String conversationId) =>
      '${chat(conversationId)}/group-qr';

  /// 构造单会话聊天记录搜索路径。
  static String chatSearch(String conversationId) =>
      '${chat(conversationId)}/search';

  /// 构造会话媒体画廊路径。
  static String chatGallery(String conversationId) =>
      '${chat(conversationId)}/gallery';

  /// 构造合并转发详情路径。
  static String mergeMessageDetail(String conversationId) =>
      '${chat(conversationId)}/merge';

  /// 构造发红包路径。
  static String sendRedPacket(String conversationId) =>
      '${chat(conversationId)}/send-red-packet';

  /// 构造红包详情路径。
  static String redPacketDetail(String conversationId, String packetId) =>
      '${chat(conversationId)}/red-packet/${Uri.encodeComponent(packetId)}';

  /// Tab 2：通讯录。
  static const String contacts = '/contacts';

  /// 通讯录分支内添加联系人。
  static const String contactAdd = '/contacts/add-contact';

  /// 新的朋友。
  static const String newFriends = '/contacts/new-friends';

  /// 群通知。
  static const String groupNotifications = '/contacts/group-notifications';

  /// 我的群聊。
  static const String myGroups = '/contacts/my-groups';

  /// 构造联系人资料路径。
  static String contactProfile(String userId) =>
      '/contacts/profile/${Uri.encodeComponent(userId)}';

  /// 构造设置好友备注路径。
  static String friendRemark(String userId) =>
      '${contactProfile(userId)}/remark';

  /// 构造个人/好友朋友圈相册路径。
  static String userMoments(String userId) =>
      '${contactProfile(userId)}/moments';

  /// Tab 3：朋友圈。
  static const String moments = '/moments';

  /// 发布朋友圈。
  static const String momentPublish = '/moments/publish';

  /// 朋友圈互动消息。
  static const String momentNotifications = '/moments/notifications';

  /// 构造朋友圈分支内个人相册路径。
  static String momentsUserAlbum(String userId) =>
      '/moments/user/${Uri.encodeComponent(userId)}';

  /// 构造朋友圈详情路径。
  static String momentDetail(String momentId) =>
      '/moments/detail/${Uri.encodeComponent(momentId)}';

  /// Tab 4：我的。
  static const String profile = '/profile';

  /// 编辑个人资料。
  static const String editProfile = '/profile/edit';

  /// 我的二维码名片。
  static const String myQr = '/profile/qr';

  /// 我的朋友圈相册（挂载在「我的」分支下）。
  static const String myMoments = '/profile/moments';

  /// 我的收藏。
  static const String favorites = '/profile/favorites';

  /// 收藏详情。
  static const String favoriteDetail = '/profile/favorites/detail';

  /// 新建/编辑收藏笔记与链接。
  static const String favoriteNoteEditor = '/profile/favorites/note-editor';

  /// 积分中心。
  static const String points = '/profile/points';

  /// 积分收支明细。
  static const String pointsTransactions = '/profile/points/transactions';

  /// 通用与安全设置。
  static const String settings = '/profile/settings';

  /// 账号与安全。
  static const String accountSecurity = '/profile/settings/security';

  /// 支付密码设置。
  static const String paymentPassword = '/profile/settings/payment-password';

  /// 黑名单管理。
  static const String blacklist = '/profile/settings/blacklist';

  /// 后台下载管理。
  static const String downloads = '/profile/settings/downloads';

  /// 设备信息。
  static const String deviceInfo = '/profile/settings/device-info';

  /// 扫一扫全屏页。
  static const String scanner = '/scanner';

  /// 音视频通话全屏页。
  static const String call = '/call';

  /// 图片全屏预览页。
  static const String imagePreview = '/preview/image';

  /// 视频全屏播放页。
  static const String videoPreview = '/preview/video';

  /// 文件详情与下载预览页。
  static const String filePreview = '/preview/file';

  /// 位置预览页。
  static const String locationPreview = '/preview/location';

  /// 发送位置选择页。
  static const String locationPicker = '/preview/location-picker';

  /// 投诉举报页。
  static const String report = '/report';
}

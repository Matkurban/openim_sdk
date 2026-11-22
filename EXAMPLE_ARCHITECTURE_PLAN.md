# OpenIM SDK `example` 类微信全功能示例项目 — 架构与能力映射设计方案

> **当前阶段**：阶段一（能力盘点与插件调研）+ 阶段二（架构与映射设计）已完成。
> **状态**：待审核确认。确认后立即执行阶段三（删除旧 `example/` 并分模块编码实现）。

---

## 一、OpenIM SDK 能力完整盘点

基于 `/Users/admin/IdeaProjects/openim_sdk/lib/` 当前源码（v3.0.0 重构版），SDK 通过 `OpenIM.iMManager` 暴露 **12 个核心 Manager** 与 **14 个 Listener**。

### 1.1 Manager 能力清单

| 模块 | Manager 类 | 核心公开 API | 对应示例页面 / 入口 |
| --- | --- | --- | --- |
| **SDK 与鉴权** | `IMManager` | `initSDK`、`loadLoginConfig`、`checkToken`、`login`、`loginByEmail`、`loginByAccount`、`loginByPhone`、`logout`、`unInitSDK`、`triggerWakeupSync`、`networkStatusChanged`、`setAppBackgroundStatus`、`uploadFile`、`getValue`/`setValue`/`removeValue`、`getSpaceInfo` | `SplashPage`、`OnboardingPage`、`LoginPage`、`ProfilePage`、`SettingsPage` |
| **会话管理** | `ConversationManager` | `getAllConversationList`、`getConversationListSplit`、`getOneConversation`、`getMultipleConversation`、`searchConversations`、`simpleSort`、`setConversation`、`pinConversation`、`hideConversation`、`hideAllConversations`、`setConversationDraft`、`getTotalUnreadMsgCount`、`markConversationMessageAsRead`、`markAllConversationMessageAsRead`、`markMessagesAsReadByMsgID`、`deleteConversationAndDeleteAllMsg`、`clearConversationAndDeleteAllMsg`、`changeInputStates`、`getInputStates` | `ConversationPage`、`ChatPage`、`PrivateChatDetailPage`、`GroupChatDetailPage` |
| **消息管理** | `MessageManager` | 全类型消息创建（文本、`@` 文本、图片、语音、视频、文件、合并转发、单条转发、名片、位置、引用回复、自定义表情、自定义消息、高级文本/引用、红包消息、通话信令）、`sendMessage`、`sendMessageNotOss`、`getAdvancedHistoryMessageList`、`getAdvancedHistoryMessageListReverse`、`findMessageList`、`searchLocalMessages`、`revokeMessage`、`deleteMessageFromLocalStorage`、`deleteMessageFromLocalAndSvr`、`deleteAllMsgFromLocal`、`deleteAllMsgFromLocalAndSvr`、`setMessageLocalEx`、`insertSingleMessageToLocalStorage`、`insertGroupMessageToLocalStorage`、`recoverSendingMessages` | `ChatPage`、全类型消息气泡组件、`ChatSearchPage`、`MessageForwardPage`、`MergeMessageDetailPage` |
| **好友与黑名单** | `FriendshipManager` | `getFriendList`、`getFriendListPage`、`getFriendsInfo`、`searchFriends`、`checkFriend`、`addFriend`、`deleteFriend`、`updateFriends`（设置备注/星标/扩展）、`addBlacklist`、`removeBlacklist`、`getBlacklist`、`getFriendApplicationListAsRecipient`、`getFriendApplicationListAsApplicant`、`acceptFriendApplication`、`refuseFriendApplication`、`getFriendApplicationUnhandledCount` | `ContactPage`、`AddContactPage`、`NewFriendsPage`、`ContactProfilePage`、`BlacklistPage` |
| **群组管理** | `GroupManager` | `createGroup`、`joinGroup`、`quitGroup`、`dismissGroup`、`getJoinedGroupList`、`getJoinedGroupListPage`、`getGroupsInfo`、`isJoinedGroup`、`searchGroups`、`setGroupInfo`、`inviteUserToGroup`、`kickGroupMember`、`getGroupMemberList`、`getGroupMemberListByJoinTime`、`getGroupMembersInfo`、`getGroupOwnerAndAdmin`、`searchGroupMembers`、`setGroupMemberInfo`、`transferGroupOwner`、`changeGroupMute`、`changeGroupMemberMute`、`getGroupApplicationListAsRecipient`、`getGroupApplicationListAsApplicant`、`acceptGroupApplication`、`refuseGroupApplication`、`getGroupApplicationUnhandledCount`、`getUsersInGroup` | `CreateGroupPage`、`JoinGroupPage`、`MyGroupsPage`、`GroupNotificationsPage`、`GroupChatDetailPage`、`GroupMembersPage` |
| **用户与账号安全** | `UserManager` | `register`、`sendVerificationCode`、`getSelfUserInfo`、`setSelfInfo`、`getUsersInfo`、`getUsersInfoWithCache`、`getUsersInfoFromSrv`、`getUserFullInfo`、`searchUserFullInfo`、`searchFriendInfo`、`updateChatUserInfo`、`subscribeUsersStatus`、`unsubscribeUsersStatus`、`getSubscribeUsersStatus`、`getUserStatus`、`getUserClientConfig`、`changePassword`、`resetPassword`、`deleteAccount`、`setPaymentPassword`、`changePaymentPassword`、`verifyPaymentPassword`、`checkPaymentPasswordSet`、`resetPaymentPassword`、`getRtcToken` | `RegisterPage`、`ProfilePage`、`EditProfilePage`、`ContactProfilePage`、`AccountSecurityPage`、`PaymentPasswordPage` |
| **朋友圈** | `MomentsManager` | `createMoment`（含 `MomentCreateReq`：图文/视频/可见范围 `VisibleType` / 指定群组）、`deleteMoment`、`getMomentList`、`fetchMomentListFromServer`、`likeMoment`、`unlikeMoment`、`commentMoment`（评论/回复）、`deleteComment`、`syncFromServer` | `MomentsPage`、`MomentPublishPage`、`MomentDetailPage`、`MomentNotificationsPage` |
| **收藏中心** | `FavoriteManager` | `getFavoriteList`、`fetchFavoriteListFromServer`、`addFavorite`、`removeFavorite`、`removeFavoriteItem`、`isFavorited`、`isMessageFavorited`、`isMomentFavorited`、`addMessage`/`removeMessage`、`addMoment`/`removeMoment`、`addMomentComment`/`removeMomentComment`、`addNote`/`updateNote`、`addLink`、`updateFavorite`、`syncFromServer` | `FavoritesPage`、`FavoriteDetailPage`、`NoteEditorPage`、聊天与朋友圈收藏操作 |
| **红包与积分** | `RedPacketManager` | `cachedBalance`、`getPointsBalance`、`getPointsTransactions`、`getIncomeTransactions`、`getExpenseTransactions`、`sendRedPacket`、`grabRedPacket`、`getRedPacketDetail`、`preloadGrabbedStatus`、`isGrabbed`、`markGrabbed` | `PointsPage`、`SendRedPacketPage`、`RedPacketDetailPage`、聊天红包气泡 |
| **音视频通话信令** | `CallManager` | `currentSession`、`isBusy`、`callState`、`invite`、`accept`、`reject`、`cancel`、`hangup`、`handleSignalingMessage` | `CallOverlayPage`、聊天栏通话入口、通话信令气泡 |
| **举报与申诉** | `ReportAppealManager` | `reportUser`、`reportGroup`、`reportMessage`、`getAppealCaptcha`、`submitAppeal`、`uploadAppealEvidence` | `ReportPage`（资料页/群详情/消息长按入口）、`AppealPage`（登录受限或设置页入口） |
| **应用版本检查** | `ApplicationManager` | `getLatestVersion` | `SettingsPage`（联合 `xue_hua_navite_auto_update` 实现桌面端一键检测与更新） |

### 1.2 全类型消息清单（`MessageType`）

| 分类 | `MessageType` 枚举值 | 独立气泡组件 |
| --- | --- | --- |
| **基础文本与富文本** | `text(101)`、`atText(106)`、`advancedText(117)`、`markdownText(118)` | `TextMessageBubble`（集成 `ChatSelectableText`） |
| **引用回复** | `quote(114)` | `QuoteMessageBubble`（原消息预览 + 回复文本） |
| **图片** | `picture(102)` | `ImageMessageBubble`（`CachedNetworkImage` + `memCacheWidth` 降采样 + 全屏预览） |
| **语音** | `voice(103)` | `VoiceMessageBubble`（`AudioPlayer` + 播放动画 + 音量控制） |
| **视频** | `video(104)` | `VideoMessageBubble`（封面缩略图 + `VideoPlayerController` 播放页 + 音量控制） |
| **文件** | `file(105)` | `FileMessageBubble`（文件图标/大小 + `XueHuaNaviteBackgroundDownloader` 进度 + `XueHuaFileOperations.openFile`） |
| **合并转发** | `merger(107)` | `MergeMessageBubble`（标题与摘要，点击进 `MergeMessageDetailPage`） |
| **名片** | `card(108)` | `CardMessageBubble`（头像/昵称，点击进 `ContactProfilePage`） |
| **位置** | `location(109)` | `LocationMessageBubble`（位置标题、经纬度描述卡片） |
| **表情 / SVG 动效** | `customFace(115)` | `FaceMessageBubble`（支持 `AnimatedSvgPicture` 矢量动效表情） |
| **红包与领取通知** | `redPacket(125)`、`redPacketGrabNotify(126)` | `RedPacketMessageBubble`（微信风格红包卡片 + 领取状态）与 `SystemNoticeBubble` |
| **通话与会议** | `callSignal(124)`、`conference(127)`、`meetingReminder(128)`、`meetingScheduleNotify(129)` | `CallSignalBubble`、`MeetingCardBubble` |
| **自定义消息** | `custom(110)`、`customMsgNotTriggerConversation(119)`、`customMsgOnlineOnly(120)` | `CustomMessageBubble` |
| **系统通知与撤回** | `revokeMessageNotification(2101)`、`oaNotification(1400)`、好友/群组/会话通知（1200–1703、2001–2200） | `SystemNoticeBubble`（居中灰色提示条，支持撤回重新编辑提示） |

### 1.3 全局 Listener 盘点（全部收口至唯一 `ImEventBus`）

SDK 的 12 个业务/连接 Listener（`OnConnectListener`、`OnConversationListener`、`OnAdvancedMsgListener`、`OnMsgSendProgressListener`、`OnFriendshipListener`、`OnGroupListener`、`OnUserListener`、`OnMomentsListener`、`OnFavoriteListener`、`OnRedPacketListener`、`OnCallListener`、`OnCustomBusinessListener`、`OnUploadFileListener`）全部在 `ImEventBus` 初始化时一次性注册，转换为强类型事件对象并通过 `rxdart`（`PublishSubject` / `BehaviorSubject`）对外广播。

---

## 二、26 个强制自研插件真实 API 盘点与核验

已逐一查阅本地 `.pub-cache` 对应版本 `SKILL.md` 及 Skill 规范（当前环境 Dart `3.14.0`），确保**零 API 臆造**：

| # | 插件与版本 | 核心入口类 / 关键真实 API | 关键约束与注意事项 |
| --- | --- | --- | --- |
| 1 | `xue_hua_adaptive_sliding_layout: ^3.6.3` | `AdaptiveRouter`、`AdaptiveShellRoute`、`AdaptiveBranch`、`AdaptiveRoute`、`AdaptivePaneScope.maybeOf(context)`、`SlidingPaneViewport` | 仅顶层允许一个 `AdaptiveShellRoute`；宽屏 `>=840` 自动双栏；栏内弹窗/菜单需 `useRootNavigator: AdaptivePaneScope.maybeOf(context) != null` |
| 2 | `signal_wire: ^1.0.0` | `Wire.put` / `putAsync` / `lazyPut` / `find` / `delete`、`WireService`、`WireController`、`WireReadyMixin`、`WireView<T>`、`WireStateMixin<W, T>`、`createSignal`/`createComputed`/`createEffect` | 统一负责 DI 与响应式状态，严格不混用其他状态管理库 |
| 3 | `flutter_toast_pro: ^4.1.2` | `ToastScope`（挂载在 `MaterialApp.builder` 内）、`FlutterToastPro.show/info/success/warning/error/loading/hideLoading/progress/hideProgress/dismissAll` | 公开门面为 `FlutterToastPro`；每次 `loading` 必须配对 `hideLoading` |
| 4 | `chat_context_menu: ^4.2.0` | `ChatContextMenuWrapper(widgetBuilder: (ctx, showMenu, hideMenu), menuBuilder: (ctx, hideMenu))`、`ChatSelectableText`、`ChatContextMenuVerticalShape`、`ChatContextMenuHorizontalShape` | 需自行在锚点绑定长按/右键/点击触发 `showMenu()`；双栏下 `ChatSelectableText` 传 `useRootOverlay: true` |
| 5 | `contact_list_view: ^2.1.0` | `ContactListView<T>(contactsList:, itemExtent:, startItemExtent:, endItemExtent:, startChildren:, endChildren:, tag:, itemBuilder:)` | 6 个必填参数缺一不可；`startChildren` 直接传普通 Widget，勿套 `SliverToBoxAdapter` |
| 6 | `xue_hua_animated_svg: ^1.3.0` | `AnimatedSvgPicture.string/asset/network/compiled`、`AnimatedSvgController`、`SvgParser.compile` | 纯 Dart 矢量动画引擎，用于启动页品牌动效、聊天动态表情包与空态插画 |
| 7 | `xue_hua_navite_video_player: ^2.8.0` | `VideoPlayerController`、`VideoSource`、`VideoPlayer`、`XueHuaNaviteVideoPlayer.configureCache/precache/takeSnapshot` | 用于聊天视频消息全屏播放、朋友圈视频播放与封面提取 |
| 8 | `xue_hua_audio: ^3.0.0` | `AudioPlayer`（`setSource(AudioSource.file/url)`、`play`/`pause`/`stop`/`seek`、`onPositionChanged`/`onPlayerComplete`）、`AudioRecorder`（`hasPermission`、`start(RecordConfig)`、`onAmplitudeChanged`、`stop`/`cancel`） | 无全局 engine，需妥善 `dispose()` |
| 9 | `xue_hua_navite_volume_controller: ^1.0.0` | `XueHuaNaviteVolumeController.instance`（`initialize`、`getVolumeState`、`setVolume`、`toggleMute`、`onVolumeChanged`、`stateNotifier`、`getOutputDevices`） | 接入语音/视频播放器音量调节与静音切换 |
| 10 | `xue_hua_media_compression: ^2.4.0` | `XueHuaMediaCompression.image.queryCapabilities/compress`、`XueHuaMediaCompression.video.queryCapabilities/compress(inputPath, outputPath)`、`CompressionSession` | 先查 `queryCapabilities()`，监听 `session.progress` 后 `await session.result` 并 `dispose()` |
| 11 | `xue_hua_media_info: ^2.2.0` | `MediaInfo.read/readImage/readAv/probe(MediaSource.file/bytes)`、`ImageMetadata`、`VideoMetadata`、`AudioMetadata` | 纯静态方法，发送图片/视频/语音与发朋友圈前自动读取宽高、时长与大小 |
| 12 | `xue_hua_navite_cache_manager: ^1.3.0` | `XueHuaNaviteCacheManager.instance.configure/getStats/clearAll/removeByTag/downloadFile`、`CachedNetworkImage`、`CachedNetworkImageProvider` | 列表头像与缩略图必须传 `memCacheWidth`/`memCacheHeight` 防掉帧；设置页展示缓存统计与一键清理 |
| 13 | `xue_hua_file_operations: ^1.6.0` | `XueHuaFileOperations.instance.pickFile/pickFiles/capturePhoto/captureVideo/retrieveLostCapture/openFile/saveFile/saveToGallery` | 取消返回 `null`；异常捕获 `FileOperationsException` |
| 14 | `xue_hua_navite_background_downloader: ^1.0.9` | `XueHuaNaviteBackgroundDownloader.instance.configure/enqueue/pause/resume/cancel/getAllTasks/watchTask/taskUpdates` | 文件消息下载、暂停续传、进度条展示与保存到本地 |
| 15 | `xue_hua_navite_clipboard: ^1.1.0` | `XueHuaNaviteClipboard.instance.writeText/writeSensitiveText/writeImage/readText/getMetadata` | 消息长按复制文本、复制账号/群 ID、隐私信息使用 `writeSensitiveText` |
| 16 | `xue_hua_barcode_scanner: ^1.3.0` | `BarcodeScannerPage`、`ScannerView`、`ScannerController` | 会话页 `+` 菜单「扫一扫」识别用户/群二维码与链接 |
| 17 | `xue_hua_qr_code: ^2.0.3` | `XueHuaQrCode(value:, size:, errorBuilder:)`、`toPngBytes` | 「我的名片二维码」与「群二维码」展示及导出分享 |
| 18 | `xue_hua_navite_share: ^1.0.7` | `XueHuaNaviteShare.instance.shareText/shareUri/shareFiles/shareMemoryFiles`、`ShareAnchorRect` | 聊天消息外部分享、名片/群二维码图片分享，macOS/iPad 传 `ShareAnchorRect` |
| 19 | `xue_hua_navite_accept_sharing: ^1.0.9` | `XueHuaNaviteAcceptSharing.instance.getInitialSharing/clearInitialSharing/onSharingReceived/cleanupTempFiles` | 接收外部 App 分享的文本/图片/视频/文件，弹出目标会话选择器发送 |
| 20 | `xue_hua_device_info: ^2.1.0` | `XueHuaDeviceInfo.getDeviceInfo/getBatteryInfo/getNetworkInfo/getStorageInfo/getDisplayInfo` | 启动/注册时获取 `deviceID`，设置页「设备信息」完整展示五大维度信息 |
| 21 | `xue_hua_screen_protection: ^1.1.0` | `XueHuaScreenProtection.instance.enableSecureScreen/disableSecureScreen/configureAppSwitcherProtection/onScreenCaptured/onScreenRecordingChanged`、`ScreenProtectionScope`、`ScreenProtectionWatermark` | 设置页隐私保护开关、后台模糊遮罩与截屏检测提示 |
| 22 | `xue_hua_app_badge: ^2.1.9` | `XueHuaAppBadge.instance.isSupported/isPermissionGranted/requestPermission/set/remove` | 订阅 `ImEventBus` 总未读数变化，自动同步桌面/移动端应用角标 |
| 23 | `xue_hua_navite_window_manager: ^1.1.0` | `XueHuaNaviteWindowManager.configure(WindowConfig)`、`WindowCaption`、`DragArea`、`WindowListener`、`setTrafficLightsOffset` | 桌面端零闪烁启动、最小尺寸约束、自定义无边框标题栏与关闭最小化到托盘 |
| 24 | `xue_hua_navite_drag_drop: ^1.0.9` | `NativeDropRegion(onDragEnter/onDragExit/onPerformDrop)`、`NativeDraggable`、`DropItem.openRead()` | 桌面端直接拖拽文件/图片/视频到 `ChatPage` 发送，大文件流式读取 |
| 25 | `xue_hua_navite_system_tray: ^1.0.9` | `XueHuaNaviteSystemTray.instance.initSystemTray/updateMenuItem/hideMainWindow/showMainWindow/showNotification/destroy`、`TrayMenuItem` | 桌面端托盘图标、未读数提示、右键菜单（显示主窗口/静音/退出）与新消息通知 |
| 26 | `xue_hua_navite_auto_update: ^1.0.1` | `XueHuaNaviteAutoUpdate.instance.checkEnvironment/verifyPackageChecksum/installAndRelaunch`、`UpdateProgressStrings.zhCN` | 桌面端设置页「检查更新」，配合 `ApplicationManager.getLatestVersion` 与后台下载器完成一键安装重启 |

---

## 三、目录结构设计（单文件单公开类型 + Widget 封装规范）

严格遵守：**每个 `.dart` 文件至多 1 个公开类型**；**禁止返回 `Widget` 的辅助方法**；跨页面复用 UI 统一放入上级 `widgets/` 目录。

```text
example/
├── pubspec.yaml
├── assets/
│   ├── icons/                      # 托盘图标、应用图标
│   └── svg/                        # 品牌动效、表情动效 SVG 资源
└── lib/
    ├── main.dart                   # 入口（桌面窗口零闪烁配置 + 全局服务启动）
    ├── app/
    │   ├── app.dart                # 根组件（MaterialApp.router + ToastScope + 主题/多语言）
    │   ├── router/
    │   │   ├── app_routes.dart     # 路由路径常量定义
    │   │   └── app_router.dart     # AdaptiveRouter + AdaptiveShellRoute(4 Branches)
    │   ├── theme/
    │   │   ├── app_theme.dart      # 浅色/深色主题（微信风格配色）
    │   │   └── app_colors.dart     # 语义色板常量
    │   └── l10n/
    │       ├── app_locale.dart     # 语言枚举与切换配置
    │       └── app_strings.dart    # 中/英文双语词条映射
    ├── core/
    │   ├── config/
    │   │   └── sdk_server_config.dart      # apiAddr / wsAddr / authAddr 持久化配置
    │   ├── events/
    │   │   ├── im_event_bus.dart           # 唯一全局 IM 事件总线（rxdart Subject + 全部 SDK Listener）
    │   │   ├── im_connection_event.dart    # 连接状态事件模型
    │   │   ├── im_conversation_event.dart  # 会话与未读数事件模型
    │   │   ├── im_message_event.dart       # 消息收发/撤回/已读/进度事件模型
    │   │   ├── im_relation_event.dart      # 好友/黑名单/申请事件模型
    │   │   ├── im_group_event.dart         # 群组与群申请事件模型
    │   │   ├── im_social_event.dart        # 朋友圈/收藏/红包积分/通话事件模型
    │   │   └── im_user_event.dart          # 用户资料与在线状态事件模型
    │   ├── services/
    │   │   ├── app_bootstrap_service.dart  # 全局初始化编排（WireService）
    │   │   ├── auth_session_service.dart   # 登录态、当前用户与退出清理
    │   │   ├── settings_service.dart       # 主题、语言、屏保开关持久化
    │   │   ├── desktop_service.dart        # 窗口管理、系统托盘、自动更新编排
    │   │   ├── sharing_receive_service.dart# 接收外部软件分享事件编排
    │   │   ├── badge_service.dart          # 订阅 ImEventBus 自动同步应用角标
    │   │   ├── media_service.dart          # 媒体选择、信息读取与压缩管线
    │   │   └── download_service.dart       # 后台下载任务管理服务
    │   └── utils/
    │       ├── qr_payload_codec.dart       # 二维码协议编解码（openim://user|group/...）
    │       ├── date_time_formatter.dart    # 微信风格时间格式化
    │       └── pinyin_tag_helper.dart      # 联系人首字母 A-Z / # 分组工具
    ├── shared/
    │   └── widgets/                        # 跨模块共享组件（每文件单公开类）
    │       ├── cached_avatar.dart          # 基于 CachedNetworkImage 的圆角头像
    │       ├── unread_badge.dart           # 微信风格未读红点
    │       ├── empty_state_view.dart       # 含 AnimatedSvgPicture 的空态占位
    │       ├── desktop_title_bar.dart      # 桌面端自定义标题栏（WindowCaption/DragArea）
    │       ├── qr_card_dialog.dart         # 通用二维码名片弹窗（XueHuaQrCode + 分享）
    │       └── share_target_picker_sheet.dart # 外部分享/消息转发会话选择器
    └── features/
        ├── splash/
        │   ├── splash_controller.dart
        │   └── splash_page.dart
        ├── onboarding/
        │   └── onboarding_page.dart
        ├── auth/
        │   ├── login_controller.dart
        │   ├── login_page.dart             # 邮箱+密码 / 账号+密码 二选一 + 服务器设置弹窗
        │   ├── register_controller.dart
        │   └── register_page.dart          # 纯邮箱注册（验证码 + 昵称 + 密码 + deviceID）
        ├── main_shell/
        │   ├── main_shell_controller.dart
        │   └── main_shell_scaffold.dart    # 移动端 BottomNavigationBar / 桌面端左侧微信风 NavigationRail
        ├── conversation/
        │   ├── conversation_controller.dart
        │   ├── conversation_page.dart      # Tab 1：会话列表 + 右上角 `+` 菜单 + 长按/右键竖向菜单
        │   └── widgets/
        │       ├── conversation_tile.dart
        │       ├── conversation_add_menu.dart
        │       └── conversation_context_menu.dart
        ├── contact/
        │   ├── contact_controller.dart
        │   ├── contact_page.dart           # Tab 2：ContactListView + 顶部三大固定入口
        │   ├── add_contact_controller.dart
        │   ├── add_contact_page.dart       # 搜索用户/扫码加好友
        │   ├── new_friends_controller.dart
        │   ├── new_friends_page.dart       # 好友申请收件箱/发件箱
        │   ├── contact_profile_controller.dart
        │   ├── contact_profile_page.dart   # 资料/发消息/朋友圈/备注/黑名单/删除/举报
        │   ├── blacklist_page.dart         # 黑名单管理
        │   └── widgets/
        │       └── contact_entry_tile.dart
        ├── group/
        │   ├── create_group_controller.dart
        │   ├── create_group_page.dart      # 选择好友建群
        │   ├── join_group_controller.dart
        │   ├── join_group_page.dart        # 搜索/输入群 ID 申请入群
        │   ├── my_groups_controller.dart
        │   ├── my_groups_page.dart         # 已加入群聊列表
        │   ├── group_notifications_controller.dart
        │   ├── group_notifications_page.dart # 入群申请审批
        │   ├── group_chat_detail_controller.dart
        │   ├── group_chat_detail_page.dart # 群成员网格/群名/公告/群二维码/禁言/邀请/踢人/退群/解散
        │   └── group_members_page.dart     # 全部群成员管理（设管理员/禁言/转让群主/踢人）
        ├── chat/
        │   ├── chat_controller.dart        # 消息流加载、发送、撤回、多选、语音录制、拖拽发送
        │   ├── chat_page.dart              # 聊天主界面（NativeDropRegion + 气泡列表 + 输入栏）
        │   ├── private_chat_detail_page.dart # 私聊设置（查记录/置顶/免打扰/阅后即焚/清空）
        │   ├── chat_search_page.dart       # 本地聊天记录检索
        │   ├── merge_message_detail_page.dart # 合并转发消息详情
        │   ├── media_preview_page.dart     # 图片缩放查看 / 视频播放（含音量控制与保存）
        │   └── widgets/
        │       ├── chat_input_bar.dart     # 语音/文本/表情/扩展面板
        │       ├── chat_voice_recorder_bar.dart # 按住说话（AudioRecorder + 音量波形）
        │       ├── chat_emoji_panel.dart   # 内置表情 + AnimatedSvgPicture 动效贴纸
        │       ├── chat_more_panel.dart    # 相册/拍照/文件/位置/名片/红包/通话扩展面板
        │       ├── message_bubble_shell.dart # 统一气泡外框 + ChatContextMenuWrapper 操作面板
        │       ├── text_message_bubble.dart
        │       ├── quote_message_bubble.dart
        │       ├── image_message_bubble.dart
        │       ├── voice_message_bubble.dart
        │       ├── video_message_bubble.dart
        │       ├── file_message_bubble.dart
        │       ├── merge_message_bubble.dart
        │       ├── card_message_bubble.dart
        │       ├── location_message_bubble.dart
        │       ├── face_message_bubble.dart
        │       ├── red_packet_message_bubble.dart
        │       ├── call_signal_bubble.dart
        │       ├── custom_message_bubble.dart
        │       └── system_notice_bubble.dart
        ├── moments/
        │   ├── moments_controller.dart
        │   ├── moments_page.dart           # Tab 3：顶部封面 + 动态流 + 点赞评论浮层
        │   ├── moment_publish_controller.dart
        │   ├── moment_publish_page.dart    # 图文/视频发布（压缩 + 媒体信息 + 可见范围）
        │   ├── moment_detail_page.dart     # 单条动态详情与全部评论回复
        │   └── widgets/
        │       ├── moment_card.dart
        │       └── moment_media_grid.dart
        ├── favorite/
        │   ├── favorites_controller.dart
        │   ├── favorites_page.dart         # 收藏列表（分类筛选：全部/消息/朋友圈/笔记/链接）
        │   ├── favorite_detail_page.dart   # 收藏详情与转发/外部分享
        │   └── note_editor_page.dart       # 新建/编辑收藏笔记与链接
        ├── points/
        │   ├── points_controller.dart
        │   ├── points_page.dart            # 积分余额、全部/收入/支出明细、支付密码入口
        │   ├── send_red_packet_page.dart   # 发送单聊/群聊红包
        │   └── red_packet_detail_page.dart # 拆红包结果与领取明细
        ├── call/
        │   ├── call_controller.dart
        │   └── call_overlay_page.dart      # 语音/视频通话呼出与来电接听页
        ├── scanner/
        │   └── scanner_page.dart           # 基于 BarcodeScannerPage 封装的扫码与路由分发页
        ├── report/
        │   └── report_page.dart            # 举报用户/群组/消息与账号申诉页
        └── profile/
            ├── profile_controller.dart
            ├── profile_page.dart           # Tab 4：个人卡片/二维码/收藏/积分/设置/退出登录
            ├── edit_profile_page.dart      # 修改头像/昵称/性别/生日
            ├── settings_controller.dart
            ├── settings_page.dart          # 主题/语言/屏保/缓存管理/检查更新/设备信息/安全
            ├── device_info_page.dart       # XueHuaDeviceInfo 五大维度完整展示
            └── account_security_page.dart  # 修改密码/支付密码/注销账号
```

---

## 四、页面路由表与点击流转（基于 `xue_hua_adaptive_sliding_layout`）

采用单 `AdaptiveRouter` 声明式路由表：
- **壳外全屏路由**（登录前/全屏模态）：`/splash`、`/onboarding`、`/login`、`/register`、`/scanner`、`/call`、`/media-preview`。
- **壳内 `AdaptiveShellRoute`（4 个 `AdaptiveBranch`）**：移动端底部 4 Tab + 单栏推送；桌面端（宽度 `>= 840px`）左侧微信风格窄导航栏 + 中间列表栏 + 右侧详情/聊天栏自动双栏展示。

| 路由路径 | 页面 | 所属 Branch / 层次 | 关键流转入口 |
| --- | --- | --- | --- |
| `/splash` | `SplashPage` | 壳外根路由 | 冷启动初始化 → 未登录 `/onboarding`，已登录 `/conversations` |
| `/onboarding` | `OnboardingPage` | 壳外根路由 | 「登录」→ `/login`；「注册」→ `/register` |
| `/login` | `LoginPage` | 壳外根路由 | 邮箱+密码 / 账号+密码 登录成功 → `/conversations` |
| `/register` | `RegisterPage` | 壳外根路由 | 邮箱验证码注册成功 → 自动登录进 `/conversations` 或返回 `/login` |
| `/conversations` | `ConversationPage` | Branch 0（会话） | 右上角 `+` 菜单（加好友/建群/进群/扫一扫）；点击会话 → `/conversations/chat/:conversationId` |
| `/conversations/chat/:conversationId` | `ChatPage` | Branch 0 子路由（桌面右栏） | 右上角 `...` → 私聊 `private-detail` / 群聊 `group-detail`；点击消息附件 → 预览/详情 |
| `/conversations/chat/:conversationId/private-detail` | `PrivateChatDetailPage` | Branch 0 子路由 | 查找记录、置顶、免打扰、清空记录、举报 |
| `/conversations/chat/:conversationId/group-detail` | `GroupChatDetailPage` | Branch 0 子路由 | 群成员管理、群二维码、公告、禁言、退群/解散 |
| `/conversations/chat/:conversationId/search` | `ChatSearchPage` | Branch 0 子路由 | 关键词检索本地消息并定位 |
| `/conversations/add-contact` | `AddContactPage` | Branch 0/1 子路由 | 搜索用户 → `ContactProfilePage` |
| `/conversations/create-group` | `CreateGroupPage` | Branch 0 子路由 | 选好友创建群 → 直达新群 `ChatPage` |
| `/conversations/join-group` | `JoinGroupPage` | Branch 0 子路由 | 搜索群 ID 申请加入 |
| `/contacts` | `ContactPage` | Branch 1（联系人） | 顶部固定 3 入口 + 字母索引好友列表 |
| `/contacts/new-friends` | `NewFriendsPage` | Branch 1 子路由 | 同意/拒绝好友申请 |
| `/contacts/group-notifications` | `GroupNotificationsPage` | Branch 1 子路由 | 同意/拒绝入群申请 |
| `/contacts/my-groups` | `MyGroupsPage` | Branch 1 子路由 | 点击群聊 → 进入对应 `ChatPage` |
| `/contacts/profile/:userId` | `ContactProfilePage` | Branch 1 子路由 | 发消息 / 看朋友圈 / 设备注 / 黑名单 / 删除 / 举报 |
| `/moments` | `MomentsPage` | Branch 2（朋友圈） | 发布按钮 → `/moments/publish`；点击动态 → `/moments/detail/:momentId` |
| `/moments/publish` | `MomentPublishPage` | Branch 2 子路由 | 图文/视频压缩上传 + 可见范围发布 |
| `/moments/detail/:momentId` | `MomentDetailPage` | Branch 2 子路由 | 点赞、评论、二级回复、删除、收藏 |
| `/profile` | `ProfilePage` | Branch 3（我的） | 个人资料、二维码名片、收藏、积分、设置、退出登录 |
| `/profile/edit` | `EditProfilePage` | Branch 3 子路由 | 修改头像、昵称、性别、生日 |
| `/profile/favorites` | `FavoritesPage` | Branch 3 子路由 | 收藏分类浏览、新建笔记/链接、详情转发 |
| `/profile/points` | `PointsPage` | Branch 3 子路由 | 积分余额、收支明细、支付密码设置 |
| `/profile/settings` | `SettingsPage` | Branch 3 子路由 | 主题、语言、屏保、缓存、更新、设备信息、安全 |
| `/profile/settings/device-info` | `DeviceInfoPage` | Branch 3 子路由 | 五大维度设备硬件与系统信息 |
| `/profile/settings/security` | `AccountSecurityPage` | Branch 3 子路由 | 改密、支付密码、黑名单、注销账号 |
| `/scanner` | `ScannerPage` | 壳外全屏路由 | 扫码识别好友/群/外链并回调路由 |

---

## 五、SDK 功能与 26 个插件绑定映射总表

| 业务场景 | OpenIM SDK 能力 | 绑定的强制自研插件 |
| --- | --- | --- |
| 应用启动与跨端容器 | `IMManager.initSDK`、`loadLoginConfig` | `xue_hua_adaptive_sliding_layout`、`signal_wire`、`xue_hua_navite_window_manager`、`xue_hua_navite_system_tray`、`xue_hua_device_info`、`xue_hua_navite_cache_manager`、`xue_hua_animated_svg` |
| 全局提示与加载态 | 所有异步接口错误/成功反馈 | `flutter_toast_pro` |
| 会话列表与角标 | `ConversationManager.*`、`OnConversationListener` | `xue_hua_navite_cache_manager`、`xue_hua_app_badge`、`chat_context_menu`（`+` 菜单与会话长按/右键竖向菜单） |
| 联系人与群组 | `FriendshipManager.*`、`GroupManager.*` | `contact_list_view`、`xue_hua_barcode_scanner`、`xue_hua_qr_code`、`xue_hua_navite_clipboard` |
| 聊天图片与视频 | `MessageManager.createImage/VideoMessage*`、`uploadFile` | `xue_hua_file_operations`、`xue_hua_media_info`、`xue_hua_media_compression`、`xue_hua_navite_cache_manager`、`xue_hua_navite_video_player`、`xue_hua_navite_volume_controller` |
| 聊天语音录制与播放 | `MessageManager.createSoundMessage*` | `xue_hua_audio`、`xue_hua_media_info`、`xue_hua_navite_volume_controller` |
| 聊天文件收发与下载 | `MessageManager.createFileMessage*` | `xue_hua_file_operations`、`xue_hua_navite_background_downloader`、`xue_hua_navite_drag_drop` |
| 聊天表情与交互菜单 | `MessageManager.createFaceMessage/revoke/delete/forward`、`FavoriteManager.addMessage` | `xue_hua_animated_svg`、`chat_context_menu`（气泡操作 + `ChatSelectableText`）、`xue_hua_navite_clipboard`、`xue_hua_navite_share` |
| 外部内容分享至聊天 | `MessageManager.sendMessage` | `xue_hua_navite_accept_sharing` |
| 朋友圈发布与浏览 | `MomentsManager.*`、`FavoriteManager.addMoment` | `xue_hua_file_operations`、`xue_hua_media_compression`、`xue_hua_media_info`、`xue_hua_navite_cache_manager`、`xue_hua_navite_video_player`、`chat_context_menu` |
| 安全隐私与桌面更新 | `ApplicationManager.getLatestVersion`、`UserManager.*` | `xue_hua_screen_protection`、`xue_hua_navite_auto_update`、`xue_hua_navite_background_downloader`、`xue_hua_device_info`、`xue_hua_navite_cache_manager` |

---

## 六、核心工程规范执行细则

1. **状态管理与 DI（`signal_wire`）**：
   - 全局服务继承 `WireService`，在 `AppBootstrapService` 中通过 `Wire.put` / `Wire.putAsync` 注入；
   - 页面控制器继承 `WireController`（按需混入 `WireReadyMixin`），使用 `createSignal` / `createComputed` / `createEffect` 管理响应式状态并自动释放；
   - 页面使用 `WireView<T>` 或 `WireStateMixin<W, T>`，彻底移除原 `example` 中的 `get`。
2. **唯一全局事件中心（`ImEventBus` + `rxdart`）**：
   - `ImEventBus extends WireService` 持有各领域 `PublishSubject`（连接状态、总未读数使用 `BehaviorSubject` 保留最新值）；
   - 仅在 `ImEventBus` 中注册一次 SDK 的全部 Listener；各 Controller 订阅对应 `Stream` 并在 `onClose()` 中通过 `autoDispose` 取消订阅。
3. **代码风格与静态检查**：
   - 延续主仓库习惯：变量类型写全（`always_specify_types`）、日志使用 `package:logging`（`_logger`）、单文件单公开类型、零返回 `Widget` 的方法（全部拆分为私有/共享 `StatelessWidget` 或 `StatefulWidget`）。

---

## 七、阶段三编码排期（待确认后执行）

1. **Step 1**：完全删除旧 `example/` 目录，重新创建跨平台 Flutter 工程结构与 `pubspec.yaml`（写入全部 26 个强制插件与 `rxdart`、`logging`、`openim_sdk`），配置平台权限/entitlements。
2. **Step 2**：实现 `core/`（`ImEventBus`、8 个 `WireService`、配置与工具）及 `app/`（`AdaptiveRouter` 路由表、主题、双语、共享 `widgets/`）。
3. **Step 3**：实现启动与鉴权流转（`SplashPage`、`OnboardingPage`、`LoginPage`、`RegisterPage`）。
4. **Step 4**：实现主界面 `MainShellScaffold` 及 Tab 1（会话）、Tab 2（联系人 + 群组子页）、Tab 3（朋友圈）、Tab 4（我的 + 收藏 + 积分 + 设置 + 设备信息）。
5. **Step 5**：实现聊天核心页 `ChatPage`、全类型消息气泡矩阵、长按/右键 `chat_context_menu` 操作面板、语音录制、桌面拖拽发送、外部分享接收与扫码页。
6. **Step 6**：全量执行 `dart format` 与 `dart analyze`，核查“单文件单公开类型”“无返回 Widget 方法”“26 插件全接入”三条硬性指标。

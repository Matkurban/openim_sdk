import 'package:json_annotation/json_annotation.dart';

/// 消息内容类型枚举（对齐 `openim-sdk-core` 与 `xue_hua_sdk` 协议常量）。
///
/// Message content type enum aligned with `openim-sdk-core` and `xue_hua_sdk` protocol constants.
enum MessageType {
  /// 文本消息（101） / Plain text message (`101`).
  @JsonValue(101)
  text(101),

  /// 图片消息（102） / Picture message (`102`).
  @JsonValue(102)
  picture(102),

  /// 语音消息（103） / Voice audio message (`103`).
  @JsonValue(103)
  voice(103),

  /// 视频消息（104） / Video message (`104`).
  @JsonValue(104)
  video(104),

  /// 文件消息（105） / File attachment message (`105`).
  @JsonValue(105)
  file(105),

  /// `@` 提及文本消息（106） / `@`-mention text message (`106`).
  @JsonValue(106)
  atText(106),

  /// 合并转发消息（107） / Merged forward message (`107`).
  @JsonValue(107)
  merger(107),

  /// 名片消息（108） / Contact card message (`108`).
  @JsonValue(108)
  card(108),

  /// 地理位置消息（109） / Location message (`109`).
  @JsonValue(109)
  location(109),

  /// 自定义消息（110） / Custom message (`110`).
  @JsonValue(110)
  custom(110),

  /// 正在输入状态消息（113） / Typing indicator message (`113`).
  @JsonValue(113)
  typing(113),

  /// 引用回复消息（114） / Quoted reply message (`114`).
  @JsonValue(114)
  quote(114),

  /// 自定义表情消息（115） / Custom sticker/face message (`115`).
  @JsonValue(115)
  customFace(115),

  /// 富文本消息（117） / Advanced rich-text message (`117`).
  @JsonValue(117)
  advancedText(117),

  /// Markdown 文本消息（118） / Markdown text message (`118`).
  @JsonValue(118)
  markdownText(118),

  /// 不触发会话更新的自定义消息（119） / Custom message without conversation update (`119`).
  @JsonValue(119)
  customMsgNotTriggerConversation(119),

  /// 仅在线自定义消息（120） / Online-only custom message (`120`).
  @JsonValue(120)
  customMsgOnlineOnly(120),

  /// 音视频通话信令/记录消息（124） / Audio/video call signal/record message (`124`).
  @JsonValue(124)
  callSignal(124),

  /// 红包消息（125） / Red packet message (`125`).
  @JsonValue(125)
  redPacket(125),

  /// 红包领取通知消息（126） / Red packet grab notification message (`126`).
  @JsonValue(126)
  redPacketGrabNotify(126),

  /// 会议邀请卡片消息（127） / Conference invitation card message (`127`).
  @JsonValue(127)
  conference(127),

  /// 会议开始提醒消息（128） / Meeting reminder notification message (`128`).
  @JsonValue(128)
  meetingReminder(128),

  /// 会议日程变更通知消息（129） / Meeting schedule change notification (`129`).
  @JsonValue(129)
  meetingScheduleNotify(129),

  /// 系统通知起始边界值（1000） / System notification range start (`1000`).
  @JsonValue(1000)
  notificationBegin(1000),

  /// 好友通知起始边界值（1200） / Friend notification range start (`1200`).
  @JsonValue(1200)
  friendNotificationBegin(1200),

  /// 好友申请已通过通知（1201） / Friend application approved notification (`1201`).
  @JsonValue(1201)
  friendApplicationApprovedNotification(1201),

  /// 好友申请已拒绝通知（1202） / Friend application rejected notification (`1202`).
  @JsonValue(1202)
  friendApplicationRejectedNotification(1202),

  /// 收到好友申请通知（1203） / New friend application notification (`1203`).
  @JsonValue(1203)
  friendApplicationNotification(1203),

  /// 好友已添加通知（1204） / Friend added notification (`1204`).
  @JsonValue(1204)
  friendAddedNotification(1204),

  /// 好友已删除通知（1205） / Friend deleted notification (`1205`).
  @JsonValue(1205)
  friendDeletedNotification(1205),

  /// 好友备注修改通知（1206） / Friend remark updated notification (`1206`).
  @JsonValue(1206)
  friendRemarkSetNotification(1206),

  /// 加入黑名单通知（1207） / User added to blacklist notification (`1207`).
  @JsonValue(1207)
  blackAddedNotification(1207),

  /// 移出黑名单通知（1208） / User removed from blacklist notification (`1208`).
  @JsonValue(1208)
  blackDeletedNotification(1208),

  /// 好友资料更新通知（1209） / Friend profile updated notification (`1209`).
  @JsonValue(1209)
  friendInfoUpdatedNotification(1209),

  /// 批量好友资料更新通知（1210） / Batch friends info updated notification (`1210`).
  @JsonValue(1210)
  friendsInfoUpdateNotification(1210),

  /// 好友通知结束边界值（1299） / Friend notification range end (`1299`).
  @JsonValue(1299)
  friendNotificationEnd(1299),

  /// 会话属性变更通知（1300） / Conversation properties changed notification (`1300`).
  @JsonValue(1300)
  conversationChangeNotification(1300),

  /// 用户通知起始边界值（1301） / User notification range start (`1301`).
  @JsonValue(1301)
  userNotificationBegin(1301),

  /// 当前用户资料更新通知（1303） / Self user info updated notification (`1303`).
  @JsonValue(1303)
  userInfoUpdatedNotification(1303),

  /// 用户在线状态变更通知（1304） / User online status changed notification (`1304`).
  @JsonValue(1304)
  userStatusChangeNotification(1304),

  /// 用户指令新增通知（1305） / User command added notification (`1305`).
  @JsonValue(1305)
  userCommandAddNotification(1305),

  /// 用户指令删除通知（1306） / User command deleted notification (`1306`).
  @JsonValue(1306)
  userCommandDeleteNotification(1306),

  /// 用户指令更新通知（1307） / User command updated notification (`1307`).
  @JsonValue(1307)
  userCommandUpdateNotification(1307),

  /// 用户通知结束边界值（1399） / User notification range end (`1399`).
  @JsonValue(1399)
  userNotificationEnd(1399),

  /// OA 系统通知（1400） / OA system notification (`1400`).
  @JsonValue(1400)
  oaNotification(1400),

  /// 群组通知起始边界值（1500） / Group notification range start (`1500`).
  @JsonValue(1500)
  groupNotificationBegin(1500),

  /// 群组已创建通知（1501） / Group created notification (`1501`).
  @JsonValue(1501)
  groupCreatedNotification(1501),

  /// 群信息更新通知（1502） / Group info updated notification (`1502`).
  @JsonValue(1502)
  groupInfoSetNotification(1502),

  /// 入群申请通知（1503） / Join group application notification (`1503`).
  @JsonValue(1503)
  joinGroupApplicationNotification(1503),

  /// 群成员退群通知（1504） / Group member quit notification (`1504`).
  @JsonValue(1504)
  memberQuitNotification(1504),

  /// 入群申请已通过通知（1505） / Join group application accepted notification (`1505`).
  @JsonValue(1505)
  groupApplicationAcceptedNotification(1505),

  /// 入群申请已拒绝通知（1506） / Join group application rejected notification (`1506`).
  @JsonValue(1506)
  groupApplicationRejectedNotification(1506),

  /// 群主转让通知（1507） / Group owner transferred notification (`1507`).
  @JsonValue(1507)
  groupOwnerTransferredNotification(1507),

  /// 群成员被踢出通知（1508） / Group member kicked notification (`1508`).
  @JsonValue(1508)
  memberKickedNotification(1508),

  /// 群成员被邀请入群通知（1509） / Group member invited notification (`1509`).
  @JsonValue(1509)
  memberInvitedNotification(1509),

  /// 群成员主动入群通知（1510） / Group member entered notification (`1510`).
  @JsonValue(1510)
  memberEnterNotification(1510),

  /// 群组已解散通知（1511） / Group dismissed notification (`1511`).
  @JsonValue(1511)
  dismissGroupNotification(1511),

  /// 群成员被禁言通知（1512） / Group member muted notification (`1512`).
  @JsonValue(1512)
  groupMemberMutedNotification(1512),

  /// 群成员解除禁言通知（1513） / Group member unmuted notification (`1513`).
  @JsonValue(1513)
  groupMemberCancelMutedNotification(1513),

  /// 群全体禁言通知（1514） / Group all-muted notification (`1514`).
  @JsonValue(1514)
  groupMutedNotification(1514),

  /// 群取消全体禁言通知（1515） / Group all-unmuted notification (`1515`).
  @JsonValue(1515)
  groupCancelMutedNotification(1515),

  /// 群成员信息更新通知（1516） / Group member info updated notification (`1516`).
  @JsonValue(1516)
  groupMemberInfoSetNotification(1516),

  /// 群成员设为管理员通知（1517） / Group member promoted to admin notification (`1517`).
  @JsonValue(1517)
  groupMemberSetToAdminNotification(1517),

  /// 群成员取消管理员通知（1518） / Group member demoted to regular member notification (`1518`).
  @JsonValue(1518)
  groupMemberSetToOrdinaryUserNotification(1518),

  /// 群公告更新通知（1519） / Group announcement updated notification (`1519`).
  @JsonValue(1519)
  groupInfoSetAnnouncementNotification(1519),

  /// 群名称修改通知（1520） / Group name updated notification (`1520`).
  @JsonValue(1520)
  groupInfoSetNameNotification(1520),

  /// 群组通知结束边界值（1599） / Group notification range end (`1599`).
  @JsonValue(1599)
  groupNotificationEnd(1599),

  /// 阅后即焚状态变更通知（1701） / Private burn-after-read toggle notification (`1701`).
  @JsonValue(1701)
  conversationPrivateChatNotification(1701),

  /// 清空会话消息通知（1703） / Clear conversation messages notification (`1703`).
  @JsonValue(1703)
  clearConversationNotification(1703),

  /// 自定义业务通知（2001） / Custom business notification (`2001`).
  @JsonValue(2001)
  businessNotification(2001),

  /// 消息撤回通知（2101） / Message revoked notification (`2101`).
  @JsonValue(2101)
  revokeMessageNotification(2101),

  /// 消息删除通知（2102） / Messages deleted notification (`2102`).
  @JsonValue(2102)
  deleteMsgsNotification(2102),

  /// 消息已读回执通知（2200） / Read receipt notification (`2200`).
  @JsonValue(2200)
  hasReadReceipt(2200),

  /// 系统通知结束边界值（5000） / System notification range end (`5000`).
  @JsonValue(5000)
  notificationEnd(5000);

  /// 创建消息类型枚举值。
  ///
  /// Creates a [MessageType] with its protocol integer [value].
  ///
  /// - [value] 协议整数值 / Protocol integer value.
  const MessageType(this.value);

  /// 协议整数值 / Protocol integer value.
  final int value;

  static final Map<int, MessageType> _byValue = <int, MessageType>{
    for (final MessageType item in values) item.value: item,
  };

  /// 通过 O(1) 静态映射根据整数值解析 [MessageType]，未匹配时默认返回 [text]。
  ///
  /// Resolves [MessageType] from integer [value] in O(1) time, defaulting to [text].
  ///
  /// - [value] 协议整数值 / Protocol integer value.
  /// - Returns: 对应的 [MessageType] 枚举值 / Matching [MessageType] enum value.
  factory MessageType.fromValue(int value) {
    return _byValue[value] ?? text;
  }
}

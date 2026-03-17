import 'package:json_annotation/json_annotation.dart';

/// Message Types based on openim-sdk-core Go constants
enum MessageType {
  @JsonValue(101)
  text(101),
  @JsonValue(102)
  picture(102),
  @JsonValue(103)
  voice(103),
  @JsonValue(104)
  video(104),
  @JsonValue(105)
  file(105),
  @JsonValue(106)
  atText(106),
  @JsonValue(107)
  merger(107),
  @JsonValue(108)
  card(108),
  @JsonValue(109)
  location(109),
  @JsonValue(110)
  custom(110),
  @JsonValue(113)
  typing(113),
  @JsonValue(114)
  quote(114),
  @JsonValue(115)
  customFace(115),
  @JsonValue(117)
  advancedText(117),
  @JsonValue(118)
  markdownText(118),
  @JsonValue(119)
  customMsgNotTriggerConversation(119),
  @JsonValue(120)
  customMsgOnlineOnly(120),

  @JsonValue(1000)
  notificationBegin(1000),
  @JsonValue(1200)
  friendNotificationBegin(1200),
  @JsonValue(1201)
  friendApplicationApprovedNotification(1201),
  @JsonValue(1202)
  friendApplicationRejectedNotification(1202),
  @JsonValue(1203)
  friendApplicationNotification(1203),
  @JsonValue(1204)
  friendAddedNotification(1204),
  @JsonValue(1205)
  friendDeletedNotification(1205),
  @JsonValue(1206)
  friendRemarkSetNotification(1206),
  @JsonValue(1207)
  blackAddedNotification(1207),
  @JsonValue(1208)
  blackDeletedNotification(1208),
  @JsonValue(1209)
  friendInfoUpdatedNotification(1209),
  @JsonValue(1210)
  friendsInfoUpdateNotification(1210),
  @JsonValue(1299)
  friendNotificationEnd(1299),

  @JsonValue(1300)
  conversationChangeNotification(1300),

  @JsonValue(1301)
  userNotificationBegin(1301),
  @JsonValue(1303)
  userInfoUpdatedNotification(1303),
  @JsonValue(1304)
  userStatusChangeNotification(1304),
  @JsonValue(1305)
  userCommandAddNotification(1305),
  @JsonValue(1306)
  userCommandDeleteNotification(1306),
  @JsonValue(1307)
  userCommandUpdateNotification(1307),
  @JsonValue(1399)
  userNotificationEnd(1399),

  @JsonValue(1400)
  oaNotification(1400),

  @JsonValue(1500)
  groupNotificationBegin(1500),
  @JsonValue(1501)
  groupCreatedNotification(1501),
  @JsonValue(1502)
  groupInfoSetNotification(1502),
  @JsonValue(1503)
  joinGroupApplicationNotification(1503),
  @JsonValue(1504)
  memberQuitNotification(1504),
  @JsonValue(1505)
  groupApplicationAcceptedNotification(1505),
  @JsonValue(1506)
  groupApplicationRejectedNotification(1506),
  @JsonValue(1507)
  groupOwnerTransferredNotification(1507),
  @JsonValue(1508)
  memberKickedNotification(1508),
  @JsonValue(1509)
  memberInvitedNotification(1509),
  @JsonValue(1510)
  memberEnterNotification(1510),
  @JsonValue(1511)
  dismissGroupNotification(1511),
  @JsonValue(1512)
  groupMemberMutedNotification(1512),
  @JsonValue(1513)
  groupMemberCancelMutedNotification(1513),
  @JsonValue(1514)
  groupMutedNotification(1514),
  @JsonValue(1515)
  groupCancelMutedNotification(1515),
  @JsonValue(1516)
  groupMemberInfoSetNotification(1516),
  @JsonValue(1517)
  groupMemberSetToAdminNotification(1517),
  @JsonValue(1518)
  groupMemberSetToOrdinaryUserNotification(1518),
  @JsonValue(1519)
  groupInfoSetAnnouncementNotification(1519),
  @JsonValue(1520)
  groupInfoSetNameNotification(1520),
  @JsonValue(1599)
  groupNotificationEnd(1599),

  @JsonValue(1701)
  conversationPrivateChatNotification(1701),
  @JsonValue(1703)
  clearConversationNotification(1703),

  @JsonValue(2001)
  businessNotification(2001),
  @JsonValue(2101)
  revokeMessageNotification(2101),
  @JsonValue(2102)
  deleteMsgsNotification(2102),
  @JsonValue(2200)
  hasReadReceipt(2200),
  @JsonValue(5000)
  notificationEnd(5000);

  const MessageType(this.value);

  final int value;

  factory MessageType.fromValue(int value) {
    return values.firstWhere((item) => item.value == value, orElse: () => text);
  }
}

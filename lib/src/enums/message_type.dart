import 'package:json_annotation/json_annotation.dart';

/// Message Types
enum MessageType {
  /// Normal text
  @JsonValue(101)
  text(101),

  /// Picture
  @JsonValue(102)
  picture(102),

  /// Voice
  @JsonValue(103)
  voice(103),

  /// Video
  @JsonValue(104)
  video(104),

  /// File
  @JsonValue(105)
  file(105),

  /// @ Message
  @JsonValue(106)
  atText(106),

  /// Merge
  @JsonValue(107)
  merger(107),

  /// Business Card
  @JsonValue(108)
  card(108),

  /// Location
  @JsonValue(109)
  location(109),

  /// Custom
  @JsonValue(110)
  custom(110),

  /// Typing
  @JsonValue(113)
  typing(113),

  /// Quote Reply
  @JsonValue(114)
  quote(114),

  /// Custom Emoji
  @JsonValue(115)
  customFace(115),

  /// Group Message Has Read Receipt (Deprecated in v3)
  @Deprecated('Use groupHasReadReceiptNotification instead')
  @JsonValue(116)
  groupHasReadReceipt(116),

  /// Rich Text Message
  @JsonValue(117)
  advancedText(117),

  @JsonValue(119)
  customMsgNotTriggerConversation(119),

  @JsonValue(120)
  customMsgOnlineOnly(120),

  /// Notification Types
  @JsonValue(1000)
  notificationBegin(1000),

  @JsonValue(1200)
  friendNotificationBegin(1200),

  /// Friend Request Accepted
  @JsonValue(1201)
  friendApplicationApprovedNotification(1201),

  /// Friend Request Rejected
  @JsonValue(1202)
  friendApplicationRejectedNotification(1202),

  /// Friend Request
  @JsonValue(1203)
  friendApplicationNotification(1203),

  /// Friend Added
  @JsonValue(1204)
  friendAddedNotification(1204),

  /// Friend Deleted
  @JsonValue(1205)
  friendDeletedNotification(1205),

  /// Set Friend Remark
  @JsonValue(1206)
  friendRemarkSetNotification(1206),

  /// Friend Added to Blacklist
  @JsonValue(1207)
  blackAddedNotification(1207),

  /// Removed from Blacklist
  @JsonValue(1208)
  blackDeletedNotification(1208),

  @JsonValue(1299)
  friendNotificationEnd(1299),

  /// Conversation Change
  @JsonValue(1300)
  conversationChangeNotification(1300),

  @JsonValue(1301)
  userNotificationBegin(1301),

  /// User Information Changed
  @JsonValue(1303)
  userInfoUpdatedNotification(1303),

  @JsonValue(1399)
  userNotificationEnd(1399),

  /// OA Notification
  @JsonValue(1400)
  oaNotification(1400),

  @JsonValue(1500)
  groupNotificationBegin(1500),

  /// Group Created
  @JsonValue(1501)
  groupCreatedNotification(1501),

  /// Group Info Set
  @JsonValue(1502)
  groupInfoSetNotification(1502),

  /// Join Group Application
  @JsonValue(1503)
  joinGroupApplicationNotification(1503),

  /// Group Member Quit
  @JsonValue(1504)
  memberQuitNotification(1504),

  /// Group Application Accepted
  @JsonValue(1505)
  groupApplicationAcceptedNotification(1505),

  /// Group Application Rejected
  @JsonValue(1506)
  groupApplicationRejectedNotification(1506),

  /// Group Owner Transferred
  @JsonValue(1507)
  groupOwnerTransferredNotification(1507),

  /// Member Kicked from Group
  @JsonValue(1508)
  memberKickedNotification(1508),

  /// Member Invited to Group
  @JsonValue(1509)
  memberInvitedNotification(1509),

  /// Member Entered Group
  @JsonValue(1510)
  memberEnterNotification(1510),

  /// Dismiss Group
  @JsonValue(1511)
  dismissGroupNotification(1511),

  /// Group Member Muted
  @JsonValue(1512)
  groupMemberMutedNotification(1512),

  /// Group Member Cancel Muted
  @JsonValue(1513)
  groupMemberCancelMutedNotification(1513),

  /// Group Muted
  @JsonValue(1514)
  groupMutedNotification(1514),

  /// Cancel Group Muted
  @JsonValue(1515)
  groupCancelMutedNotification(1515),

  /// Group Member Information Changed
  @JsonValue(1516)
  groupMemberInfoChangedNotification(1516),

  /// Group Member Set to Admin
  @JsonValue(1517)
  groupMemberSetToAdminNotification(1517),

  @JsonValue(1518)
  groupMemberSetToOrdinaryUserNotification(1518),

  /// Group Notice Changed
  @JsonValue(1519)
  groupInfoSetAnnouncementNotification(1519),

  /// Group Name Changed
  @JsonValue(1520)
  groupInfoSetNameNotification(1520),

  @JsonValue(1599)
  groupNotificationEnd(1599),

  /// Burn After Reading
  @JsonValue(1701)
  burnAfterReadingNotification(1701),

  @JsonValue(2000)
  notificationEnd(2000),

  /// Business Notification
  @JsonValue(2001)
  businessNotification(2001),

  /// Recall Message
  @JsonValue(2101)
  revokeMessageNotification(2101),

  /// Single Chat Has Read Receipt
  @JsonValue(2150)
  signalHasReadReceiptNotification(2150),

  /// Group Chat Has Read Receipt
  @JsonValue(2155)
  groupHasReadReceiptNotification(2155);

  const MessageType(this.value);

  final int value;
}

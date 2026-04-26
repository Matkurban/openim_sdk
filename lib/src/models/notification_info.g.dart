// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OANotification _$OANotificationFromJson(Map<String, dynamic> json) =>
    OANotification(
      notificationName: json['notificationName'] as String?,
      notificationFaceURL: json['notificationFaceURL'] as String?,
      notificationType: (json['notificationType'] as num?)?.toInt(),
      text: json['text'] as String?,
      externalUrl: json['externalUrl'] as String?,
      mixType: (json['mixType'] as num?)?.toInt(),
      pictureElem: json['pictureElem'] == null
          ? null
          : PictureElem.fromJson(json['pictureElem'] as Map<String, dynamic>),
      soundElem: json['soundElem'] == null
          ? null
          : SoundElem.fromJson(json['soundElem'] as Map<String, dynamic>),
      videoElem: json['videoElem'] == null
          ? null
          : VideoElem.fromJson(json['videoElem'] as Map<String, dynamic>),
      fileElem: json['fileElem'] == null
          ? null
          : FileElem.fromJson(json['fileElem'] as Map<String, dynamic>),
      ex: json['ex'] as String?,
    );

Map<String, dynamic> _$OANotificationToJson(OANotification instance) =>
    <String, dynamic>{
      'notificationName': instance.notificationName,
      'notificationFaceURL': instance.notificationFaceURL,
      'notificationType': instance.notificationType,
      'text': instance.text,
      'externalUrl': instance.externalUrl,
      'mixType': instance.mixType,
      'pictureElem': instance.pictureElem?.toJson(),
      'soundElem': instance.soundElem?.toJson(),
      'videoElem': instance.videoElem?.toJson(),
      'fileElem': instance.fileElem?.toJson(),
      'ex': instance.ex,
    };

BaseGroupNotification _$BaseGroupNotificationFromJson(
  Map<String, dynamic> json,
) => BaseGroupNotification(
  group: json['group'] == null
      ? null
      : GroupInfo.fromJson(json['group'] as Map<String, dynamic>),
  opUser: json['opUser'] == null
      ? null
      : GroupMembersInfo.fromJson(json['opUser'] as Map<String, dynamic>),
);

Map<String, dynamic> _$BaseGroupNotificationToJson(
  BaseGroupNotification instance,
) => <String, dynamic>{
  'group': instance.group?.toJson(),
  'opUser': instance.opUser?.toJson(),
};

GroupNotification _$GroupNotificationFromJson(Map<String, dynamic> json) =>
    GroupNotification(
      group: json['group'] == null
          ? null
          : GroupInfo.fromJson(json['group'] as Map<String, dynamic>),
      opUser: json['opUser'] == null
          ? null
          : GroupMembersInfo.fromJson(json['opUser'] as Map<String, dynamic>),
      groupOwnerUser: json['groupOwnerUser'] == null
          ? null
          : GroupMembersInfo.fromJson(
              json['groupOwnerUser'] as Map<String, dynamic>,
            ),
      memberList: (json['memberList'] as List<dynamic>?)
          ?.map((e) => GroupMembersInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GroupNotificationToJson(GroupNotification instance) =>
    <String, dynamic>{
      'group': instance.group?.toJson(),
      'opUser': instance.opUser?.toJson(),
      'groupOwnerUser': instance.groupOwnerUser?.toJson(),
      'memberList': instance.memberList?.map((e) => e.toJson()).toList(),
    };

InvitedJoinGroupNotification _$InvitedJoinGroupNotificationFromJson(
  Map<String, dynamic> json,
) => InvitedJoinGroupNotification(
  group: json['group'] == null
      ? null
      : GroupInfo.fromJson(json['group'] as Map<String, dynamic>),
  opUser: json['opUser'] == null
      ? null
      : GroupMembersInfo.fromJson(json['opUser'] as Map<String, dynamic>),
  inviterUser: json['inviterUser'] == null
      ? null
      : GroupMembersInfo.fromJson(json['inviterUser'] as Map<String, dynamic>),
  invitedUserList: (json['invitedUserList'] as List<dynamic>?)
      ?.map((e) => GroupMembersInfo.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$InvitedJoinGroupNotificationToJson(
  InvitedJoinGroupNotification instance,
) => <String, dynamic>{
  'group': instance.group?.toJson(),
  'opUser': instance.opUser?.toJson(),
  'inviterUser': instance.inviterUser?.toJson(),
  'invitedUserList': instance.invitedUserList?.map((e) => e.toJson()).toList(),
};

KickedGroupMemeberNotification _$KickedGroupMemeberNotificationFromJson(
  Map<String, dynamic> json,
) => KickedGroupMemeberNotification(
  group: json['group'] == null
      ? null
      : GroupInfo.fromJson(json['group'] as Map<String, dynamic>),
  opUser: json['opUser'] == null
      ? null
      : GroupMembersInfo.fromJson(json['opUser'] as Map<String, dynamic>),
  kickedUserList: (json['kickedUserList'] as List<dynamic>?)
      ?.map((e) => GroupMembersInfo.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$KickedGroupMemeberNotificationToJson(
  KickedGroupMemeberNotification instance,
) => <String, dynamic>{
  'group': instance.group?.toJson(),
  'opUser': instance.opUser?.toJson(),
  'kickedUserList': instance.kickedUserList?.map((e) => e.toJson()).toList(),
};

QuitGroupNotification _$QuitGroupNotificationFromJson(
  Map<String, dynamic> json,
) => QuitGroupNotification(
  group: json['group'] == null
      ? null
      : GroupInfo.fromJson(json['group'] as Map<String, dynamic>),
  quitUser: json['quitUser'] == null
      ? null
      : GroupMembersInfo.fromJson(json['quitUser'] as Map<String, dynamic>),
);

Map<String, dynamic> _$QuitGroupNotificationToJson(
  QuitGroupNotification instance,
) => <String, dynamic>{
  'group': instance.group?.toJson(),
  'quitUser': instance.quitUser?.toJson(),
};

EnterGroupNotification _$EnterGroupNotificationFromJson(
  Map<String, dynamic> json,
) => EnterGroupNotification(
  group: json['group'] == null
      ? null
      : GroupInfo.fromJson(json['group'] as Map<String, dynamic>),
  entrantUser: json['entrantUser'] == null
      ? null
      : GroupMembersInfo.fromJson(json['entrantUser'] as Map<String, dynamic>),
);

Map<String, dynamic> _$EnterGroupNotificationToJson(
  EnterGroupNotification instance,
) => <String, dynamic>{
  'group': instance.group?.toJson(),
  'entrantUser': instance.entrantUser?.toJson(),
};

GroupRightsTransferNoticication _$GroupRightsTransferNoticicationFromJson(
  Map<String, dynamic> json,
) => GroupRightsTransferNoticication(
  group: json['group'] == null
      ? null
      : GroupInfo.fromJson(json['group'] as Map<String, dynamic>),
  opUser: json['opUser'] == null
      ? null
      : GroupMembersInfo.fromJson(json['opUser'] as Map<String, dynamic>),
  newGroupOwner: json['newGroupOwner'] == null
      ? null
      : GroupMembersInfo.fromJson(
          json['newGroupOwner'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$GroupRightsTransferNoticicationToJson(
  GroupRightsTransferNoticication instance,
) => <String, dynamic>{
  'group': instance.group?.toJson(),
  'opUser': instance.opUser?.toJson(),
  'newGroupOwner': instance.newGroupOwner?.toJson(),
};

MuteMemberNotification _$MuteMemberNotificationFromJson(
  Map<String, dynamic> json,
) => MuteMemberNotification(
  group: json['group'] == null
      ? null
      : GroupInfo.fromJson(json['group'] as Map<String, dynamic>),
  opUser: json['opUser'] == null
      ? null
      : GroupMembersInfo.fromJson(json['opUser'] as Map<String, dynamic>),
  mutedUser: json['mutedUser'] == null
      ? null
      : GroupMembersInfo.fromJson(json['mutedUser'] as Map<String, dynamic>),
  mutedSeconds: (json['mutedSeconds'] as num?)?.toInt(),
);

Map<String, dynamic> _$MuteMemberNotificationToJson(
  MuteMemberNotification instance,
) => <String, dynamic>{
  'group': instance.group?.toJson(),
  'opUser': instance.opUser?.toJson(),
  'mutedUser': instance.mutedUser?.toJson(),
  'mutedSeconds': instance.mutedSeconds,
};

BurnAfterReadingNotification _$BurnAfterReadingNotificationFromJson(
  Map<String, dynamic> json,
) => BurnAfterReadingNotification(
  recvID: json['recvID'] as String?,
  sendID: json['sendID'] as String?,
  isPrivate: json['isPrivate'] as bool?,
);

Map<String, dynamic> _$BurnAfterReadingNotificationToJson(
  BurnAfterReadingNotification instance,
) => <String, dynamic>{
  'recvID': instance.recvID,
  'sendID': instance.sendID,
  'isPrivate': instance.isPrivate,
};

GroupMemberInfoChangedNotification _$GroupMemberInfoChangedNotificationFromJson(
  Map<String, dynamic> json,
) => GroupMemberInfoChangedNotification(
  group: json['group'] == null
      ? null
      : GroupInfo.fromJson(json['group'] as Map<String, dynamic>),
  opUser: json['opUser'] == null
      ? null
      : GroupMembersInfo.fromJson(json['opUser'] as Map<String, dynamic>),
  changedUser: json['changedUser'] == null
      ? null
      : GroupMembersInfo.fromJson(json['changedUser'] as Map<String, dynamic>),
);

Map<String, dynamic> _$GroupMemberInfoChangedNotificationToJson(
  GroupMemberInfoChangedNotification instance,
) => <String, dynamic>{
  'group': instance.group?.toJson(),
  'opUser': instance.opUser?.toJson(),
  'changedUser': instance.changedUser?.toJson(),
};

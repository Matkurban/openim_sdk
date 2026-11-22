import '../../core/base_notification_handler.dart';
import '../../db/db_engine.dart';
import '../../listener/group_listener.dart';
import '../../models/group_info.dart';
import '../entity_syncers/group_syncer.dart';

/// 群组与群成员系统通知处理器（contentType 1501–1520）。
final class GroupNotificationHandler extends BaseNotificationHandler {
  final DbEngine db;
  final GroupSyncer groupSyncer;
  final String loginUserID;
  final OnGroupListener? Function() listenerProvider;

  GroupNotificationHandler({
    required this.db,
    required this.groupSyncer,
    required this.loginUserID,
    required this.listenerProvider,
  }) : super('GroupNotificationHandler');

  @override
  bool canHandle(int contentType) => contentType >= 1501 && contentType <= 1520;

  @override
  Future<void> handle(int contentType, Map<String, dynamic> detail) async {
    final OnGroupListener? listener = listenerProvider();
    final Map<String, dynamic>? groupMap = detail['group'] as Map<String, dynamic>?;
    final String groupID = groupMap?['groupID']?.toString() ?? detail['groupID']?.toString() ?? '';

    switch (contentType) {
      case 1501: // groupCreated
        await groupSyncer.sync(loginUserID);
        if (groupID.isNotEmpty) {
          final GroupInfo? info = await db.groups.getGroupByID(groupID);
          if (info != null) {
            listener?.joinedGroupAdded(info);
          }
        }
      case 1502: // groupInfoSet
      case 1514: // groupMuted
      case 1515: // groupCancelMuted
      case 1519: // groupInfoSetAnnouncement
      case 1520: // groupInfoSetName
        if (groupID.isNotEmpty) {
          await groupSyncer.syncGroupInfoAndMembers(groupID);
          final GroupInfo? info = await db.groups.getGroupByID(groupID);
          if (info != null) {
            listener?.groupInfoChanged(info);
          }
        }
      case 1503: // joinGroupApplication
        listener?.groupApplicationAdded(_parseGroupApp(detail, groupID));
      case 1505: // groupApplicationAccepted
        await groupSyncer.sync(loginUserID);
        listener?.groupApplicationAccepted(_parseGroupApp(detail, groupID));
      case 1506: // groupApplicationRejected
        listener?.groupApplicationRejected(_parseGroupApp(detail, groupID));
      case 1504: // memberQuit
        final Map<String, dynamic>? quitUser = detail['quitUser'] as Map<String, dynamic>?;
        final String quitUserID = quitUser?['userID']?.toString() ?? '';
        if (quitUserID == loginUserID && groupID.isNotEmpty) {
          final GroupInfo? oldGroup = await db.groups.getGroupByID(groupID);
          await db.groups.deleteGroup(groupID);
          await db.groups.deleteGroupAllMembers(groupID);
          if (oldGroup != null) {
            listener?.joinedGroupDeleted(oldGroup);
          }
        } else if (groupID.isNotEmpty) {
          if (quitUserID.isNotEmpty) {
            await db.groups.deleteGroupMember(groupID, quitUserID);
          }
          await groupSyncer.syncGroupInfoAndMembers(groupID);
          if (quitUser != null) {
            listener?.groupMemberDeleted(GroupMembersInfo.fromJson(quitUser));
          }
        }
      case 1507: // groupOwnerTransferred
        if (groupID.isNotEmpty) {
          await groupSyncer.syncGroupInfoAndMembers(groupID);
          final GroupInfo? info = await db.groups.getGroupByID(groupID);
          if (info != null) {
            listener?.groupInfoChanged(info);
          }
        }
      case 1508: // memberKicked
        final List<dynamic> kickedList =
            detail['kickedUserList'] as List<dynamic>? ?? const <dynamic>[];
        final bool selfKicked = kickedList.any(
          (dynamic m) => m is Map<dynamic, dynamic> && m['userID']?.toString() == loginUserID,
        );
        if (selfKicked && groupID.isNotEmpty) {
          final GroupInfo? oldGroup = await db.groups.getGroupByID(groupID);
          await db.groups.deleteGroup(groupID);
          await db.groups.deleteGroupAllMembers(groupID);
          if (oldGroup != null) {
            listener?.joinedGroupDeleted(oldGroup);
          }
        } else if (groupID.isNotEmpty) {
          for (final dynamic m in kickedList) {
            if (m is Map<String, dynamic>) {
              final String uid = m['userID']?.toString() ?? '';
              if (uid.isNotEmpty) {
                await db.groups.deleteGroupMember(groupID, uid);
              }
              listener?.groupMemberDeleted(GroupMembersInfo.fromJson(m));
            }
          }
          await groupSyncer.syncGroupInfoAndMembers(groupID);
        }
      case 1509: // memberInvited
      case 1510: // memberEnter
        if (groupID.isNotEmpty) {
          final GroupInfo? existed = await db.groups.getGroupByID(groupID);
          await groupSyncer.syncGroupInfoAndMembers(groupID);
          final GroupInfo? info = await db.groups.getGroupByID(groupID);
          if (existed == null && info != null) {
            listener?.joinedGroupAdded(info);
          } else {
            final List<dynamic> added =
                (detail['invitedUserList'] as List<dynamic>?) ??
                (detail['entrantUser'] != null
                    ? <dynamic>[detail['entrantUser']]
                    : const <dynamic>[]);
            for (final dynamic m in added) {
              if (m is Map<String, dynamic>) {
                listener?.groupMemberAdded(GroupMembersInfo.fromJson(m));
              }
            }
          }
        }
      case 1511: // groupDismissed
        if (groupID.isNotEmpty) {
          final GroupInfo? oldGroup = await db.groups.getGroupByID(groupID);
          await db.groups.deleteGroup(groupID);
          await db.groups.deleteGroupAllMembers(groupID);
          if (oldGroup != null) {
            listener?.groupDismissed(oldGroup);
          }
        }
      case 1512: // groupMemberMuted
      case 1513: // groupMemberCancelMuted
      case 1516: // groupMemberInfoSet
      case 1517: // groupMemberSetToAdmin
      case 1518: // groupMemberSetToOrdinaryUser
        if (groupID.isNotEmpty) {
          await groupSyncer.syncGroupMembers(groupID);
          final Map<String, dynamic>? changedUser =
              (detail['changedUser'] ?? detail['mutedUser']) as Map<String, dynamic>?;
          if (changedUser != null) {
            listener?.groupMemberInfoChanged(GroupMembersInfo.fromJson(changedUser));
          }
        }
    }
  }

  GroupApplicationInfo _parseGroupApp(Map<String, dynamic> detail, String groupID) {
    final Map<String, dynamic>? applicant = detail['applicant'] as Map<String, dynamic>?;
    return GroupApplicationInfo(
      groupID: groupID,
      userID: applicant?['userID']?.toString() ?? detail['userID']?.toString(),
      nickname: applicant?['nickname']?.toString(),
      userFaceURL: applicant?['faceURL']?.toString(),
      reqMsg: detail['reqMsg']?.toString(),
      handledMsg: detail['handleMsg']?.toString(),
    );
  }
}

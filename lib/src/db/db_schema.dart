import 'package:tostore/tostore.dart';

/// 数据库表名常量定义
/// 对应 Go SDK 中 model_struct 的所有本地数据表
sealed class DbTableName {
  /// 本地用户表
  static const String localUser = 'local_users';

  /// 本地好友表
  static const String localFriend = 'local_friends';

  /// 本地好友申请表
  static const String localFriendRequest = 'local_friend_requests';

  /// 本地黑名单表
  static const String localBlack = 'local_blacks';

  /// 本地群组表
  static const String localGroup = 'local_groups';

  /// 本地群成员表
  static const String localGroupMember = 'local_group_members';

  /// 本地群申请表
  static const String localGroupRequest = 'local_group_requests';

  /// 本地会话表
  static const String localConversation = 'local_conversations';

  /// 本地聊天记录表
  static const String localChatLog = 'local_chat_logs';

  /// 本地发送中消息表
  static const String localSendingMessage = 'local_sending_messages';

  /// 本地朋友圈动态表
  static const String localMoment = 'local_moments';

  /// 本地收藏夹表
  static const String localFavorite = 'local_favorites';
}

/// 数据库表结构定义
/// 基于 Tostore TableSchema 的完整表结构，字段对应 Go SDK model_struct
sealed class DbSchema {
  /// 本地用户表结构
  static final localUser = TableSchema(
    name: DbTableName.localUser,
    primaryKeyConfig: const PrimaryKeyConfig(name: 'userID', type: PrimaryKeyType.none),
    fields: [
      const FieldSchema(name: 'nickname', type: DataType.text, nullable: true),
      const FieldSchema(name: 'faceURL', type: DataType.text, nullable: true),
      const FieldSchema(name: 'ex', type: DataType.text, nullable: true),
      const FieldSchema(name: 'createTime', type: DataType.integer, nullable: true),
      const FieldSchema(name: 'appMangerLevel', type: DataType.integer, nullable: true),
      const FieldSchema(name: 'globalRecvMsgOpt', type: DataType.integer, nullable: true),
    ],
  );

  /// 本地好友表结构
  static final localFriend = TableSchema(
    name: DbTableName.localFriend,
    primaryKeyConfig: const PrimaryKeyConfig(name: 'friendUserID', type: PrimaryKeyType.none),
    fields: [
      const FieldSchema(name: 'ownerUserID', type: DataType.text, nullable: false),
      const FieldSchema(name: 'userID', type: DataType.text, nullable: true),
      const FieldSchema(name: 'nickname', type: DataType.text, nullable: true),
      const FieldSchema(name: 'faceURL', type: DataType.text, nullable: true),
      const FieldSchema(name: 'remark', type: DataType.text, nullable: true),
      const FieldSchema(name: 'ex', type: DataType.text, nullable: true),
      const FieldSchema(name: 'createTime', type: DataType.integer, nullable: true),
      const FieldSchema(name: 'addSource', type: DataType.integer, nullable: true),
      const FieldSchema(name: 'operatorUserID', type: DataType.text, nullable: true),
      const FieldSchema(name: 'isPinned', type: DataType.boolean, nullable: true),
    ],
    indexes: [
      const IndexSchema(fields: ['ownerUserID','nickname']),
    ],
  );

  /// 本地好友申请表结构
  static final localFriendRequest = TableSchema(
    name: DbTableName.localFriendRequest,
    primaryKeyConfig: const PrimaryKeyConfig(name: 'id', type: PrimaryKeyType.timestampBased),
    fields: [
      const FieldSchema(name: 'fromUserID', type: DataType.text, nullable: false),
      const FieldSchema(name: 'fromNickname', type: DataType.text, nullable: true),
      const FieldSchema(name: 'fromFaceURL', type: DataType.text, nullable: true),
      const FieldSchema(name: 'toUserID', type: DataType.text, nullable: false),
      const FieldSchema(name: 'toNickname', type: DataType.text, nullable: true),
      const FieldSchema(name: 'toFaceURL', type: DataType.text, nullable: true),
      const FieldSchema(name: 'handleResult', type: DataType.integer, nullable: true),
      const FieldSchema(name: 'reqMsg', type: DataType.text, nullable: true),
      const FieldSchema(name: 'createTime', type: DataType.integer, nullable: true),
      const FieldSchema(name: 'handlerUserID', type: DataType.text, nullable: true),
      const FieldSchema(name: 'handleMsg', type: DataType.text, nullable: true),
      const FieldSchema(name: 'handleTime', type: DataType.integer, nullable: true),
      const FieldSchema(name: 'ex', type: DataType.text, nullable: true),
    ],
    indexes: [
      const IndexSchema(fields: ['fromUserID', 'toUserID'], unique: true),
    ],
  );

  /// 本地黑名单表结构
  static final localBlack = TableSchema(
    name: DbTableName.localBlack,
    primaryKeyConfig: const PrimaryKeyConfig(name: 'id', type: PrimaryKeyType.timestampBased),
    fields: [
      const FieldSchema(name: 'ownerUserID', type: DataType.text, nullable: false),
      const FieldSchema(name: 'blockUserID', type: DataType.text, nullable: false),
      const FieldSchema(name: 'userID', type: DataType.text, nullable: true),
      const FieldSchema(name: 'nickname', type: DataType.text, nullable: true),
      const FieldSchema(name: 'faceURL', type: DataType.text, nullable: true),
      const FieldSchema(name: 'gender', type: DataType.integer, nullable: true),
      const FieldSchema(name: 'createTime', type: DataType.integer, nullable: true),
      const FieldSchema(name: 'addSource', type: DataType.integer, nullable: true),
      const FieldSchema(name: 'operatorUserID', type: DataType.text, nullable: true),
      const FieldSchema(name: 'ex', type: DataType.text, nullable: true),
    ],
    indexes: [
      const IndexSchema(fields: ['ownerUserID', 'blockUserID'], unique: true),
    ],
  );

  /// 本地群组表结构
  static final localGroup = TableSchema(
    name: DbTableName.localGroup,
    primaryKeyConfig: const PrimaryKeyConfig(name: 'groupID', type: PrimaryKeyType.none),
    fields: [
      const FieldSchema(name: 'groupName', type: DataType.text, nullable: true),
      const FieldSchema(name: 'notification', type: DataType.text, nullable: true),
      const FieldSchema(name: 'introduction', type: DataType.text, nullable: true),
      const FieldSchema(name: 'faceURL', type: DataType.text, nullable: true),
      const FieldSchema(name: 'ownerUserID', type: DataType.text, nullable: true),
      const FieldSchema(name: 'createTime', type: DataType.integer, nullable: true),
      const FieldSchema(name: 'memberCount', type: DataType.integer, nullable: true),
      const FieldSchema(name: 'status', type: DataType.integer, nullable: true),
      const FieldSchema(name: 'creatorUserID', type: DataType.text, nullable: true),
      const FieldSchema(name: 'groupType', type: DataType.integer, nullable: true),
      const FieldSchema(name: 'ex', type: DataType.text, nullable: true),
      const FieldSchema(name: 'needVerification', type: DataType.integer, nullable: true),
      const FieldSchema(name: 'lookMemberInfo', type: DataType.integer, nullable: true),
      const FieldSchema(name: 'applyMemberFriend', type: DataType.integer, nullable: true),
      const FieldSchema(name: 'notificationUpdateTime', type: DataType.integer, nullable: true),
      const FieldSchema(name: 'notificationUserID', type: DataType.text, nullable: true),
    ],
    indexes: [
      const IndexSchema(fields: ['groupName','ownerUserID']),
    ],
  );

  /// 本地群成员表结构
  static final localGroupMember = TableSchema(
    name: DbTableName.localGroupMember,
    primaryKeyConfig: const PrimaryKeyConfig(name: 'id', type: PrimaryKeyType.timestampBased),
    fields: [
      const FieldSchema(name: 'groupID', type: DataType.text, nullable: false),
      const FieldSchema(name: 'userID', type: DataType.text, nullable: false),
      const FieldSchema(name: 'nickname', type: DataType.text, nullable: true),
      const FieldSchema(name: 'faceURL', type: DataType.text, nullable: true),
      const FieldSchema(name: 'roleLevel', type: DataType.integer, nullable: true),
      const FieldSchema(name: 'joinTime', type: DataType.integer, nullable: true),
      const FieldSchema(name: 'joinSource', type: DataType.integer, nullable: true),
      const FieldSchema(name: 'operatorUserID', type: DataType.text, nullable: true),
      const FieldSchema(name: 'ex', type: DataType.text, nullable: true),
      const FieldSchema(name: 'muteEndTime', type: DataType.integer, nullable: true),
      const FieldSchema(name: 'appManagerLevel', type: DataType.integer, nullable: true),
      const FieldSchema(name: 'inviterUserID', type: DataType.text, nullable: true),
    ],
    indexes: [
      const IndexSchema(fields: ['groupID', 'userID','roleLevel'],),
    ],
  );

  /// 本地群申请表结构
  static final localGroupRequest = TableSchema(
    name: DbTableName.localGroupRequest,
    primaryKeyConfig: const PrimaryKeyConfig(name: 'id', type: PrimaryKeyType.timestampBased),
    fields: [
      const FieldSchema(name: 'groupID', type: DataType.text, nullable: false),
      const FieldSchema(name: 'groupName', type: DataType.text, nullable: true),
      const FieldSchema(name: 'notification', type: DataType.text, nullable: true),
      const FieldSchema(name: 'introduction', type: DataType.text, nullable: true),
      const FieldSchema(name: 'groupFaceURL', type: DataType.text, nullable: true),
      const FieldSchema(name: 'createTime', type: DataType.integer, nullable: true),
      const FieldSchema(name: 'status', type: DataType.integer, nullable: true),
      const FieldSchema(name: 'creatorUserID', type: DataType.text, nullable: true),
      const FieldSchema(name: 'groupType', type: DataType.integer, nullable: true),
      const FieldSchema(name: 'ownerUserID', type: DataType.text, nullable: true),
      const FieldSchema(name: 'memberCount', type: DataType.integer, nullable: true),
      const FieldSchema(name: 'userID', type: DataType.text, nullable: true),
      const FieldSchema(name: 'nickname', type: DataType.text, nullable: true),
      const FieldSchema(name: 'userFaceURL', type: DataType.text, nullable: true),
      const FieldSchema(name: 'gender', type: DataType.integer, nullable: true),
      const FieldSchema(name: 'handleResult', type: DataType.integer, nullable: true),
      const FieldSchema(name: 'reqMsg', type: DataType.text, nullable: true),
      const FieldSchema(name: 'handledMsg', type: DataType.text, nullable: true),
      const FieldSchema(name: 'reqTime', type: DataType.integer, nullable: true),
      const FieldSchema(name: 'handleUserID', type: DataType.text, nullable: true),
      const FieldSchema(name: 'handledTime', type: DataType.integer, nullable: true),
      const FieldSchema(name: 'ex', type: DataType.text, nullable: true),
      const FieldSchema(name: 'joinSource', type: DataType.integer, nullable: true),
      const FieldSchema(name: 'inviterUserID', type: DataType.text, nullable: true),
    ],
    indexes: [
      const IndexSchema(fields: ['groupID', 'userID']),
    ],
  );

  /// 本地会话表结构
  static final localConversation = TableSchema(
    name: DbTableName.localConversation,
    primaryKeyConfig: const PrimaryKeyConfig(name: 'conversationID', type: PrimaryKeyType.none),
    fields: [
      const FieldSchema(name: 'conversationType', type: DataType.integer, nullable: true),
      const FieldSchema(name: 'userID', type: DataType.text, nullable: true),
      const FieldSchema(name: 'groupID', type: DataType.text, nullable: true),
      const FieldSchema(name: 'showName', type: DataType.text, nullable: true),
      const FieldSchema(name: 'faceURL', type: DataType.text, nullable: true),
      const FieldSchema(name: 'recvMsgOpt', type: DataType.integer, nullable: true),
      const FieldSchema(
        name: 'unreadCount',
        type: DataType.integer,
        nullable: true,
        defaultValue: 0,
      ),
      const FieldSchema(name: 'latestMsg', type: DataType.text, nullable: true),
      const FieldSchema(name: 'latestMsgSendTime', type: DataType.integer, nullable: true),
      const FieldSchema(name: 'draftText', type: DataType.text, nullable: true),
      const FieldSchema(name: 'draftTextTime', type: DataType.integer, nullable: true),
      const FieldSchema(
        name: 'isPinned',
        type: DataType.boolean,
        nullable: true,
        defaultValue: false,
      ),
      const FieldSchema(
        name: 'isPrivateChat',
        type: DataType.boolean,
        nullable: true,
        defaultValue: false,
      ),
      const FieldSchema(name: 'burnDuration', type: DataType.integer, nullable: true),
      const FieldSchema(
        name: 'isMsgDestruct',
        type: DataType.boolean,
        nullable: true,
        defaultValue: false,
      ),
      const FieldSchema(name: 'msgDestructTime', type: DataType.integer, nullable: true),
      const FieldSchema(name: 'ex', type: DataType.text, nullable: true),
      const FieldSchema(
        name: 'isNotInGroup',
        type: DataType.boolean,
        nullable: true,
        defaultValue: false,
      ),
      const FieldSchema(name: 'groupAtType', type: DataType.integer, nullable: true),
      const FieldSchema(name: 'maxSeq', type: DataType.integer, nullable: true, defaultValue: 0),
      const FieldSchema(name: 'minSeq', type: DataType.integer, nullable: true, defaultValue: 0),
      const FieldSchema(
        name: 'hasReadSeq',
        type: DataType.integer,
        nullable: true,
        defaultValue: 0,
      ),
    ],
    indexes: [
      const IndexSchema(fields: ['conversationType','latestMsgSendTime','isPinned']),
    ],
  );

  /// 本地聊天记录表结构
  static final localChatLog = TableSchema(
    name: DbTableName.localChatLog,
    primaryKeyConfig: const PrimaryKeyConfig(name: 'clientMsgID', type: PrimaryKeyType.none),
    fields: [
      const FieldSchema(name: 'serverMsgID', type: DataType.text, nullable: true),
      const FieldSchema(name: 'sendID', type: DataType.text, nullable: true),
      const FieldSchema(name: 'recvID', type: DataType.text, nullable: true),
      const FieldSchema(name: 'senderPlatformID', type: DataType.integer, nullable: true),
      const FieldSchema(name: 'senderNickname', type: DataType.text, nullable: true),
      const FieldSchema(name: 'senderFaceUrl', type: DataType.text, nullable: true),
      const FieldSchema(name: 'groupID', type: DataType.text, nullable: true),
      const FieldSchema(name: 'sessionType', type: DataType.integer, nullable: true),
      const FieldSchema(name: 'msgFrom', type: DataType.integer, nullable: true),
      const FieldSchema(name: 'contentType', type: DataType.integer, nullable: true),
      const FieldSchema(name: 'content', type: DataType.text, nullable: true),
      const FieldSchema(
        name: 'isRead',
        type: DataType.boolean,
        nullable: true,
        defaultValue: false,
      ),
      const FieldSchema(name: 'status', type: DataType.integer, nullable: true),
      const FieldSchema(name: 'seq', type: DataType.integer, nullable: true, defaultValue: 0),
      const FieldSchema(name: 'sendTime', type: DataType.integer, nullable: true),
      const FieldSchema(name: 'createTime', type: DataType.integer, nullable: true),
      const FieldSchema(name: 'attachedInfo', type: DataType.text, nullable: true),
      const FieldSchema(name: 'ex', type: DataType.text, nullable: true),
      const FieldSchema(name: 'localEx', type: DataType.text, nullable: true),
      const FieldSchema(
        name: 'isReact',
        type: DataType.boolean,
        nullable: true,
        defaultValue: false,
      ),
      const FieldSchema(
        name: 'isExternalExtensions',
        type: DataType.boolean,
        nullable: true,
        defaultValue: false,
      ),
      const FieldSchema(name: 'hasReadTime', type: DataType.integer, nullable: true),
      const FieldSchema(name: 'conversationID', type: DataType.text, nullable: true),
    ],
    indexes: [
      const IndexSchema(fields: ['conversationID', 'sendTime', 'seq', 'contentType']),
    ],
  );

  /// 本地发送中消息表结构
  static final localSendingMessage = TableSchema(
    name: DbTableName.localSendingMessage,
    primaryKeyConfig: const PrimaryKeyConfig(name: 'clientMsgID', type: PrimaryKeyType.none),
    fields: [
      const FieldSchema(name: 'conversationID', type: DataType.text, nullable: false),
      const FieldSchema(name: 'ex', type: DataType.text, nullable: true),
    ],
    indexes: [
      const IndexSchema(fields: ['conversationID']),
    ],
  );

  /// 本地朋友圈动态表结构
  ///
  /// 存储完整的朋友圈动态信息，包含内嵌的点赞和评论列表（JSON text）。
  /// 点赞/评论写入 moment 记录的 likes/comments 字段即可，无需独立子表。
  static final localMoment = TableSchema(
    name: DbTableName.localMoment,
    primaryKeyConfig: const PrimaryKeyConfig(name: 'momentID', type: PrimaryKeyType.none),
    fields: [
      const FieldSchema(name: 'userID', type: DataType.text, nullable: false),
      const FieldSchema(name: 'content', type: DataType.text, nullable: true),
      const FieldSchema(name: 'media', type: DataType.text, nullable: true),
      const FieldSchema(name: 'visibleType', type: DataType.integer, nullable: true),
      const FieldSchema(name: 'visibleGroupIDs', type: DataType.text, nullable: true),
      const FieldSchema(name: 'status', type: DataType.integer, nullable: true),
      const FieldSchema(name: 'createTime', type: DataType.text, nullable: true),
      const FieldSchema(name: 'updateTime', type: DataType.text, nullable: true),
      const FieldSchema(name: 'likeCount', type: DataType.integer, nullable: true),
      const FieldSchema(name: 'commentCount', type: DataType.integer, nullable: true),
      const FieldSchema(name: 'extra', type: DataType.text, nullable: true),
      const FieldSchema(name: 'likes', type: DataType.array, nullable: true),
      const FieldSchema(name: 'comments', type: DataType.array, nullable: true),
    ],
    indexes: [
      const IndexSchema(fields: ['userID', 'createTime']),
    ],
  );

  /// 本地收藏夹表结构
  static final localFavorite = TableSchema(
    name: DbTableName.localFavorite,
    primaryKeyConfig: const PrimaryKeyConfig(name: 'favoriteID', type: PrimaryKeyType.none),
    fields: [
      const FieldSchema(name: 'userID', type: DataType.text, nullable: false),
      const FieldSchema(name: 'targetType', type: DataType.text, nullable: false),
      const FieldSchema(name: 'targetID', type: DataType.text, nullable: false),
      const FieldSchema(name: 'data', type: DataType.text, nullable: true),
      const FieldSchema(name: 'createTime', type: DataType.integer, nullable: true),
    ],
    indexes: [
      const IndexSchema(fields: ['userID', 'createTime','targetType', 'targetID']),
    ],
  );

  /// 获取所有表结构定义列表，用于数据库初始化
  static List<TableSchema> get allSchemas => [
    localUser,
    localFriend,
    localFriendRequest,
    localBlack,
    localGroup,
    localGroupMember,
    localGroupRequest,
    localConversation,
    localChatLog,
    localSendingMessage,
    localMoment,
    localFavorite,
  ];
}

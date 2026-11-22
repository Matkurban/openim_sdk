import 'package:tostore/tostore.dart';

/// 数据库表名常量定义。
///
/// Database table name.
sealed class DbTableName {
  /// 本地用户。
  ///
  /// Local user.
  static const String localUser = 'local_users';

  /// 本地好友。
  ///
  /// Local friend.
  static const String localFriend = 'local_friends';

  /// 本地好友申请/请求。
  ///
  /// Local friend request.
  static const String localFriendRequest = 'local_friend_requests';

  /// 本地黑名单。
  ///
  /// Local blacklist.
  static const String localBlack = 'local_blacks';

  /// 本地群组。
  ///
  /// Local group.
  static const String localGroup = 'local_groups';

  /// 本地群组成员。
  ///
  /// Local group member.
  static const String localGroupMember = 'local_group_members';

  /// 本地群组申请/请求。
  ///
  /// Local group request.
  static const String localGroupRequest = 'local_group_requests';

  /// 本地会话。
  ///
  /// Local conversation.
  static const String localConversation = 'local_conversations';

  /// 本地ChatLog。
  ///
  /// Local chat log.
  static const String localChatLog = 'local_chat_logs';

  /// 本地Sending消息。
  ///
  /// Local sending message.
  static const String localSendingMessage = 'local_sending_messages';

  /// 本地朋友圈动态。
  ///
  /// Local moment.
  static const String localMoment = 'local_moments';

  /// 本地收藏。
  ///
  /// Local favorite.
  static const String localFavorite = 'local_favorites';

  /// 本地上传。
  ///
  /// Local upload.
  static const String localUpload = 'local_uploads';

  /// 本地版本同步。
  ///
  /// Local version sync.
  static const String localVersionSync = 'local_version_sync';

  /// 本地通知序列号。
  ///
  /// Local notification sequence number.
  static const String localNotificationSeq = 'local_notification_seqs';

  /// 本地已领取红包。
  ///
  /// Local grabbed red packet.
  static const String localGrabbedRedPacket = 'local_grabbed_red_packets';
}

/// 基于 ToStore 3.6.3 最佳实践优化的完整数据库表结构定义。
///
/// 优化要点：
/// 1. 复合关系表全部改用确定性复合主键（`PrimaryKeyType.none`），消除历史 3.0.8 全表扫描绕过；
/// 2. 补齐高频复合索引（会话排序、消息分页、seq 补拉、未读统计、群角色过滤）；
/// 3. 为消息正文、好友昵称/备注、会话名、群名启用 `IndexType.text` BM25 全文检索索引；
/// 4. 全表声明 `tableId`，保障声明式 Schema 在线自动演进安全。
sealed class DbSchema {
  /// 构建确定性双键复合主键，避免重复插入与全表扫描。
  ///
  /// Composite key.
  ///
  /// - [partA] 分片A / Part a.
  /// - [partB] 分片B / Part b.
  /// - Returns: 字符串结果 / String result.
  static String compositeKey(String partA, String partB) => '${partA}_$partB';

  /// 本地用户。
  ///
  /// Local user.
  static final TableSchema localUser = TableSchema(
    name: DbTableName.localUser,
    tableId: DbTableName.localUser,
    primaryKeyConfig: const PrimaryKeyConfig(name: 'userID', type: PrimaryKeyType.none),
    fields: const <FieldSchema>[
      FieldSchema(name: 'nickname', type: DataType.text, nullable: true),
      FieldSchema(name: 'faceURL', type: DataType.text, nullable: true),
      FieldSchema(name: 'ex', type: DataType.text, nullable: true),
      FieldSchema(name: 'createTime', type: DataType.integer, nullable: true),
      FieldSchema(name: 'appMangerLevel', type: DataType.integer, nullable: true),
      FieldSchema(name: 'globalRecvMsgOpt', type: DataType.integer, nullable: true),
    ],
  );

  /// 本地好友。
  ///
  /// Local friend.
  static final TableSchema localFriend = TableSchema(
    name: DbTableName.localFriend,
    tableId: DbTableName.localFriend,
    primaryKeyConfig: const PrimaryKeyConfig(name: 'friendUserID', type: PrimaryKeyType.none),
    fields: const <FieldSchema>[
      FieldSchema(name: 'ownerUserID', type: DataType.text, nullable: false, createIndex: true),
      FieldSchema(name: 'userID', type: DataType.text, nullable: true),
      FieldSchema(name: 'nickname', type: DataType.text, nullable: true),
      FieldSchema(name: 'faceURL', type: DataType.text, nullable: true),
      FieldSchema(name: 'remark', type: DataType.text, nullable: true),
      FieldSchema(name: 'ex', type: DataType.text, nullable: true),
      FieldSchema(name: 'createTime', type: DataType.integer, nullable: true),
      FieldSchema(name: 'addSource', type: DataType.integer, nullable: true),
      FieldSchema(name: 'operatorUserID', type: DataType.text, nullable: true),
      FieldSchema(name: 'isPinned', type: DataType.boolean, nullable: true),
    ],
    indexes: const <IndexSchema>[
      IndexSchema(
        indexName: 'idx_friend_owner_nickname',
        fields: <String>['ownerUserID', 'nickname'],
      ),
      IndexSchema(
        indexName: 'idx_friend_nickname_text',
        fields: <String>['nickname'],
        type: IndexType.text,
      ),
      IndexSchema(
        indexName: 'idx_friend_remark_text',
        fields: <String>['remark'],
        type: IndexType.text,
      ),
    ],
  );

  /// 本地好友申请/请求。
  ///
  /// Local friend request.
  static final TableSchema localFriendRequest = TableSchema(
    name: DbTableName.localFriendRequest,
    tableId: DbTableName.localFriendRequest,
    primaryKeyConfig: const PrimaryKeyConfig(name: 'id', type: PrimaryKeyType.none),
    fields: const <FieldSchema>[
      FieldSchema(name: 'fromUserID', type: DataType.text, nullable: false, createIndex: true),
      FieldSchema(name: 'fromNickname', type: DataType.text, nullable: true),
      FieldSchema(name: 'fromFaceURL', type: DataType.text, nullable: true),
      FieldSchema(name: 'toUserID', type: DataType.text, nullable: false, createIndex: true),
      FieldSchema(name: 'toNickname', type: DataType.text, nullable: true),
      FieldSchema(name: 'toFaceURL', type: DataType.text, nullable: true),
      FieldSchema(name: 'handleResult', type: DataType.integer, nullable: true, defaultValue: 0),
      FieldSchema(name: 'reqMsg', type: DataType.text, nullable: true),
      FieldSchema(name: 'createTime', type: DataType.integer, nullable: true),
      FieldSchema(name: 'handlerUserID', type: DataType.text, nullable: true),
      FieldSchema(name: 'handleMsg', type: DataType.text, nullable: true),
      FieldSchema(name: 'handleTime', type: DataType.integer, nullable: true),
      FieldSchema(name: 'ex', type: DataType.text, nullable: true),
    ],
    indexes: const <IndexSchema>[
      IndexSchema(
        indexName: 'idx_friend_req_to_handle',
        fields: <String>['toUserID', 'handleResult'],
      ),
    ],
  );

  /// 本地黑名单。
  ///
  /// Local blacklist.
  static final TableSchema localBlack = TableSchema(
    name: DbTableName.localBlack,
    tableId: DbTableName.localBlack,
    primaryKeyConfig: const PrimaryKeyConfig(name: 'id', type: PrimaryKeyType.none),
    fields: const <FieldSchema>[
      FieldSchema(name: 'ownerUserID', type: DataType.text, nullable: false, createIndex: true),
      FieldSchema(name: 'blockUserID', type: DataType.text, nullable: false, createIndex: true),
      FieldSchema(name: 'userID', type: DataType.text, nullable: true),
      FieldSchema(name: 'nickname', type: DataType.text, nullable: true),
      FieldSchema(name: 'faceURL', type: DataType.text, nullable: true),
      FieldSchema(name: 'gender', type: DataType.integer, nullable: true),
      FieldSchema(name: 'createTime', type: DataType.integer, nullable: true),
      FieldSchema(name: 'addSource', type: DataType.integer, nullable: true),
      FieldSchema(name: 'operatorUserID', type: DataType.text, nullable: true),
      FieldSchema(name: 'ex', type: DataType.text, nullable: true),
    ],
  );

  /// 本地群组。
  ///
  /// Local group.
  static final TableSchema localGroup = TableSchema(
    name: DbTableName.localGroup,
    tableId: DbTableName.localGroup,
    primaryKeyConfig: const PrimaryKeyConfig(name: 'groupID', type: PrimaryKeyType.none),
    fields: const <FieldSchema>[
      FieldSchema(name: 'groupName', type: DataType.text, nullable: true),
      FieldSchema(name: 'notification', type: DataType.text, nullable: true),
      FieldSchema(name: 'introduction', type: DataType.text, nullable: true),
      FieldSchema(name: 'faceURL', type: DataType.text, nullable: true),
      FieldSchema(name: 'ownerUserID', type: DataType.text, nullable: true, createIndex: true),
      FieldSchema(name: 'createTime', type: DataType.integer, nullable: true),
      FieldSchema(name: 'memberCount', type: DataType.integer, nullable: true),
      FieldSchema(name: 'status', type: DataType.integer, nullable: true),
      FieldSchema(name: 'creatorUserID', type: DataType.text, nullable: true),
      FieldSchema(name: 'groupType', type: DataType.integer, nullable: true),
      FieldSchema(name: 'ex', type: DataType.text, nullable: true),
      FieldSchema(name: 'needVerification', type: DataType.integer, nullable: true),
      FieldSchema(name: 'lookMemberInfo', type: DataType.integer, nullable: true),
      FieldSchema(name: 'applyMemberFriend', type: DataType.integer, nullable: true),
      FieldSchema(name: 'notificationUpdateTime', type: DataType.integer, nullable: true),
      FieldSchema(name: 'notificationUserID', type: DataType.text, nullable: true),
    ],
    indexes: const <IndexSchema>[
      IndexSchema(
        indexName: 'idx_group_name_text',
        fields: <String>['groupName'],
        type: IndexType.text,
      ),
    ],
  );

  /// 本地群组成员。
  ///
  /// Local group member.
  static final TableSchema localGroupMember = TableSchema(
    name: DbTableName.localGroupMember,
    tableId: DbTableName.localGroupMember,
    primaryKeyConfig: const PrimaryKeyConfig(name: 'id', type: PrimaryKeyType.none),
    fields: const <FieldSchema>[
      FieldSchema(name: 'groupID', type: DataType.text, nullable: false, createIndex: true),
      FieldSchema(name: 'userID', type: DataType.text, nullable: false, createIndex: true),
      FieldSchema(name: 'nickname', type: DataType.text, nullable: true),
      FieldSchema(name: 'faceURL', type: DataType.text, nullable: true),
      FieldSchema(name: 'roleLevel', type: DataType.integer, nullable: true),
      FieldSchema(name: 'joinTime', type: DataType.integer, nullable: true),
      FieldSchema(name: 'joinSource', type: DataType.integer, nullable: true),
      FieldSchema(name: 'operatorUserID', type: DataType.text, nullable: true),
      FieldSchema(name: 'ex', type: DataType.text, nullable: true),
      FieldSchema(name: 'muteEndTime', type: DataType.integer, nullable: true),
      FieldSchema(name: 'appMangerLevel', type: DataType.integer, nullable: true),
      FieldSchema(name: 'inviterUserID', type: DataType.text, nullable: true),
    ],
    indexes: const <IndexSchema>[
      IndexSchema(indexName: 'idx_gm_group_role', fields: <String>['groupID', 'roleLevel']),
      IndexSchema(indexName: 'idx_gm_user_role', fields: <String>['userID', 'roleLevel']),
      IndexSchema(indexName: 'idx_gm_group_join_time', fields: <String>['groupID', 'joinTime']),
    ],
  );

  /// 本地群组申请/请求。
  ///
  /// Local group request.
  static final TableSchema localGroupRequest = TableSchema(
    name: DbTableName.localGroupRequest,
    tableId: DbTableName.localGroupRequest,
    primaryKeyConfig: const PrimaryKeyConfig(name: 'id', type: PrimaryKeyType.none),
    fields: const <FieldSchema>[
      FieldSchema(name: 'groupID', type: DataType.text, nullable: false, createIndex: true),
      FieldSchema(name: 'groupName', type: DataType.text, nullable: true),
      FieldSchema(name: 'notification', type: DataType.text, nullable: true),
      FieldSchema(name: 'introduction', type: DataType.text, nullable: true),
      FieldSchema(name: 'groupFaceURL', type: DataType.text, nullable: true),
      FieldSchema(name: 'createTime', type: DataType.integer, nullable: true),
      FieldSchema(name: 'status', type: DataType.integer, nullable: true),
      FieldSchema(name: 'creatorUserID', type: DataType.text, nullable: true),
      FieldSchema(name: 'groupType', type: DataType.integer, nullable: true),
      FieldSchema(name: 'ownerUserID', type: DataType.text, nullable: true),
      FieldSchema(name: 'memberCount', type: DataType.integer, nullable: true),
      FieldSchema(name: 'userID', type: DataType.text, nullable: true, createIndex: true),
      FieldSchema(name: 'nickname', type: DataType.text, nullable: true),
      FieldSchema(name: 'userFaceURL', type: DataType.text, nullable: true),
      FieldSchema(name: 'gender', type: DataType.integer, nullable: true),
      FieldSchema(name: 'handleResult', type: DataType.integer, nullable: true, defaultValue: 0),
      FieldSchema(name: 'reqMsg', type: DataType.text, nullable: true),
      FieldSchema(name: 'handledMsg', type: DataType.text, nullable: true),
      FieldSchema(name: 'reqTime', type: DataType.integer, nullable: true),
      FieldSchema(name: 'handleUserID', type: DataType.text, nullable: true),
      FieldSchema(name: 'handledTime', type: DataType.integer, nullable: true),
      FieldSchema(name: 'ex', type: DataType.text, nullable: true),
      FieldSchema(name: 'joinSource', type: DataType.integer, nullable: true),
      FieldSchema(name: 'inviterUserID', type: DataType.text, nullable: true),
    ],
    indexes: const <IndexSchema>[
      IndexSchema(
        indexName: 'idx_group_req_group_handle',
        fields: <String>['groupID', 'handleResult'],
      ),
    ],
  );

  /// 本地会话。
  ///
  /// Local conversation.
  static final TableSchema localConversation = TableSchema(
    name: DbTableName.localConversation,
    tableId: DbTableName.localConversation,
    primaryKeyConfig: const PrimaryKeyConfig(name: 'conversationID', type: PrimaryKeyType.none),
    fields: const <FieldSchema>[
      FieldSchema(name: 'conversationType', type: DataType.integer, nullable: true),
      FieldSchema(name: 'userID', type: DataType.text, nullable: true, createIndex: true),
      FieldSchema(name: 'groupID', type: DataType.text, nullable: true, createIndex: true),
      FieldSchema(name: 'showName', type: DataType.text, nullable: true),
      FieldSchema(name: 'faceURL', type: DataType.text, nullable: true),
      FieldSchema(name: 'recvMsgOpt', type: DataType.integer, nullable: true),
      FieldSchema(
        name: 'unreadCount',
        type: DataType.integer,
        nullable: true,
        defaultValue: 0,
        createIndex: true,
      ),
      FieldSchema(name: 'latestMsg', type: DataType.text, nullable: true),
      FieldSchema(
        name: 'latestMsgSendTime',
        type: DataType.integer,
        nullable: true,
        defaultValue: 0,
        createIndex: true,
      ),
      FieldSchema(name: 'draftText', type: DataType.text, nullable: true),
      FieldSchema(name: 'draftTextTime', type: DataType.integer, nullable: true, defaultValue: 0),
      FieldSchema(name: 'isPinned', type: DataType.boolean, nullable: true, defaultValue: false),
      FieldSchema(
        name: 'isPrivateChat',
        type: DataType.boolean,
        nullable: true,
        defaultValue: false,
      ),
      FieldSchema(name: 'burnDuration', type: DataType.integer, nullable: true),
      FieldSchema(
        name: 'isMsgDestruct',
        type: DataType.boolean,
        nullable: true,
        defaultValue: false,
      ),
      FieldSchema(name: 'msgDestructTime', type: DataType.integer, nullable: true),
      FieldSchema(name: 'ex', type: DataType.text, nullable: true),
      FieldSchema(
        name: 'isNotInGroup',
        type: DataType.boolean,
        nullable: true,
        defaultValue: false,
      ),
      FieldSchema(name: 'groupAtType', type: DataType.integer, nullable: true),
      FieldSchema(name: 'maxSeq', type: DataType.integer, nullable: true, defaultValue: 0),
      FieldSchema(name: 'minSeq', type: DataType.integer, nullable: true, defaultValue: 0),
      FieldSchema(name: 'hasReadSeq', type: DataType.integer, nullable: true, defaultValue: 0),
    ],
    indexes: const <IndexSchema>[
      IndexSchema(
        indexName: 'idx_conv_pinned_time',
        fields: <String>['isPinned', 'latestMsgSendTime'],
      ),
      IndexSchema(
        indexName: 'idx_conv_show_name_text',
        fields: <String>['showName'],
        type: IndexType.text,
      ),
    ],
  );

  /// 本地ChatLog。
  ///
  /// Local chat log.
  static final TableSchema localChatLog = TableSchema(
    name: DbTableName.localChatLog,
    tableId: DbTableName.localChatLog,
    primaryKeyConfig: const PrimaryKeyConfig(name: 'clientMsgID', type: PrimaryKeyType.none),
    fields: const <FieldSchema>[
      FieldSchema(name: 'serverMsgID', type: DataType.text, nullable: true),
      FieldSchema(name: 'sendID', type: DataType.text, nullable: true, createIndex: true),
      FieldSchema(name: 'recvID', type: DataType.text, nullable: true),
      FieldSchema(name: 'senderPlatformID', type: DataType.integer, nullable: true),
      FieldSchema(name: 'senderNickname', type: DataType.text, nullable: true),
      FieldSchema(name: 'senderFaceUrl', type: DataType.text, nullable: true),
      FieldSchema(name: 'groupID', type: DataType.text, nullable: true),
      FieldSchema(name: 'sessionType', type: DataType.integer, nullable: true),
      FieldSchema(name: 'msgFrom', type: DataType.integer, nullable: true),
      FieldSchema(name: 'contentType', type: DataType.integer, nullable: true),
      FieldSchema(name: 'content', type: DataType.text, nullable: true),
      FieldSchema(name: 'isRead', type: DataType.boolean, nullable: false, defaultValue: false),
      FieldSchema(name: 'status', type: DataType.integer, nullable: true),
      FieldSchema(name: 'seq', type: DataType.integer, nullable: true, defaultValue: 0),
      FieldSchema(name: 'sendTime', type: DataType.integer, nullable: true),
      FieldSchema(name: 'createTime', type: DataType.integer, nullable: true),
      FieldSchema(name: 'attachedInfo', type: DataType.text, nullable: true),
      FieldSchema(name: 'ex', type: DataType.text, nullable: true),
      FieldSchema(name: 'localEx', type: DataType.text, nullable: true),
      FieldSchema(name: 'isReact', type: DataType.boolean, nullable: true, defaultValue: false),
      FieldSchema(
        name: 'isExternalExtensions',
        type: DataType.boolean,
        nullable: true,
        defaultValue: false,
      ),
      FieldSchema(name: 'hasReadTime', type: DataType.integer, nullable: true),
      FieldSchema(name: 'conversationID', type: DataType.text, nullable: true, createIndex: true),
    ],
    indexes: const <IndexSchema>[
      IndexSchema(
        indexName: 'idx_chat_conv_time_seq',
        fields: <String>['conversationID', 'sendTime', 'seq'],
      ),
      IndexSchema(indexName: 'idx_chat_conv_seq', fields: <String>['conversationID', 'seq']),
      IndexSchema(indexName: 'idx_chat_conv_status', fields: <String>['conversationID', 'status']),
      IndexSchema(indexName: 'idx_chat_conv_read', fields: <String>['conversationID', 'isRead']),
      IndexSchema(
        indexName: 'idx_chat_content_text',
        fields: <String>['content'],
        type: IndexType.text,
      ),
    ],
  );

  /// 本地Sending消息。
  ///
  /// Local sending message.
  static final TableSchema localSendingMessage = TableSchema(
    name: DbTableName.localSendingMessage,
    tableId: DbTableName.localSendingMessage,
    primaryKeyConfig: const PrimaryKeyConfig(name: 'clientMsgID', type: PrimaryKeyType.none),
    fields: const <FieldSchema>[
      FieldSchema(name: 'conversationID', type: DataType.text, nullable: false, createIndex: true),
      FieldSchema(name: 'ex', type: DataType.text, nullable: true),
    ],
  );

  /// 本地朋友圈动态。
  ///
  /// Local moment.
  static final TableSchema localMoment = TableSchema(
    name: DbTableName.localMoment,
    tableId: DbTableName.localMoment,
    primaryKeyConfig: const PrimaryKeyConfig(name: 'momentID', type: PrimaryKeyType.none),
    fields: const <FieldSchema>[
      FieldSchema(name: 'userID', type: DataType.text, nullable: false),
      FieldSchema(name: 'content', type: DataType.text, nullable: true),
      FieldSchema(name: 'media', type: DataType.text, nullable: true),
      FieldSchema(name: 'visibleType', type: DataType.integer, nullable: true),
      FieldSchema(name: 'visibleGroupIDs', type: DataType.text, nullable: true),
      FieldSchema(name: 'status', type: DataType.integer, nullable: true),
      FieldSchema(name: 'createTime', type: DataType.text, nullable: true, createIndex: true),
      FieldSchema(name: 'updateTime', type: DataType.text, nullable: true),
      FieldSchema(name: 'likeCount', type: DataType.integer, nullable: true),
      FieldSchema(name: 'commentCount', type: DataType.integer, nullable: true),
      FieldSchema(name: 'extra', type: DataType.text, nullable: true),
      FieldSchema(name: 'likes', type: DataType.array, nullable: true),
      FieldSchema(name: 'comments', type: DataType.array, nullable: true),
    ],
    indexes: const <IndexSchema>[
      IndexSchema(indexName: 'idx_moment_user_time', fields: <String>['userID', 'createTime']),
    ],
  );

  /// 本地收藏。
  ///
  /// Local favorite.
  static final TableSchema localFavorite = TableSchema(
    name: DbTableName.localFavorite,
    tableId: DbTableName.localFavorite,
    primaryKeyConfig: const PrimaryKeyConfig(name: 'favoriteID', type: PrimaryKeyType.none),
    fields: const <FieldSchema>[
      FieldSchema(name: 'userID', type: DataType.text, nullable: false),
      FieldSchema(name: 'targetType', type: DataType.text, nullable: false),
      FieldSchema(name: 'targetID', type: DataType.text, nullable: false),
      FieldSchema(name: 'data', type: DataType.text, nullable: true),
      FieldSchema(name: 'createTime', type: DataType.integer, nullable: true),
    ],
    indexes: const <IndexSchema>[
      IndexSchema(indexName: 'idx_favorite_user_time', fields: <String>['userID', 'createTime']),
      IndexSchema(
        indexName: 'idx_favorite_target',
        fields: <String>['userID', 'targetType', 'targetID'],
        unique: true,
      ),
    ],
  );

  /// 本地上传。
  ///
  /// Local upload.
  static final TableSchema localUpload = TableSchema(
    name: DbTableName.localUpload,
    tableId: DbTableName.localUpload,
    primaryKeyConfig: const PrimaryKeyConfig(name: 'uploadID', type: PrimaryKeyType.none),
    fields: const <FieldSchema>[
      FieldSchema(name: 'hash', type: DataType.text, nullable: true),
      FieldSchema(name: 'name', type: DataType.text, nullable: true),
      FieldSchema(name: 'fileSize', type: DataType.integer, nullable: true),
      FieldSchema(name: 'partSize', type: DataType.integer, nullable: true),
      FieldSchema(name: 'partNum', type: DataType.integer, nullable: true),
      FieldSchema(name: 'uploadedParts', type: DataType.array, nullable: true),
      FieldSchema(name: 'updateTime', type: DataType.integer, nullable: true),
    ],
    indexes: const <IndexSchema>[
      IndexSchema(indexName: 'idx_upload_hash_name', fields: <String>['hash', 'name']),
    ],
  );

  /// 本地版本同步。
  ///
  /// Local version sync.
  static final TableSchema localVersionSync = TableSchema(
    name: DbTableName.localVersionSync,
    tableId: DbTableName.localVersionSync,
    primaryKeyConfig: const PrimaryKeyConfig(name: 'id', type: PrimaryKeyType.none),
    fields: const <FieldSchema>[
      FieldSchema(name: 'tableName', type: DataType.text, nullable: false),
      FieldSchema(name: 'entityID', type: DataType.text, nullable: false),
      FieldSchema(name: 'versionID', type: DataType.text, nullable: true),
      FieldSchema(name: 'version', type: DataType.integer, nullable: true),
      FieldSchema(name: 'uidList', type: DataType.array, nullable: true),
      FieldSchema(name: 'updateTime', type: DataType.integer, nullable: true),
    ],
  );

  /// 本地通知序列号。
  ///
  /// Local notification sequence number.
  static final TableSchema localNotificationSeq = TableSchema(
    name: DbTableName.localNotificationSeq,
    tableId: DbTableName.localNotificationSeq,
    primaryKeyConfig: const PrimaryKeyConfig(name: 'conversationID', type: PrimaryKeyType.none),
    fields: const <FieldSchema>[
      FieldSchema(name: 'seq', type: DataType.integer, nullable: false, defaultValue: 0),
      FieldSchema(name: 'updateTime', type: DataType.integer, nullable: true),
    ],
  );

  /// 本地已领取红包。
  ///
  /// Local grabbed red packet.
  static final TableSchema localGrabbedRedPacket = TableSchema(
    name: DbTableName.localGrabbedRedPacket,
    tableId: DbTableName.localGrabbedRedPacket,
    primaryKeyConfig: const PrimaryKeyConfig(name: 'packetID', type: PrimaryKeyType.none),
    fields: const <FieldSchema>[
      FieldSchema(name: 'grabTime', type: DataType.integer, nullable: false),
    ],
  );

  /// 全部表结构列表。
  ///
  /// All schemas.
  static List<TableSchema> get allSchemas => <TableSchema>[
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
    localUpload,
    localVersionSync,
    localNotificationSeq,
    localGrabbedRedPacket,
  ];
}

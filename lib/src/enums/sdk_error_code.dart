/// OpenIM SDK 客户端与服务端错误码枚举。
///
/// OpenIM SDK client-side and server-side error code enum.
enum SDKErrorCode {
  /// 初始化数据库失败 / Failed to initialize the local database.
  initializedDatabaseError(1, '初始化数据库失败，请根据报错日志解决。'),

  /// SDK 初始化失败 / Failed to initialize the SDK.
  initializedError(2, '初始化失败，请根据报错日志解决。'),

  /// SDK 配置错误 / Invalid SDK configuration.
  configError(3, '配置错误，请根据报错日志解决。'),

  /// 登录失败 / Login failed.
  loginError(4, '登录失败，请根据报错日志解决。'),

  /// WebSocket 未连接 / WebSocket is not connected.
  websocketNotConnected(5, 'Websocket 未连接，请根据报错日志解决。'),

  /// 网络请求错误 / Network request error.
  networkRequestError(10000, 'Network Request Error'),

  /// 网络等待超时 / Network waiting timeout error.
  networkWaitTimeoutError(10001, 'Network Waiting Timeout Error'),

  /// 参数错误 / Invalid parameter error.
  parameterError(10002, 'Parameter Error'),

  /// 上下文超时（通常因用户已登出） / Context timeout error, usually when the user has logged out.
  contextTimeoutError(10003, 'Context Timeout Error, usually when the user has already logged out'),

  /// 资源尚未加载完成（通常未初始化或登录未完成） / Resources not loaded yet (uninitialized or login incomplete).
  resourceNotLoaded(
    10004,
    'Resources not loaded completely, usually uninitialized or login has not completed',
  ),

  /// 未知错误 / Unknown error.
  unknownError(10005, 'Unknown Error, check the error message for details'),

  /// SDK 内部错误 / SDK internal error.
  sdkInternalError(10006, 'SDK Internal Error, check the error message for details'),

  /// 对方已设置拒绝被添加好友 / This user has disabled friend requests.
  refuseToAddFriends(10013, 'This user has set not to be added'),

  /// 用户不存在或未注册 / User does not exist or is not registered.
  userNotExistOrNotRegistered(10100, 'User does not exist or is not registered'),

  /// 用户已登出 / User has already logged out.
  userHasLoggedOut(10101, 'User has already logged out'),

  /// 重复登录 / Duplicate login attempt.
  repeatLogin(
    10102,
    'User is attempting to log in again, check the login status to avoid duplicate logins',
  ),

  /// 待上传文件不存在 / Upload file does not exist.
  uploadFileNotExist(10200, 'The file to upload does not exist'),

  /// 消息解压失败 / Message decompression failed.
  messageDecompressionFailed(10201, 'Message decompression failed'),

  /// 消息解码失败 / Message decoding failed.
  messageDecodingFailed(10202, 'Message decoding failed'),

  /// 不支持的长连接二进制协议 / Unsupported long-connection binary protocol.
  unsupportedLongConnection(10203, 'Unsupported long connection binary protocol'),

  /// 消息重复发送 / Message sent multiple times.
  messageRepeated(10204, 'Message sent multiple times'),

  /// 不支持的消息内容类型 / Unsupported message content type.
  messageContentTypeNotSupported(10205, 'Message content type not supported'),

  /// 不支持的会话操作 / Unsupported session operation.
  unsupportedSessionOperation(10301, 'Unsupported session operation'),

  /// 群组 ID 不存在 / Group ID does not exist.
  groupIDNotExist(10400, 'Group ID does not exist'),

  /// 群组类型错误 / Incorrect group type.
  wrongGroupType(10401, 'Group type is incorrect'),

  /// 服务端内部错误 / Server internal error.
  serverInternalError(500, 'Server Internal Error, usually an internal network error'),

  /// 服务端参数错误 / Server-side parameter error.
  serverParameterError(
    1001,
    'Parameter Error on the server, check if body and header parameters are correct',
  ),

  /// 权限不足 / Insufficient permissions.
  insufficientPermissions(1002, 'Insufficient Permissions'),

  /// 数据库主键冲突 / Duplicate database primary key.
  duplicateDatabasePrimaryKey(1003, 'Duplicate Database Primary Key'),

  /// 数据库记录不存在 / Database record not found.
  databaseRecordNotFound(1004, 'Database Record Not Found'),

  /// 用户 ID 不存在 / User ID does not exist.
  userIDNotExist(1101, 'User ID does not exist'),

  /// 用户已注册 / User is already registered.
  userAlreadyRegistered(1102, 'User is already registered'),

  /// 群组不存在 / Group does not exist.
  groupNotExist(1201, 'Group does not exist'),

  /// 群组已存在 / Group already exists.
  groupAlreadyExists(1202, 'Group already exists'),

  /// 用户不在该群中 / User is not in the group.
  userIsNotInGroup(1203, 'User is not in the group'),

  /// 群组已解散 / Group has been disbanded.
  groupDisbanded(1204, 'Group has been disbanded'),

  /// 入群申请已处理 / Group application has already been processed.
  groupApplicationHasBeenProcessed(1206, 'Group application has already been processed'),

  /// 不能添加自己为好友 / Cannot add yourself as a friend.
  notAddMyselfAsAFriend(1301, 'Cannot add yourself as a friend'),

  /// 已被对方拉黑 / You have been blocked by the other party.
  hasBeenBlocked(1302, 'You have been blocked by the other party'),

  /// 对方不是您的好友 / The other party is not your friend.
  notFriend(1303, 'The other party is not your friend'),

  /// 已是好友关系 / Already in a friend relationship.
  alreadyAFriendRelationship(1304, 'Already in a friend relationship'),

  /// 消息已读功能已关闭 / Message read receipt feature is disabled.
  messageReadFunctionIsTurnedOff(1401, 'Message read function is turned off'),

  /// 您在群内已被禁言 / You have been muted in the group.
  youHaveBeenBanned(1402, 'You have been banned from speaking in the group'),

  /// 该群已开启全体禁言 / The group is currently all-muted.
  groupHasBeenBanned(1403, 'The group has been banned from posting'),

  /// 该消息已被撤回 / This message has been retracted.
  messageHasBeenRetracted(1404, 'This message has been retracted'),

  /// 授权已过期 / License has expired.
  licenseExpired(1405, 'Authorization has expired'),

  /// Token 已过期 / Token has expired.
  tokenHasExpired(1501, 'Token has expired'),

  /// Token 无效 / Invalid token.
  tokenInvalid(1502, 'Invalid token'),

  /// Token 格式错误 / Malformed token format.
  tokenFormatError(1503, 'Token format error'),

  /// Token 尚未生效 / Token is not yet valid.
  tokenHasNotYetTakenEffect(1504, 'Token has not yet taken effect'),

  /// 未知 Token 错误 / Unknown token error.
  unknownTokenError(1505, 'Unknown token error'),

  /// 被踢下线的 Token 已失效 / Token invalidated due to being kicked offline.
  theKickedOutTokenIsInvalid(1506, 'The kicked-out token is invalid'),

  /// Token 不存在 / Token does not exist.
  tokenNotExist(1507, 'Token does not exist'),

  /// 网关连接数达到上限 / Number of connections exceeds gateway limit.
  connectionsExceedsMaximumLimit(1601, 'Number of Connections Exceeds Maximum Limit'),

  /// 握手参数错误 / WebSocket handshake parameter error.
  handshakeParameterError(1602, 'Handshake Parameter Error'),

  /// 文件上传凭证已过期 / File upload session has expired.
  fileUploadExpired(1701, 'File Upload Expired'),

  /// 账号或密码错误 / Incorrect account or password.
  passwordError(20001, 'Password error'),

  /// 账号未注册 / Account is not registered.
  accountNotRegistered(20002, 'Account not registered'),

  /// IP 已被封禁 / IP address is banned.
  ipBanned(20003, 'IP banned');

  /// 创建错误码枚举值。
  ///
  /// Creates an [SDKErrorCode] with numeric [code] and default [message].
  ///
  /// - [code] 整数错误码 / Numeric error code.
  /// - [message] 默认错误描述 / Default error description.
  const SDKErrorCode(this.code, this.message);

  /// 整数错误码 / Numeric error code.
  final int code;

  /// 默认错误描述 / Default error message.
  final String message;
}

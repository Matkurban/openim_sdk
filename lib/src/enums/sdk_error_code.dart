/// SDK Error Codes
enum SDKErrorCode {
  /// Network Request Error
  networkRequestError(10000, 'Network Request Error'),

  /// Network Waiting Timeout Error
  networkWaitTimeoutError(10001, 'Network Waiting Timeout Error'),

  /// Parameter Error
  parameterError(10002, 'Parameter Error'),

  /// Context Timeout Error, usually when the user has already logged out
  contextTimeoutError(10003, 'Context Timeout Error, usually when the user has already logged out'),

  /// Resources not loaded completely, usually uninitialized or login hasn\'t completed
  resourceNotLoaded(
    10004,
    'Resources not loaded completely, usually uninitialized or login has not completed',
  ),

  /// Unknown Error, check the error message for details
  unknownError(10005, 'Unknown Error, check the error message for details'),

  /// SDK Internal Error, check the error message for details
  sdkInternalError(10006, 'SDK Internal Error, check the error message for details'),

  /// This user has set not to be added
  refuseToAddFriends(10013, 'This user has set not to be added'),

  /// User does not exist or is not registered
  userNotExistOrNotRegistered(10100, 'User does not exist or is not registered'),

  /// User has already logged out
  userHasLoggedOut(10101, 'User has already logged out'),

  /// User is attempting to log in again, check the login status to avoid duplicate logins
  repeatLogin(
    10102,
    'User is attempting to log in again, check the login status to avoid duplicate logins',
  ),

  /// The file to upload does not exist
  uploadFileNotExist(10200, 'The file to upload does not exist'),

  /// Message decompression failed
  messageDecompressionFailed(10201, 'Message decompression failed'),

  /// Message decoding failed
  messageDecodingFailed(10202, 'Message decoding failed'),

  /// Unsupported long connection binary protocol
  unsupportedLongConnection(10203, 'Unsupported long connection binary protocol'),

  /// Message sent multiple times
  messageRepeated(10204, 'Message sent multiple times'),

  /// Message content type not supported
  messageContentTypeNotSupported(10205, 'Message content type not supported'),

  /// Unsupported session operation
  unsupportedSessionOperation(10301, 'Unsupported session operation'),

  /// Group ID does not exist
  groupIDNotExist(10400, 'Group ID does not exist'),

  /// Group type is incorrect
  wrongGroupType(10401, 'Group type is incorrect'),

  /// Server Internal Error, usually an internal network error, check if server nodes are running correctly
  serverInternalError(500, 'Server Internal Error, usually an internal network error'),

  /// Parameter Error on the server, check if body and header parameters are correct
  serverParameterError(
    1001,
    'Parameter Error on the server, check if body and header parameters are correct',
  ),

  /// Insufficient Permissions, typically when the token in the header is incorrect or when trying to perform unauthorized actions
  insufficientPermissions(1002, 'Insufficient Permissions'),

  /// Duplicate Database Primary Key
  duplicateDatabasePrimaryKey(1003, 'Duplicate Database Primary Key'),

  /// Database Record Not Found
  databaseRecordNotFound(1004, 'Database Record Not Found'),

  /// User ID does not exist
  userIDNotExist(1101, 'User ID does not exist'),

  /// User is already registered
  userAlreadyRegistered(1102, 'User is already registered'),

  /// Group does not exist
  groupNotExist(1201, 'Group does not exist'),

  /// Group already exists
  groupAlreadyExists(1202, 'Group already exists'),

  /// User is not in the group
  userIsNotInGroup(1203, 'User is not in the group'),

  /// Group has been disbanded
  groupDisbanded(1204, 'Group has been disbanded'),

  /// Group application has already been processed, no need to process it again
  groupApplicationHasBeenProcessed(1206, 'Group application has already been processed'),

  /// Cannot add yourself as a friend
  notAddMyselfAsAFriend(1301, 'Cannot add yourself as a friend'),

  /// You have been blocked by the other party
  hasBeenBlocked(1302, 'You have been blocked by the other party'),

  /// The other party is not your friend
  notFriend(1303, 'The other party is not your friend'),

  /// Already in a friend relationship, no need to reapply
  alreadyAFriendRelationship(1304, 'Already in a friend relationship'),

  /// Message read function is turned off
  messageReadFunctionIsTurnedOff(1401, 'Message read function is turned off'),

  /// You have been banned from speaking in the group
  youHaveBeenBanned(1402, 'You have been banned from speaking in the group'),

  /// The group has been banned from posting
  groupHasBeenBanned(1403, 'The group has been banned from posting'),

  /// This message has been retracted
  messageHasBeenRetracted(1404, 'This message has been retracted'),

  /// Authorization has expired
  licenseExpired(1405, 'Authorization has expired'),

  /// Token has expired
  tokenHasExpired(1501, 'Token has expired'),

  /// Invalid token
  tokenInvalid(1502, 'Invalid token'),

  /// Token format error
  tokenFormatError(1503, 'Token format error'),

  /// Token has not yet taken effect
  tokenHasNotYetTakenEffect(1504, 'Token has not yet taken effect'),

  /// Unknown token error
  unknownTokenError(1505, 'Unknown token error'),

  /// The kicked-out token is invalid
  theKickedOutTokenIsInvalid(1506, 'The kicked-out token is invalid'),

  /// Token does not exist
  tokenNotExist(1507, 'Token does not exist'),

  /// Number of Connections Exceeds Gateway\'s Maximum Limit
  connectionsExceedsMaximumLimit(1601, 'Number of Connections Exceeds Maximum Limit'),

  /// Handshake Parameter Error
  handshakeParameterError(1602, 'Handshake Parameter Error'),

  /// File Upload Expired
  fileUploadExpired(1701, 'File Upload Expired');

  const SDKErrorCode(this.code, this.message);

  final int code;

  final String message;
}

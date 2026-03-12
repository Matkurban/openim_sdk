import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:openim_sdk/src/config/instance_name.dart';
import 'package:openim_sdk/src/services/database_service.dart';
import 'package:openim_sdk/src/services/im_api_service.dart';

/// 用户管理器
/// 对应 open-im-sdk-flutter 中 UserManager。
/// 负责用户信息的获取、修改、缓存和监听回调。
class UserManager {
  static final Logger _log = Logger('UserManager');

  ImApiService get _api =>
      GetIt.instance.get<ImApiService>(instanceName: InstanceName.imApiService);
  DatabaseService get _db => GetIt.instance.get<DatabaseService>();

  /// 用户信息变更监听器
  OnUserListener? listener;

  /// 设置用户监听器
  void setUserListener(OnUserListener listener) {
    this.listener = listener;
  }

  // ---------------------------------------------------------------------------
  // 登录相关
  // ---------------------------------------------------------------------------

  /// 使用邮箱登录
  Future<void> loginByEmail({required String email, required String password}) async {
    final resp = await _api.login(email: email, password: password);
    if (resp.errCode != 0) {
      throw Exception('登录失败: ${resp.errMsg}');
    }
    _log.info('邮箱登录成功: $email');
  }

  /// 使用手机号登录
  Future<void> loginByPhone({
    required String areaCode,
    required String phoneNumber,
    required String password,
  }) async {
    final resp = await _api.login(areaCode: areaCode, phoneNumber: phoneNumber, password: password);
    if (resp.errCode != 0) {
      throw Exception('登录失败: ${resp.errMsg}');
    }
    _log.info('手机号登录成功: $areaCode$phoneNumber');
  }

  // ---------------------------------------------------------------------------
  // 用户信息操作
  // ---------------------------------------------------------------------------

  /// 获取用户信息
  /// [userIDList] 用户ID列表
  Future<List<UserInfo>> getUsersInfo({required List<String> userIDList}) async {
    final dataList = await _db.getUsersByIDs(userIDList);
    return dataList.map((d) => UserInfo.fromJson(d)).toList();
  }

  /// 获取当前登录用户信息
  Future<UserInfo?> getSelfUserInfo() async {
    final data = await _db.getLoginUser();
    if (data == null) return null;
    return UserInfo.fromJson(data);
  }

  /// 修改当前登录用户信息
  /// [nickname] 昵称
  /// [faceURL] 头像
  /// [globalRecvMsgOpt] 全局消息接收选项
  /// [ex] 扩展字段
  Future<void> setSelfInfo({
    String? nickname,
    String? faceURL,
    int? globalRecvMsgOpt,
    String? ex,
  }) async {
    final updateData = <String, dynamic>{};
    if (nickname != null) updateData['nickname'] = nickname;
    if (faceURL != null) updateData['faceURL'] = faceURL;
    if (globalRecvMsgOpt != null) updateData['globalRecvMsgOpt'] = globalRecvMsgOpt;
    if (ex != null) updateData['ex'] = ex;

    if (updateData.isEmpty) return;

    // 获取当前用户信息并合并更新
    final current = await _db.getLoginUser();
    if (current != null) {
      await _db.insertOrUpdateUser({...current, ...updateData});
    }

    _log.info('用户信息已更新');

    // 触发监听回调
    final updated = await getSelfUserInfo();
    if (updated != null) {
      listener?.selfInfoUpdated(updated);
    }

    // TODO: 同步到服务器
  }

  /// 订阅用户在线状态
  /// [userIDs] 用户ID列表
  Future<List<UserStatusInfo>> subscribeUsersStatus(List<String> userIDs) async {
    // TODO: 通过服务器订阅用户状态
    _log.info('订阅用户状态: $userIDs');
    return [];
  }

  /// 取消订阅用户在线状态
  /// [userIDs] 用户ID列表
  Future<void> unsubscribeUsersStatus(List<String> userIDs) async {
    // TODO: 通过服务器取消订阅
    _log.info('取消订阅用户状态: $userIDs');
  }

  /// 获取已订阅用户的在线状态
  Future<List<UserStatusInfo>> getSubscribeUsersStatus() async {
    // TODO: 从服务器获取已订阅用户的状态
    return [];
  }

  /// 获取用户在线状态
  /// [userIDs] 用户ID列表
  Future<List<UserStatusInfo>> getUserStatus(List<String> userIDs) async {
    // TODO: 从服务器查询用户在线状态
    return [];
  }

  // ---------------------------------------------------------------------------
  // 本地数据操作
  // ---------------------------------------------------------------------------

  /// 将用户信息保存到本地数据库
  Future<void> saveUserToLocal(UserInfo userInfo) async {
    final data = userInfo.toJson()..removeWhere((_, v) => v == null);
    await _db.insertOrUpdateUser(data);
  }

  /// 批量将用户信息保存到本地数据库
  Future<void> batchSaveUsersToLocal(List<UserInfo> users) async {
    for (final user in users) {
      await saveUserToLocal(user);
    }
  }

  /// 通知用户状态变更（供内部调用）
  void notifyUserStatusChanged(UserStatusInfo statusInfo) {
    listener?.userStatusChanged(statusInfo);
  }
}

import 'package:tostore/tostore.dart';

import '../../core/base_repository.dart';
import '../../models/user_info.dart';
import '../db_schema.dart';

/// 本地用户信息仓储（`local_users`）。
final class UserRepository extends BaseRepository<UserInfo> {
  String _currentUserID = '';

  /// 创建 `UserRepository` 实例。
  ///
  /// Creates a `UserRepository` instance.
  ///
  /// - [store] 存储 / Store.
  UserRepository({required super.store})
    : super(tableName: DbTableName.localUser, primaryKeyName: 'userID', name: 'UserRepository');

  /// 设置Current用户ID。
  ///
  /// Set current user ID.
  ///
  /// - [userID] 用户ID / User ID.
  void setCurrentUserID(String userID) {
    _currentUserID = userID;
  }

  /// 从行数据。
  ///
  /// From row.
  ///
  /// - [row] 行数据 / Row.
  /// - Returns: `UserInfo` 结果 / Resulting `UserInfo`.
  @override
  UserInfo fromRow(Map<String, dynamic> row) => UserInfo.fromJson(row);

  /// 写入或更新用户。
  ///
  /// Upsert user.
  ///
  /// - [userData] 用户数据 / User data.
  /// - Returns: `Future<DbResult>` 结果 / Resulting `Future<DbResult>`.
  Future<DbResult> upsertUser(Map<String, dynamic> userData) => upsertRow(userData);

  /// 写入或更新用户列表。
  ///
  /// Upsert users.
  ///
  /// - [users] 用户列表 / Users.
  /// - Returns: `Future<DbResult>` 结果 / Resulting `Future<DbResult>`.
  Future<DbResult> upsertUsers(List<Map<String, dynamic>> users) => batchUpsertRows(users);

  /// 获取登录用户。
  ///
  /// Get login user.
  ///
  /// - Returns: `Future<UserInfo?>` 结果 / Resulting `Future<UserInfo?>`.
  Future<UserInfo?> getLoginUser() {
    if (_currentUserID.isEmpty) {
      return Future<UserInfo?>.value(null);
    }
    return findByPrimaryKey(_currentUserID);
  }

  /// 获取用户列表ByID 列表。
  ///
  /// Get users by i ds.
  ///
  /// - [userIDs] 用户ID 列表 / User i ds.
  /// - Returns: `Future<List<UserInfo>>` 列表结果 / Resulting `Future<List<UserInfo>>` list.
  Future<List<UserInfo>> getUsersByIDs(List<String> userIDs) => findByPrimaryKeys(userIDs);
}

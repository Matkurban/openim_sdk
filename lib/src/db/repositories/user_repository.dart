import 'package:tostore/tostore.dart';

import '../../core/base_repository.dart';
import '../../models/user_info.dart';
import '../db_schema.dart';

/// 本地用户信息仓储（`local_users`）。
final class UserRepository extends BaseRepository<UserInfo> {
  String _currentUserID = '';

  UserRepository({required super.store})
    : super(tableName: DbTableName.localUser, primaryKeyName: 'userID', name: 'UserRepository');

  void setCurrentUserID(String userID) {
    _currentUserID = userID;
  }

  @override
  UserInfo fromRow(Map<String, dynamic> row) => UserInfo.fromJson(row);

  Future<DbResult> upsertUser(Map<String, dynamic> userData) => upsertRow(userData);

  Future<DbResult> upsertUsers(List<Map<String, dynamic>> users) => batchUpsertRows(users);

  Future<UserInfo?> getLoginUser() {
    if (_currentUserID.isEmpty) {
      return Future<UserInfo?>.value(null);
    }
    return findByPrimaryKey(_currentUserID);
  }

  Future<List<UserInfo>> getUsersByIDs(List<String> userIDs) => findByPrimaryKeys(userIDs);
}

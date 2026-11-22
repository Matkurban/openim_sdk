import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:tostore/tostore.dart';

/// 初始化配置。
///
/// Initialize configuration.
class InitConfig extends Equatable {
  /// 平台ID。
  ///
  /// Platform ID.
  final int? platformID;

  /// APIAddr。
  ///
  /// API addr.
  final String apiAddr;

  /// WebSocketAddr。
  ///
  /// WebSocket addr.
  final String wsAddr;

  /// 认证Addr。
  ///
  /// Authentication addr.
  final String? authAddr;

  /// 管理员Addr。
  ///
  /// Administrator addr.
  final String? adminAddr;

  /// 数据库路径。
  ///
  /// Database path.
  final String? dbPath;

  /// 数据库名称。
  ///
  /// Database name.
  final String? dbName;

  /// 表结构列表。
  ///
  /// Schemas.
  final List<TableSchema> schemas;

  /// 创建 `InitConfig` 实例。
  ///
  /// Creates a `InitConfig` instance.
  ///
  /// - [platformID] 平台ID / Platform ID.
  /// - [apiAddr] APIAddr / API addr.
  /// - [wsAddr] WebSocketAddr / WebSocket addr.
  /// - [authAddr] 认证Addr / Authentication addr.
  /// - [adminAddr] 管理员Addr / Administrator addr.
  /// - [dbPath] 数据库路径 / Database path.
  /// - [dbName] 数据库名称 / Database name.
  /// - [schemas] 表结构列表 / Schemas.
  const InitConfig({
    this.platformID,
    required this.apiAddr,
    required this.wsAddr,
    this.authAddr,
    this.adminAddr,
    this.dbPath,
    this.dbName,
    this.schemas = const <TableSchema>[],
  });

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[
    platformID,
    apiAddr,
    wsAddr,
    authAddr,
    adminAddr,
    dbPath,
    dbName,
    schemas,
  ];

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'platformID': platformID,
    'apiAddr': apiAddr,
    'wsAddr': wsAddr,
    'authAddr': authAddr,
    'adminAddr': adminAddr,
    'dbPath': dbPath,
    'dbName': dbName,
    'schemas': schemas,
  };

  /// 返回对象的可读字符串表示。
  ///
  /// Returns a human-readable string representation.
  ///
  /// - Returns: 字符串结果 / String result.
  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

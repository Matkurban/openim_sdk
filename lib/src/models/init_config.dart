import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:tostore/tostore.dart';

class InitConfig extends Equatable {
  final int? platformID;
  final String apiAddr;
  final String wsAddr;
  final String? authAddr;
  final String? adminAddr;
  final String? dbPath;
  final String? dbName;
  final List<TableSchema> schemas;

  const InitConfig({
    this.platformID,
    required this.apiAddr,
    required this.wsAddr,
    this.authAddr,
    this.adminAddr,
    this.dbPath,
    this.dbName,
    this.schemas = const [],
  });

  @override
  List<Object?> get props => [
    platformID,
    apiAddr,
    wsAddr,
    authAddr,
    adminAddr,
    dbPath,
    dbName,
    schemas,
  ];

  Map<String, dynamic> toJson() => {
    'platformID': platformID,
    'apiAddr': apiAddr,
    'wsAddr': wsAddr,
    'authAddr': authAddr,
    'adminAddr': adminAddr,
    'dbPath': dbPath,
    'dbName': dbName,
    'schemas': schemas,
  };

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

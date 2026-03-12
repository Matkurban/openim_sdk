import 'package:equatable/equatable.dart';
import 'package:logging/logging.dart';
import 'package:tostore/tostore.dart';

class InitConfig extends Equatable {
  final int? platformID;
  final String apiAddr;
  final String wsAddr;
  final String? dbPath;
  final String? dbName;
  final List<TableSchema> schemas;
  final Level logLevel;

  const InitConfig({
    this.platformID,
    required this.apiAddr,
    required this.wsAddr,
    this.dbPath,
    this.dbName,
    this.schemas = const [],
    this.logLevel = Level.ALL,
  });

  @override
  List<Object?> get props => [platformID, apiAddr, wsAddr, dbPath, dbName, schemas, logLevel];

  Map<String, dynamic> toJson() => {
    'platformID': platformID,
    'apiAddr': apiAddr,
    'wsAddr': wsAddr,
    'dbPath': dbPath,
    'dbName': dbName,
    'schemas': schemas,
    'logLevel': logLevel.name,
  };
}

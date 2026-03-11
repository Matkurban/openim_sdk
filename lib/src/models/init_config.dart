import 'package:equatable/equatable.dart';
import 'package:logging/logging.dart';

class InitConfig extends Equatable {
  final int? platformID;
  final String apiAddr;
  final String wsAddr;
  final String? dataDir;
  final Level logLevel;

  const InitConfig({
    this.platformID,
    required this.apiAddr,
    required this.wsAddr,
    this.dataDir,
    this.logLevel = Level.ALL,
  });

  @override
  List<Object?> get props => [platformID, apiAddr, wsAddr, dataDir, logLevel];

  Map<String, dynamic> toJson() => {
    'platformID': platformID,
    'apiAddr': apiAddr,
    'wsAddr': wsAddr,
    'dataDir': dataDir,
    'logLevel': logLevel.name,
  };
}

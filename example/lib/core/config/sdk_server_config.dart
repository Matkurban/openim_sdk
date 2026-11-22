/// SDK 服务端连接配置（默认指向本机回环地址，可在登录页与设置页随时修改）。
///
/// SDK server endpoint configuration (defaults to local loopback host, editable in UI).
class SdkServerConfig {
  /// 默认主机地址。
  static const String defaultHost = 'localhost';

  /// 默认 API 地址。
  static const String defaultApiAddr = 'http://$defaultHost:10002';

  /// 默认 WebSocket 地址。
  static const String defaultWsAddr = 'ws://$defaultHost:10001';

  /// 默认鉴权服务地址。
  static const String defaultAuthAddr = 'http://$defaultHost:10008';

  /// 默认管理后台地址。
  static const String defaultAdminAddr = 'http://$defaultHost:10009';

  /// OpenIM API 地址。
  final String apiAddr;

  /// OpenIM WebSocket 地址。
  final String wsAddr;

  /// OpenIM 鉴权服务地址。
  final String authAddr;

  /// OpenIM 管理后台地址（可选）。
  final String adminAddr;

  /// 创建服务端配置实例。
  const SdkServerConfig({
    this.apiAddr = defaultApiAddr,
    this.wsAddr = defaultWsAddr,
    this.authAddr = defaultAuthAddr,
    this.adminAddr = defaultAdminAddr,
  });

  /// 从键值映射反序列化配置。
  factory SdkServerConfig.fromMap(Map<String, dynamic> map) {
    final String? api = map['apiAddr'] as String?;
    final String? ws = map['wsAddr'] as String?;
    final String? auth = map['authAddr'] as String?;
    final String? admin = map['adminAddr'] as String?;
    return SdkServerConfig(
      apiAddr: api != null && api.trim().isNotEmpty
          ? api.trim()
          : defaultApiAddr,
      wsAddr: ws != null && ws.trim().isNotEmpty ? ws.trim() : defaultWsAddr,
      authAddr: auth != null && auth.trim().isNotEmpty
          ? auth.trim()
          : defaultAuthAddr,
      adminAddr: admin != null && admin.trim().isNotEmpty
          ? admin.trim()
          : defaultAdminAddr,
    );
  }

  /// 序列化为键值映射。
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'apiAddr': apiAddr,
      'wsAddr': wsAddr,
      'authAddr': authAddr,
      'adminAddr': adminAddr,
    };
  }

  /// 复制并覆盖指定字段。
  SdkServerConfig copyWith({
    String? apiAddr,
    String? wsAddr,
    String? authAddr,
    String? adminAddr,
  }) {
    return SdkServerConfig(
      apiAddr: apiAddr ?? this.apiAddr,
      wsAddr: wsAddr ?? this.wsAddr,
      authAddr: authAddr ?? this.authAddr,
      adminAddr: adminAddr ?? this.adminAddr,
    );
  }
}

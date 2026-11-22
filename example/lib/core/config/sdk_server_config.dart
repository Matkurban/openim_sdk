/// SDK 服务端连接配置：智能检测 IP、域名、HTTP/HTTPS 与自定义端口并推导四端地址。
///
/// Smart SDK server configuration auto-detecting IP vs. domain and HTTP vs. HTTPS/WSS.
class SdkServerConfig {
  /// 默认主机。
  static const String defaultHost = 'localhost';

  static final RegExp _ipv4Pattern = RegExp(r'^(\d{1,3}\.){3}\d{1,3}$');

  /// 原始输入主机（如 `localhost`、`im.example.com`、`https://im.example.com`、`192.168.1.10`）。
  final String host;

  /// OpenIM API 地址。
  final String apiAddr;

  /// OpenIM WebSocket 地址。
  final String wsAddr;

  /// OpenIM 鉴权 / Chat 地址。
  final String authAddr;

  /// OpenIM 管理后台地址。
  final String adminAddr;

  /// 创建服务端配置实例。
  const SdkServerConfig({
    this.host = defaultHost,
    this.apiAddr = 'http://$defaultHost:10002',
    this.wsAddr = 'ws://$defaultHost:10001',
    this.authAddr = 'http://$defaultHost:10008',
    this.adminAddr = 'http://$defaultHost:10009',
  });

  /// 根据用户输入的 `rawHost`（支持 IP、域名、`http://`、`https://`、带端口）自动检测并生成四端地址。
  factory SdkServerConfig.fromHost(String rawHost) {
    final String trimmed = rawHost.trim();
    if (trimmed.isEmpty) {
      return const SdkServerConfig();
    }

    final bool hasScheme =
        trimmed.startsWith('http://') ||
        trimmed.startsWith('https://') ||
        trimmed.startsWith('ws://') ||
        trimmed.startsWith('wss://');
    final Uri? parsed = Uri.tryParse(hasScheme ? trimmed : 'http://$trimmed');
    if (parsed == null || parsed.host.isEmpty) {
      return const SdkServerConfig();
    }

    final String cleanHost = parsed.host;
    final bool isLocalOrIp =
        cleanHost == 'localhost' ||
        _ipv4Pattern.hasMatch(cleanHost) ||
        cleanHost.contains(':');

    final bool useTls =
        trimmed.startsWith('https://') ||
        trimmed.startsWith('wss://') ||
        (!hasScheme && !isLocalOrIp);

    final String httpScheme = useTls ? 'https' : 'http';
    final String wsScheme = useTls ? 'wss' : 'ws';

    // IP / localhost 使用标准四端口直连；域名或 HTTPS 使用标准反向代理路径前缀
    if (isLocalOrIp && !useTls) {
      return SdkServerConfig(
        host: trimmed,
        apiAddr: '$httpScheme://$cleanHost:10002',
        wsAddr: '$wsScheme://$cleanHost:10001',
        authAddr: '$httpScheme://$cleanHost:10008',
        adminAddr: '$httpScheme://$cleanHost:10009',
      );
    }

    final String portSuffix = parsed.hasPort ? ':${parsed.port}' : '';
    final String authority = '$cleanHost$portSuffix';
    return SdkServerConfig(
      host: trimmed,
      apiAddr: '$httpScheme://$authority/api',
      wsAddr: '$wsScheme://$authority/msg_gateway',
      authAddr: '$httpScheme://$authority/chat',
      adminAddr: '$httpScheme://$authority/admin',
    );
  }

  /// 从持久化键值映射恢复配置。
  factory SdkServerConfig.fromMap(Map<String, dynamic> map) {
    final String savedHost = (map['host'] as String?)?.trim() ?? defaultHost;
    final SdkServerConfig fallback = SdkServerConfig.fromHost(savedHost);
    final String? api = map['apiAddr'] as String?;
    final String? ws = map['wsAddr'] as String?;
    final String? auth = map['authAddr'] as String?;
    final String? admin = map['adminAddr'] as String?;
    return SdkServerConfig(
      host: savedHost,
      apiAddr: api != null && api.trim().isNotEmpty
          ? api.trim()
          : fallback.apiAddr,
      wsAddr: ws != null && ws.trim().isNotEmpty ? ws.trim() : fallback.wsAddr,
      authAddr: auth != null && auth.trim().isNotEmpty
          ? auth.trim()
          : fallback.authAddr,
      adminAddr: admin != null && admin.trim().isNotEmpty
          ? admin.trim()
          : fallback.adminAddr,
    );
  }

  /// 序列化为键值映射。
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'host': host,
      'apiAddr': apiAddr,
      'wsAddr': wsAddr,
      'authAddr': authAddr,
      'adminAddr': adminAddr,
    };
  }
}

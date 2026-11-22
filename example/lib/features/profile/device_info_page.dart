import 'package:material_ui/material_ui.dart';
import 'package:xue_hua_device_info/xue_hua_device_info.dart';

import '../../core/utils/date_time_formatter.dart';

/// 设备信息页（完整展示 `xue_hua_device_info` 设备/电池/网络/存储/显示五大维度信息）。
///
/// Device information page displaying all 5 `xue_hua_device_info` subsystems.
class DeviceInfoPage extends StatefulWidget {
  /// 创建设备信息页。
  const DeviceInfoPage({super.key});

  @override
  State<DeviceInfoPage> createState() => _DeviceInfoPageState();
}

class _DeviceInfoPageState extends State<DeviceInfoPage> {
  DeviceInfo? _device;
  BatteryInfo? _battery;
  NetworkInfo? _network;
  StorageInfo? _storage;
  DisplayInfo? _display;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final DeviceInfo device = await XueHuaDeviceInfo.getDeviceInfo();
      final BatteryInfo battery = await XueHuaDeviceInfo.getBatteryInfo();
      final NetworkInfo network = await XueHuaDeviceInfo.getNetworkInfo();
      final StorageInfo storage = await XueHuaDeviceInfo.getStorageInfo();
      final DisplayInfo display = await XueHuaDeviceInfo.getDisplayInfo();
      if (mounted) {
        setState(() {
          _device = device;
          _battery = battery;
          _network = network;
          _storage = storage;
          _display = display;
        });
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('设备信息')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.all(14),
                children: <Widget>[
                  _InfoSectionCard(
                    title: '设备标识与系统',
                    rows: <(String, String)>[
                      ('设备名称', _device?.name ?? '-'),
                      ('型号', _device?.model ?? '-'),
                      ('品牌 / 厂商', _device?.manufacturer ?? '-'),
                      ('系统名称', _device?.operatingSystem ?? '-'),
                      ('系统版本', _device?.osVersion ?? '-'),
                      ('设备 ID', _device?.deviceId ?? '-'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _InfoSectionCard(
                    title: '电池状态',
                    rows: <(String, String)>[
                      (
                        '电量',
                        _battery?.level != null ? '${_battery!.level}%' : '-',
                      ),
                      ('充电状态', _battery?.chargingState.name ?? '-'),
                      ('健康状态', _battery?.healthStatus.name ?? '-'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _InfoSectionCard(
                    title: '网络状态',
                    rows: <(String, String)>[
                      ('连接类型', _network?.connectionType.name ?? '-'),
                      (
                        '是否联网',
                        (_network?.isConnected ?? false) ? '已连接' : '未连接',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _InfoSectionCard(
                    title: '存储空间',
                    rows: <(String, String)>[
                      (
                        '总容量',
                        _storage != null
                            ? DateTimeFormatter.formatBytes(
                                _storage!.totalBytes,
                              )
                            : '-',
                      ),
                      (
                        '可用容量',
                        _storage != null
                            ? DateTimeFormatter.formatBytes(_storage!.freeBytes)
                            : '-',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _InfoSectionCard(
                    title: '屏幕显示',
                    rows: <(String, String)>[
                      (
                        '分辨率',
                        '${_display?.width ?? 0} × ${_display?.height ?? 0}',
                      ),
                      (
                        '刷新率',
                        _display?.refreshRate != null
                            ? '${_display!.refreshRate!.toStringAsFixed(0)} Hz'
                            : '-',
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}

class _InfoSectionCard extends StatelessWidget {
  final String title;
  final List<(String, String)> rows;

  const _InfoSectionCard({required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const Divider(height: 16),
            for (final (String k, String v) in rows)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 110,
                      child: Text(
                        k,
                        style: TextStyle(color: Theme.of(context).hintColor),
                      ),
                    ),
                    Expanded(child: Text(v)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

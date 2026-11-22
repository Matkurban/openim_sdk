import 'package:material_ui/material_ui.dart';
import 'package:signal_wire/signal_wire.dart';
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
  late final Signal<DeviceInfo?> _device = signal<DeviceInfo?>(null);
  late final Signal<BatteryInfo?> _battery = signal<BatteryInfo?>(null);
  late final Signal<NetworkInfo?> _network = signal<NetworkInfo?>(null);
  late final Signal<StorageInfo?> _storage = signal<StorageInfo?>(null);
  late final Signal<DisplayInfo?> _display = signal<DisplayInfo?>(null);
  late final Signal<bool> _loading = signal<bool>(true);

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
        batch(() {
          _device.value = device;
          _battery.value = battery;
          _network.value = network;
          _storage.value = storage;
          _display.value = display;
        });
      }
    } finally {
      if (mounted) {
        _loading.value = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('设备信息')),
      body: SignalBuilder(
        builder: (BuildContext _) {
          if (_loading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          final DeviceInfo? device = _device.value;
          final BatteryInfo? battery = _battery.value;
          final NetworkInfo? network = _network.value;
          final StorageInfo? storage = _storage.value;
          final DisplayInfo? display = _display.value;

          return RefreshIndicator(
            onRefresh: _load,
            child: ListView(
              padding: const EdgeInsets.all(14),
              children: <Widget>[
                _InfoSectionCard(
                  title: '设备标识与系统',
                  rows: <(String, String)>[
                    ('设备名称', device?.name ?? '-'),
                    ('型号', device?.model ?? '-'),
                    ('品牌 / 厂商', device?.manufacturer ?? '-'),
                    ('系统名称', device?.operatingSystem ?? '-'),
                    ('系统版本', device?.osVersion ?? '-'),
                    ('设备 ID', device?.deviceId ?? '-'),
                  ],
                ),
                const SizedBox(height: 12),
                _InfoSectionCard(
                  title: '电池状态',
                  rows: <(String, String)>[
                    ('电量', battery?.level != null ? '${battery!.level}%' : '-'),
                    ('充电状态', battery?.chargingState.name ?? '-'),
                    ('健康状态', battery?.healthStatus.name ?? '-'),
                  ],
                ),
                const SizedBox(height: 12),
                _InfoSectionCard(
                  title: '网络状态',
                  rows: <(String, String)>[
                    ('连接类型', network?.connectionType.name ?? '-'),
                    ('是否联网', (network?.isConnected ?? false) ? '已连接' : '未连接'),
                  ],
                ),
                const SizedBox(height: 12),
                _InfoSectionCard(
                  title: '存储空间',
                  rows: <(String, String)>[
                    (
                      '总容量',
                      storage != null
                          ? DateTimeFormatter.formatBytes(storage.totalBytes)
                          : '-',
                    ),
                    (
                      '可用容量',
                      storage != null
                          ? DateTimeFormatter.formatBytes(storage.freeBytes)
                          : '-',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _InfoSectionCard(
                  title: '屏幕显示',
                  rows: <(String, String)>[
                    ('分辨率', '${display?.width ?? 0} × ${display?.height ?? 0}'),
                    (
                      '刷新率',
                      display?.refreshRate != null
                          ? '${display!.refreshRate!.toStringAsFixed(0)} Hz'
                          : '-',
                    ),
                  ],
                ),
              ],
            ),
          );
        },
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

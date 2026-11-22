import 'package:material_ui/material_ui.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';

/// 发送位置选择页（返回 `{description, latitude, longitude}`）。
///
/// Location picker page returning description and coordinates for location messages.
class LocationPickerPage extends StatefulWidget {
  /// 创建位置选择页。
  const LocationPickerPage({super.key});

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  final TextEditingController _descController = TextEditingController(
    text: '北京市朝阳区望京 SOHO',
  );
  final TextEditingController _latController = TextEditingController(
    text: '39.996420',
  );
  final TextEditingController _lngController = TextEditingController(
    text: '116.480881',
  );

  @override
  void dispose() {
    _descController.dispose();
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  void _confirm() {
    final double lat = double.tryParse(_latController.text.trim()) ?? 39.99642;
    final double lng = double.tryParse(_lngController.text.trim()) ?? 116.48088;
    AdaptiveRouter.of(context).pop(<String, Object>{
      'description': _descController.text.trim(),
      'latitude': lat,
      'longitude': lng,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('选择位置'),
        actions: <Widget>[
          TextButton(onPressed: _confirm, child: const Text('发送')),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          TextField(
            controller: _descController,
            decoration: const InputDecoration(
              labelText: '位置名称 / 详细地址',
              prefixIcon: Icon(Icons.place_outlined),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _latController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: '纬度 (Latitude)'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _lngController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: '经度 (Longitude)'),
          ),
        ],
      ),
    );
  }
}

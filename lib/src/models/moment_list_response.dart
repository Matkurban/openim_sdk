import 'moment_info.dart';

/// 朋友圈列表分页响应
class MomentListResponse {
  const MomentListResponse({required this.total, required this.moments});

  final int total;
  final List<MomentInfo> moments;

  factory MomentListResponse.fromJson(Map<String, dynamic> json) {
    return MomentListResponse(
      total: _toInt(json['total']) ?? 0,
      moments: _parseMoments(json['moments']),
    );
  }

  factory MomentListResponse.empty() {
    return const MomentListResponse(total: 0, moments: <MomentInfo>[]);
  }

  Map<String, dynamic> toJson() {
    return {'total': total, 'moments': moments.map((item) => item.toJson()).toList()};
  }
}

List<MomentInfo> _parseMoments(dynamic value) {
  if (value is List) {
    return value
        .whereType<Map>()
        .map((item) => MomentInfo.fromJson(item.cast<String, dynamic>()))
        .toList();
  }
  return <MomentInfo>[];
}

int? _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

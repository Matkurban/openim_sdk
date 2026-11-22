import 'package:equatable/equatable.dart';

import 'moment_info.dart';

/// 朋友圈列表分页响应
///
/// Moment list response.
class MomentListResponse extends Equatable {
  /// 创建 `MomentListResponse` 实例。
  ///
  /// Creates a `MomentListResponse` instance.
  ///
  /// - [total] 总计 / Total.
  /// - [moments] 朋友圈动态列表 / Moments.
  const MomentListResponse({required this.total, required this.moments});

  /// 总计。
  ///
  /// Total.
  final int total;

  /// 朋友圈动态列表。
  ///
  /// Moments.
  final List<MomentInfo> moments;

  /// 从 JSON 字典反序列化实例（`MomentListResponse.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`MomentListResponse.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `MomentListResponse` 结果 / Resulting `MomentListResponse`.
  factory MomentListResponse.fromJson(Map<String, dynamic> json) {
    return MomentListResponse(
      total: _toInt(json['total']) ?? 0,
      moments: _parseMoments(json['moments']),
    );
  }

  /// empty（`MomentListResponse.empty`）。
  ///
  /// Empty (`MomentListResponse.empty`).
  ///
  /// - Returns: `MomentListResponse` 结果 / Resulting `MomentListResponse`.
  factory MomentListResponse.empty() {
    return const MomentListResponse(total: 0, moments: <MomentInfo>[]);
  }

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'total': total,
      'moments': moments.map((MomentInfo item) => item.toJson()).toList(),
    };
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[total, moments];
}

List<MomentInfo> _parseMoments(dynamic value) {
  if (value is List<dynamic>) {
    return value
        .whereType<Map<dynamic, dynamic>>()
        .map<MomentInfo>(
          (Map<dynamic, dynamic> item) => MomentInfo.fromJson(item.cast<String, dynamic>()),
        )
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

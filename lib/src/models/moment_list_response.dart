import 'package:equatable/equatable.dart';

import 'moment_info.dart';

/// 朋友圈列表分页响应。
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

  /// 创建空响应实例（`MomentListResponse.empty`）。
  ///
  /// Creates an empty response (`MomentListResponse.empty`).
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

/// 朋友圈严格时序游标分页响应（对应 `POST /moment/timeline`）。
///
/// Cursor-based chronological timeline response (`POST /moment/timeline`).
class MomentTimelineResponse extends Equatable {
  /// 创建 `MomentTimelineResponse` 实例。
  ///
  /// Creates a `MomentTimelineResponse` instance.
  ///
  /// - [moments] 按 `timelineSeq` 严格降序排列的动态列表 / Moments ordered strictly by `timelineSeq` desc.
  /// - [nextBeforeSeq] 下一页历史拉取游标 / Cursor for the next older page.
  /// - [hasMore] 是否还有更早的历史动态 / Whether older history remains.
  /// - [latestSyncSeq] 当前服务端最新同步序号 / Latest server sync sequence number.
  const MomentTimelineResponse({
    required this.moments,
    required this.nextBeforeSeq,
    required this.hasMore,
    required this.latestSyncSeq,
  });

  /// 按 `timelineSeq` 严格降序排列的动态列表。
  ///
  /// Moments ordered strictly by `timelineSeq` descending.
  final List<MomentInfo> moments;

  /// 下一页历史拉取游标。
  ///
  /// Cursor for the next older page.
  final int nextBeforeSeq;

  /// 是否还有更早的历史动态。
  ///
  /// Whether more historical moments exist.
  final bool hasMore;

  /// 当前服务端最新同步序号。
  ///
  /// Latest server sync sequence number.
  final int latestSyncSeq;

  /// 从 JSON 字典反序列化实例。
  ///
  /// Deserializes an instance from a JSON map.
  factory MomentTimelineResponse.fromJson(Map<String, dynamic> json) {
    return MomentTimelineResponse(
      moments: _parseMoments(json['moments']),
      nextBeforeSeq: _toInt(json['nextBeforeSeq']) ?? 0,
      hasMore: json['hasMore'] == true,
      latestSyncSeq: _toInt(json['latestSyncSeq']) ?? 0,
    );
  }

  /// 创建空时间线响应实例。
  ///
  /// Creates an empty timeline response.
  factory MomentTimelineResponse.empty() {
    return const MomentTimelineResponse(
      moments: <MomentInfo>[],
      nextBeforeSeq: 0,
      hasMore: false,
      latestSyncSeq: 0,
    );
  }

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'moments': moments.map((MomentInfo item) => item.toJson()).toList(),
      'nextBeforeSeq': nextBeforeSeq,
      'hasMore': hasMore,
      'latestSyncSeq': latestSyncSeq,
    };
  }

  @override
  List<Object?> get props => <Object?>[moments, nextBeforeSeq, hasMore, latestSyncSeq];
}

/// 朋友圈增量同步响应（对应 `POST /moment/sync`）。
///
/// Incremental sync response (`POST /moment/sync`).
class MomentSyncResponse extends Equatable {
  /// 创建 `MomentSyncResponse` 实例。
  ///
  /// Creates a `MomentSyncResponse` instance.
  ///
  /// - [latestSyncSeq] 本次同步推进到的最新序号 / Latest sync sequence reached.
  /// - [needFullRefresh] 是否需要以本次 `upserts` 重建本地窗口缓存 / Whether to rebuild local cache window.
  /// - [hasMore] 是否还有后续增量批次待拉取 / Whether more incremental batches remain.
  /// - [upserts] 新增或发生互动更新的动态列表 / Created or updated moments.
  /// - [deletedMomentIDs] 需从本地删除的动态ID 列表 / Moment IDs deleted on server.
  const MomentSyncResponse({
    required this.latestSyncSeq,
    required this.needFullRefresh,
    required this.hasMore,
    required this.upserts,
    required this.deletedMomentIDs,
  });

  /// 本次同步推进到的最新序号。
  ///
  /// Latest sync sequence number reached.
  final int latestSyncSeq;

  /// 是否需要重建本地缓存窗口（如首次同步或跨度过大）。
  ///
  /// Whether the client should replace its local cache window.
  final bool needFullRefresh;

  /// 是否还有后续增量批次待拉取。
  ///
  /// Whether additional incremental batches remain.
  final bool hasMore;

  /// 新增或发生更新的动态列表。
  ///
  /// Created or updated moments.
  final List<MomentInfo> upserts;

  /// 需从本地缓存移除的动态ID 列表。
  ///
  /// Moment IDs to remove from local cache.
  final List<String> deletedMomentIDs;

  /// 从 JSON 字典反序列化实例。
  ///
  /// Deserializes an instance from a JSON map.
  factory MomentSyncResponse.fromJson(Map<String, dynamic> json) {
    return MomentSyncResponse(
      latestSyncSeq: _toInt(json['latestSyncSeq']) ?? 0,
      needFullRefresh: json['needFullRefresh'] == true,
      hasMore: json['hasMore'] == true,
      upserts: _parseMoments(json['upserts']),
      deletedMomentIDs: _parseStringList(json['deletedMomentIDs']),
    );
  }

  /// 创建空同步响应实例。
  ///
  /// Creates an empty sync response.
  factory MomentSyncResponse.empty() {
    return const MomentSyncResponse(
      latestSyncSeq: 0,
      needFullRefresh: false,
      hasMore: false,
      upserts: <MomentInfo>[],
      deletedMomentIDs: <String>[],
    );
  }

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'latestSyncSeq': latestSyncSeq,
      'needFullRefresh': needFullRefresh,
      'hasMore': hasMore,
      'upserts': upserts.map((MomentInfo item) => item.toJson()).toList(),
      'deletedMomentIDs': deletedMomentIDs,
    };
  }

  @override
  List<Object?> get props => <Object?>[
    latestSyncSeq,
    needFullRefresh,
    hasMore,
    upserts,
    deletedMomentIDs,
  ];
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

List<String> _parseStringList(dynamic value) {
  if (value is List<dynamic>) {
    return value.map<String>((dynamic item) => item.toString()).toList();
  }
  return <String>[];
}

int? _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

import 'package:equatable/equatable.dart';

import '../enums/visible_type.dart';
import 'moment_media.dart';

/// 发布朋友圈请求
class MomentCreateReq extends Equatable {
  const MomentCreateReq({
    required this.content,
    this.media = const <MomentMedia>[],
    required this.visibleType,
    this.visibleGroupIDs = const <String>[],
    this.extra = '',
  });

  final String content;
  final List<MomentMedia> media;
  final VisibleType visibleType;
  final List<String> visibleGroupIDs;
  final String extra;

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      if (media.isNotEmpty) 'media': media.map((m) => m.toJson()).toList(),
      'visibleType': visibleType.value,
      if (visibleGroupIDs.isNotEmpty) 'visibleGroupIDs': visibleGroupIDs,
      'extra': extra,
    };
  }

  factory MomentCreateReq.fromJson(Map<String, dynamic> json) {
    return MomentCreateReq(
      content: json['content'] as String? ?? '',
      media:
          (json['media'] as List?)
              ?.map((e) => MomentMedia.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      visibleType: VisibleType.values.firstWhere(
        (v) => v.value == (json['visibleType'] as int? ?? 1),
        orElse: () => VisibleType.friend,
      ),
      visibleGroupIDs: (json['visibleGroupIDs'] as List?)?.cast<String>() ?? const [],
      extra: json['extra'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [content, media, visibleType, visibleGroupIDs, extra];
}

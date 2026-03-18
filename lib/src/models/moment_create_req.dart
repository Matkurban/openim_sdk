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

  @override
  List<Object?> get props => [content, media, visibleType, visibleGroupIDs, extra];
}

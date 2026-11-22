import 'dart:convert';

import '../config/api_url.dart';
import '../core/base_api_client.dart';
import '../models/api_response.dart';

/// 消息收发、撤回、已读与 seq 拉取 API 客户端。
final class MessageApi extends BaseApiClient {
  MessageApi({required super.httpClient}) : super(name: 'MessageApi');

  Future<ApiResponse> sendMsg({required Map<String, dynamic> msgData}) {
    return postIm(ImApiUrl.sendMsg, data: msgData);
  }

  Future<ApiResponse> revokeMsg({
    required String userID,
    required String conversationID,
    required int seq,
  }) {
    return postIm(
      ImApiUrl.revokeMsg,
      data: <String, dynamic>{'userID': userID, 'conversationID': conversationID, 'seq': seq},
    );
  }

  Future<ApiResponse> markMsgsAsRead({
    required String userID,
    required String conversationID,
    required List<int> seqs,
  }) {
    return postIm(
      ImApiUrl.markMsgsAsRead,
      data: <String, dynamic>{'userID': userID, 'conversationID': conversationID, 'seqs': seqs},
    );
  }

  Future<ApiResponse> markConversationAsRead({
    required String userID,
    required String conversationID,
    required int hasReadSeq,
    List<int>? seqs,
  }) {
    return postIm(
      ImApiUrl.markConversationAsRead,
      data: <String, dynamic>{
        'userID': userID,
        'conversationID': conversationID,
        'hasReadSeq': hasReadSeq,
        'seqs': ?seqs,
      },
    );
  }

  Future<ApiResponse> deleteMsgs({
    required String userID,
    required String conversationID,
    required List<int> seqs,
  }) {
    return postIm(
      ImApiUrl.deleteMsgs,
      data: <String, dynamic>{'userID': userID, 'conversationID': conversationID, 'seqs': seqs},
    );
  }

  Future<ApiResponse> clearConversationMsg({
    required String userID,
    required List<String> conversationIDs,
  }) {
    return postIm(
      ImApiUrl.clearConversationMsg,
      data: <String, dynamic>{'userID': userID, 'conversationIDs': conversationIDs},
    );
  }

  Future<ApiResponse> clearAllMsg({required String userID}) {
    return postIm(ImApiUrl.clearAllMsg, data: <String, dynamic>{'userID': userID});
  }

  Future<ApiResponse> getConversationsHasReadAndMaxSeq({
    required String userID,
    required List<String> conversationIDs,
  }) {
    return postIm(
      ImApiUrl.getConversationsHasReadAndMaxSeq,
      data: <String, dynamic>{'userID': userID, 'conversationIDs': conversationIDs},
    );
  }

  Future<ApiResponse> pullMsgBySeqs({
    required String userID,
    required List<Map<String, dynamic>> seqRanges,
    int order = 0,
  }) async {
    final ApiResponse resp = await postIm(
      ImApiUrl.pullMsgBySeqs,
      data: <String, dynamic>{'userID': userID, 'seqRanges': seqRanges, 'order': order},
    );
    if (resp.errCode == 0 && resp.data is Map<String, dynamic>) {
      _decodePullMsgsContent(resp.data as Map<String, dynamic>);
    }
    return resp;
  }

  Future<ApiResponse> getServerTime() {
    return postIm(ImApiUrl.getServerTime);
  }

  /// 将 protojson 自动 base64 编码的 `content` 解码为原始 JSON 字符串。
  void _decodePullMsgsContent(Map<String, dynamic> data) {
    for (final String key in const <String>['msgs', 'notificationMsgs']) {
      final dynamic group = data[key];
      if (group is! Map<dynamic, dynamic>) {
        continue;
      }
      for (final MapEntry<dynamic, dynamic> entry in group.entries) {
        final dynamic pullMsgs = entry.value;
        if (pullMsgs is! Map<dynamic, dynamic>) {
          continue;
        }
        final dynamic msgList = pullMsgs['Msgs'] ?? pullMsgs['msgs'];
        if (msgList is! List<dynamic>) {
          continue;
        }
        for (final dynamic msg in msgList) {
          if (msg is! Map<dynamic, dynamic>) {
            continue;
          }
          final dynamic content = msg['content'];
          if (content is! String || content.isEmpty) {
            continue;
          }
          final int first = content.codeUnitAt(0);
          if (first == 0x7B || first == 0x5B) {
            continue;
          }
          try {
            msg['content'] = utf8.decode(base64Decode(content));
          } catch (_) {}
        }
      }
    }
  }
}

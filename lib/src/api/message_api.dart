import 'dart:convert';

import '../config/api_url.dart';
import '../core/base_api_client.dart';
import '../models/api_response.dart';

/// 消息收发、撤回、已读与 seq 拉取 API 客户端。
final class MessageApi extends BaseApiClient {
  /// 创建 `MessageApi` 实例。
  ///
  /// Creates a `MessageApi` instance.
  ///
  /// - [httpClient] HTTP客户端 / HTTP client.
  MessageApi({required super.httpClient}) : super(name: 'MessageApi');

  /// 发送消息。
  ///
  /// Send message.
  ///
  /// - [msgData] 消息数据 / Message data.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> sendMsg({required Map<String, dynamic> msgData}) {
    return postIm(ImApiUrl.sendMsg, data: msgData);
  }

  /// 撤回消息。
  ///
  /// Revoke message.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [conversationID] 会话ID / Conversation ID.
  /// - [seq] 序列号 / Sequence number.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
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

  /// 标记消息列表为已读。
  ///
  /// Mark messages as read.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [conversationID] 会话ID / Conversation ID.
  /// - [seqs] 序列号列表 / Sequence numbers.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
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

  /// 标记会话为已读。
  ///
  /// Mark conversation as read.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [conversationID] 会话ID / Conversation ID.
  /// - [hasReadSeq] 是否包含读取序列号 / Whether has read sequence number.
  /// - [seqs] 序列号列表 / Sequence numbers.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
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

  /// 删除消息列表。
  ///
  /// Delete messages.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [conversationID] 会话ID / Conversation ID.
  /// - [seqs] 序列号列表 / Sequence numbers.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
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

  /// 清空会话消息。
  ///
  /// Clear conversation message.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [conversationIDs] 会话ID 列表 / Conversation i ds.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> clearConversationMsg({
    required String userID,
    required List<String> conversationIDs,
  }) {
    return postIm(
      ImApiUrl.clearConversationMsg,
      data: <String, dynamic>{'userID': userID, 'conversationIDs': conversationIDs},
    );
  }

  /// 清空全部消息。
  ///
  /// Clear all message.
  ///
  /// - [userID] 用户ID / User ID.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> clearAllMsg({required String userID}) {
    return postIm(ImApiUrl.clearAllMsg, data: <String, dynamic>{'userID': userID});
  }

  /// 获取会话列表是否包含已读与最大序列号。
  ///
  /// Get conversations whether has read and maximum sequence number.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [conversationIDs] 会话ID 列表 / Conversation i ds.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> getConversationsHasReadAndMaxSeq({
    required String userID,
    required List<String> conversationIDs,
  }) {
    return postIm(
      ImApiUrl.getConversationsHasReadAndMaxSeq,
      data: <String, dynamic>{'userID': userID, 'conversationIDs': conversationIDs},
    );
  }

  /// 拉取消息按序列号列表。
  ///
  /// Pull message by sequence numbers.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [seqRanges] 序列号Ranges / Sequence number ranges.
  /// - [order] order / Order.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
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

  /// 获取服务端时间戳。
  ///
  /// Get server timestamp.
  ///
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
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

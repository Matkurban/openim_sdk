/// 笔记信息
class NoteInfo {
  const NoteInfo({
    required this.noteID,
    required this.summary,
    required this.content,
    required this.createdAt,
  });

  final String noteID;
  final String summary;
  final String content;
  final String createdAt;

  factory NoteInfo.fromJson(Map<String, dynamic> json) {
    return NoteInfo(
      noteID: json['noteID']?.toString() ?? '',
      summary: json['summary']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'noteID': noteID, 'summary': summary, 'content': content, 'createdAt': createdAt};
  }
}

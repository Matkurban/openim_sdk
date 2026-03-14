/// 朋友圈交互中的用户信息
class MomentUserInfo {
  const MomentUserInfo({required this.userID, required this.nickname, required this.faceURL});

  final String userID;
  final String nickname;
  final String faceURL;

  factory MomentUserInfo.fromJson(Map<String, dynamic> json) {
    return MomentUserInfo(
      userID: json['userID']?.toString() ?? '',
      nickname: json['nickname']?.toString() ?? '',
      faceURL: json['faceURL']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'userID': userID, 'nickname': nickname, 'faceURL': faceURL};
  }
}

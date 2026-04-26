/// 申诉验证码
class AppealCaptcha {
  final String captchaID;
  final String question;
  final String? base64Img;

  AppealCaptcha({required this.captchaID, required this.question, this.base64Img});

  factory AppealCaptcha.fromJson(Map<String, dynamic> json) => AppealCaptcha(
    captchaID: (json['captchaID'] ?? '') as String,
    question: (json['question'] ?? '') as String,
    base64Img: json['base64Img'] as String?,
  );
}

/// 创建申诉响应
class CreateAppealResp {
  final String appealID;
  final String appealToken;

  CreateAppealResp({required this.appealID, required this.appealToken});

  factory CreateAppealResp.fromJson(Map<String, dynamic> json) => CreateAppealResp(
    appealID: (json['appealID'] ?? '') as String,
    appealToken: (json['appealToken'] ?? '') as String,
  );
}

/// 申诉证据上传响应
class AppealUploadResp {
  final String url;

  AppealUploadResp({required this.url});

  factory AppealUploadResp.fromJson(Map<String, dynamic> json) =>
      AppealUploadResp(url: (json['url'] ?? '') as String);
}

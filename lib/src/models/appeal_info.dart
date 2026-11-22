/// 申诉验证码
///
/// Appeal verification code.
class AppealCaptcha {
  /// 验证码ID。
  ///
  /// Verification code ID.
  final String captchaID;

  /// question。
  ///
  /// Question.
  final String question;

  /// base64Img。
  ///
  /// Base 64 img.
  final String? base64Img;

  /// 创建 `AppealCaptcha` 实例。
  ///
  /// Creates a `AppealCaptcha` instance.
  ///
  /// - [captchaID] 验证码ID / Verification code ID.
  /// - [question] question / Question.
  /// - [base64Img] base64Img / Base 64 img.
  AppealCaptcha({required this.captchaID, required this.question, this.base64Img});

  /// 从 JSON 字典反序列化实例（`AppealCaptcha.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`AppealCaptcha.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `AppealCaptcha` 结果 / Resulting `AppealCaptcha`.
  factory AppealCaptcha.fromJson(Map<String, dynamic> json) => AppealCaptcha(
    captchaID: (json['captchaID'] ?? '') as String,
    question: (json['question'] ?? '') as String,
    base64Img: json['base64Img'] as String?,
  );
}

/// 创建申诉响应
///
/// Create appeal response.
class CreateAppealResp {
  /// 申诉ID。
  ///
  /// Appeal ID.
  final String appealID;

  /// 申诉令牌。
  ///
  /// Appeal token.
  final String appealToken;

  /// 创建 `CreateAppealResp` 实例。
  ///
  /// Creates a `CreateAppealResp` instance.
  ///
  /// - [appealID] 申诉ID / Appeal ID.
  /// - [appealToken] 申诉令牌 / Appeal token.
  CreateAppealResp({required this.appealID, required this.appealToken});

  /// 从 JSON 字典反序列化实例（`CreateAppealResp.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`CreateAppealResp.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `CreateAppealResp` 结果 / Resulting `CreateAppealResp`.
  factory CreateAppealResp.fromJson(Map<String, dynamic> json) => CreateAppealResp(
    appealID: (json['appealID'] ?? '') as String,
    appealToken: (json['appealToken'] ?? '') as String,
  );
}

/// 申诉证据上传响应
///
/// Appeal upload response.
class AppealUploadResp {
  /// URL 地址。
  ///
  /// URL.
  final String url;

  /// 创建 `AppealUploadResp` 实例。
  ///
  /// Creates a `AppealUploadResp` instance.
  ///
  /// - [url] URL 地址 / URL.
  AppealUploadResp({required this.url});

  /// 从 JSON 字典反序列化实例（`AppealUploadResp.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`AppealUploadResp.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `AppealUploadResp` 结果 / Resulting `AppealUploadResp`.
  factory AppealUploadResp.fromJson(Map<String, dynamic> json) =>
      AppealUploadResp(url: (json['url'] ?? '') as String);
}

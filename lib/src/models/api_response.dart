class ApiResponse {
  final int errCode;
  final String errMsg;
  final String errDlt;
  final dynamic data;

  ApiResponse({
    required this.errCode,
    required this.errMsg,
    required this.errDlt,
    required this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      errCode: (json['errCode'] as int?) ?? 0,
      errMsg: (json['errMsg'] as String?) ?? '',
      errDlt: (json['errDlt'] as String?) ?? '',
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'errCode': errCode, 'errMsg': errMsg, 'errDlt': errDlt, 'data': data};
  }

  bool get isSuccess => errCode == 0;
}

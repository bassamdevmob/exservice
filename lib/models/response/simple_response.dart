
class SimpleResponse {
  SimpleResponse({
    this.message,
    this.code,
  });

  String message;
  String code;

  factory SimpleResponse.fromJson(Map<String, dynamic> json) => SimpleResponse(
    message: json["message"] == null ? null : json["message"],
    code: json["code"] == null ? null : json["code"],
  );

  Map<String, dynamic> toJson() => {
    "message": message == null ? null : message,
    "code": code == null ? null : code,
  };
}

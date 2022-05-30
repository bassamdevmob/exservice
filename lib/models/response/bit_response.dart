
class BitResponse {
  BitResponse({
    this.data,
    this.message,
    this.code,
  });

  bool data;
  String message;
  String code;

  factory BitResponse.fromJson(Map<String, dynamic> json) => BitResponse(
    data: json["data"] == null ? null : json["data"],
    message: json["message"] == null ? null : json["message"],
    code: json["code"] == null ? null : json["code"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? null : data,
    "message": message == null ? null : message,
    "code": code == null ? null : code,
  };
}

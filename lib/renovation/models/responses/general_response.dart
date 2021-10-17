class GeneralResponse<T> {
  GeneralResponse({
    this.message,
    this.data,
    this.code,
  });

  String message;
  T data;
  int code;

  factory GeneralResponse.fromJson(Map<String, dynamic> json) =>
      GeneralResponse<T>(
        message: json["message"] == null ? null : json["message"],
        data: json["data"],
        code: json["code"] == null ? null : json["code"],
      );

  Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
        "data": data,
        "code": code == null ? null : code,
      };
}

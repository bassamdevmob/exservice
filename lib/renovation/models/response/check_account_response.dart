class CheckAccountResponse {
  CheckAccountResponse({
    this.data,
    this.message,
    this.code,
  });

  Data data;
  String message;
  String code;

  factory CheckAccountResponse.fromJson(Map<String, dynamic> json) => CheckAccountResponse(
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    message: json["message"] == null ? null : json["message"],
    code: json["code"] == null ? null : json["code"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? null : data.toJson(),
    "message": message == null ? null : message,
    "code": code == null ? null : code,
  };
}

class Data {
  Data({
    this.exists,
  });

  bool exists;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    exists: json["exists"] == null ? null : json["exists"],
  );

  Map<String, dynamic> toJson() => {
    "exists": exists == null ? null : exists,
  };
}

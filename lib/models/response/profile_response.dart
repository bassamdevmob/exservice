import '../entity/user.dart';

class ProfileResponse {
  ProfileResponse({
    this.data,
    this.message,
    this.code,
  });

  User data;
  String message;
  String code;

  factory ProfileResponse.fromJson(Map<String, dynamic> json) => ProfileResponse(
    data: json["data"] == null ? null : User.fromJson(json["data"]),
    message: json["message"] == null ? null : json["message"],
    code: json["code"] == null ? null : json["code"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? null : data.toJson(),
    "message": message == null ? null : message,
    "code": code == null ? null : code,
  };
}
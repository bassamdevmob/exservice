import 'package:exservice/renovation/models/common/user_model.dart';

class AuthResponse {
  AuthResponse({
    this.message,
    this.data,
    this.code,
  });

  String message;
  UserModel data;
  int code;

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : UserModel.fromJson(json["data"]),
        code: json["code"] == null ? null : json["code"],
      );

  Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
        "data": data == null ? null : data.toJson(),
        "code": code == null ? null : code,
      };
}

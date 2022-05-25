import 'package:exservice/models/entity/user.dart';

class AuthResponse {
  AuthResponse({
    this.data,
    this.message,
    this.code,
  });

  AuthModel data;
  String message;
  String code;

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
    data: json["data"] == null ? null : AuthModel.fromJson(json["data"]),
    message: json["message"] == null ? null : json["message"],
    code: json["code"] == null ? null : json["code"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? null : data.toJson(),
    "message": message == null ? null : message,
    "code": code == null ? null : code,
  };
}

class AuthModel {
  AuthModel({
    this.token,
    this.user,
  });

  String token;
  User user;

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
    token: json["token"] == null ? null : json["token"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "token": token == null ? null : token,
    "user": user == null ? null : user.toJson(),
  };
}
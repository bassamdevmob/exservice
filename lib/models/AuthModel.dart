// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

import 'common/User.dart';

AuthModel loginModelFromJson(String str) =>
    AuthModel.fromJson(json.decode(str));

String loginModelToJson(AuthModel data) => json.encode(data.toJson());

class AuthModel {
  AuthModel({
    this.message,
    this.data,
    this.code,
  });

  String message;
  User data;
  int code;

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : User.fromJson(json["data"]),
        code: json["code"] == null ? null : json["code"],
      );

  Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
        "data": data == null ? null : data.toJson(),
        "code": code == null ? null : code,
      };
}

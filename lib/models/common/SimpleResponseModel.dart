//// To parse this JSON data, do
////
////     final simpleResponseModel = simpleResponseModelFromJson(jsonString);
import 'dart:convert';

SimpleResponseModel simpleResponseModelFromJson(String str) =>
    SimpleResponseModel.fromJson(json.decode(str));

String simpleResponseModelToJson(SimpleResponseModel data) =>
    json.encode(data.toJson());

class SimpleResponseModel<T> {
  SimpleResponseModel({
    this.message,
    this.data,
    this.code,
  });

  String message;
  T data;
  int code;

  factory SimpleResponseModel.fromJson(Map<String, dynamic> json) =>
      SimpleResponseModel<T>(
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

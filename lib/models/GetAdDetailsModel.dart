// To parse this JSON data, do
//
//     final getAdDetailsModel = getAdDetailsModelFromJson(jsonString);

import 'dart:convert';

import 'common/AdModel.dart';

GetAdDetailsModel getAdDetailsModelFromJson(String str) =>
    GetAdDetailsModel.fromJson(json.decode(str));

String getAdDetailsModelToJson(GetAdDetailsModel data) =>
    json.encode(data.toJson());

class GetAdDetailsModel {
  GetAdDetailsModel({
    this.message,
    this.data,
    this.code,
  });

  String message;
  AdModel data;
  int code;

  factory GetAdDetailsModel.fromJson(Map<String, dynamic> json) =>
      GetAdDetailsModel(
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : AdModel.fromJson(json["data"]),
        code: json["code"] == null ? null : json["code"],
      );

  Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
        "data": data == null ? null : data.toJson(),
        "code": code == null ? null : code,
      };
}

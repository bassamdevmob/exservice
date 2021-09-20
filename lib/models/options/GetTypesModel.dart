// To parse this JSON data, do
//
//     final getTypesModel = getTypesModelFromJson(jsonString);

import 'dart:convert';

import 'package:exservice/models/common/User.dart';

GetTypesModel getTypesModelFromJson(String str) =>
    GetTypesModel.fromJson(json.decode(str));

String getTypesModelToJson(GetTypesModel data) => json.encode(data.toJson());

class GetTypesModel {
  GetTypesModel({
    this.message,
    this.data,
    this.code,
  });

  String message;
  List<UserType> data;
  int code;

  factory GetTypesModel.fromJson(Map<String, dynamic> json) => GetTypesModel(
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<UserType>.from(
                json["data"].map((x) => UserType.fromJson(x))),
        code: json["code"] == null ? null : json["code"],
      );

  Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toJson())),
        "code": code == null ? null : code,
      };
}

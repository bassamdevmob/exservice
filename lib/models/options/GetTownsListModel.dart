// To parse this JSON data, do
//
//     final getTownsListModel = getTownsListModelFromJson(jsonString);

import 'dart:convert';

import 'package:exservice/models/common/Town.dart';

GetTownsListModel getTownsListModelFromJson(String str) =>
    GetTownsListModel.fromJson(json.decode(str));

String getTownsListModelToJson(GetTownsListModel data) =>
    json.encode(data.toJson());

class GetTownsListModel {
  GetTownsListModel({
    this.message,
    this.data,
    this.code,
  });

  String message;
  List<Town> data;
  int code;

  factory GetTownsListModel.fromJson(Map<String, dynamic> json) =>
      GetTownsListModel(
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<Town>.from(json["data"].map((x) => Town.fromJson(x))),
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

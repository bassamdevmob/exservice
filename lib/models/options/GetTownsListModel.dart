// To parse this JSON data, do
//
//     final getTownsListModel = getTownsListModelFromJson(jsonString);

import 'dart:convert';

import 'package:exservice/renovation/models/entity/town_model.dart';

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
  List<TownModel> data;
  int code;

  factory GetTownsListModel.fromJson(Map<String, dynamic> json) =>
      GetTownsListModel(
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<TownModel>.from(json["data"].map((x) => TownModel.fromJson(x))),
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

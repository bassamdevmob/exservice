// To parse this JSON data, do
//
//     final getAdsListModel = getAdsListModelFromJson(jsonString);

import 'dart:convert';

import '../common/AdModel.dart';

GetAdsListModel getAdsListModelFromJson(String str) =>
    GetAdsListModel.fromJson(json.decode(str));

String getAdsListModelToJson(GetAdsListModel data) =>
    json.encode(data.toJson());

class GetAdsListModel {
  GetAdsListModel({
    this.message,
    this.data,
    this.code,
  });

  String message;
  List<AdModel> data;
  int code;

  factory GetAdsListModel.fromJson(Map<String, dynamic> json) =>
      GetAdsListModel(
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<AdModel>.from(json["data"].map((x) => AdModel.fromJson(x))),
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

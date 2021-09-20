// To parse this JSON data, do
//
//     final countriesListModel = countriesListModelFromJson(jsonString);

import 'dart:convert';

GetCountriesListModel countriesListModelFromJson(String str) =>
    GetCountriesListModel.fromJson(json.decode(str));

String countriesListModelToJson(GetCountriesListModel data) =>
    json.encode(data.toJson());

class GetCountriesListModel {
  GetCountriesListModel({
    this.message,
    this.data,
    this.code,
  });

  String message;
  List<Choice> data;
  int code;

  factory GetCountriesListModel.fromJson(Map<String, dynamic> json) =>
      GetCountriesListModel(
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<Choice>.from(json["data"].map((x) => Choice.fromJson(x))),
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

class Choice {
  Choice({
    this.id,
    this.name,
  });

  int id;
  String name;

  factory Choice.fromJson(Map<String, dynamic> json) => Choice(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
      };
}

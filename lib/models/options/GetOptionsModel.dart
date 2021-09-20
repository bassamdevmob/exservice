// To parse this JSON data, do
//
//     final getCarOptionModel = getCarOptionModelFromJson(jsonString);

import 'dart:convert';

GetOptionsModel getCarOptionModelFromJson(String str) =>
    GetOptionsModel.fromJson(json.decode(str));

String getCarOptionModelToJson(GetOptionsModel data) =>
    json.encode(data.toJson());

class GetOptionsModel {
  List<Option> data;
  int code;
  String message;

  GetOptionsModel({
    this.data,
    this.code,
    this.message,
  });

  factory GetOptionsModel.fromNumericalJson(Map<String, dynamic> json) =>
      GetOptionsModel(
        data: json["data"] == null
            ? null
            : List<Option>.from(
                json["data"].map((x) => Option.fromNumericalJson(x))),
        code: json["code"] == null ? null : json["code"],
        message: json["message"] == null ? null : json["message"],
      );

  factory GetOptionsModel.fromJson(Map<String, dynamic> json) =>
      GetOptionsModel(
        data: json["data"] == null
            ? null
            : List<Option>.from(json["data"].map((x) => Option.fromJson(x))),
        code: json["code"] == null ? null : json["code"],
        message: json["message"] == null ? null : json["message"],
      );

  factory GetOptionsModel.fromCategoryJson(Map<String, dynamic> json) =>
      GetOptionsModel(
        data: json["data"] == null
            ? null
            : List<Option>.from(
                json["data"].map((x) => Option.fromCategoryJson(x))),
        code: json["code"] == null ? null : json["code"],
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toJson())),
        "code": code == null ? null : code,
        "message": message == null ? null : message,
      };
}

class Option {
  Option({
    this.id,
    this.parentId,
    this.title,
    this.image,
  });

  int id;
  int parentId;
  String title;
  String image;

  factory Option.fromNumericalJson(Map<String, dynamic> json) => Option(
        id: json["id"] == null ? null : json["id"],
        parentId: json["parent_id"] == null ? null : json["parent_id"],
        title: json["value"] == null ? null : json["value"],
        image: json["image"] == null ? null : json["image"],
      );

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        id: json["id"] == null ? null : json["id"],
        parentId: json["parent_id"] == null ? null : json["parent_id"],
        title: json["title"] == null ? null : json["title"],
        image: json["image"] == null ? null : json["image"],
      );

  factory Option.fromCategoryJson(Map<String, dynamic> json) => Option(
        id: json["id"] == null ? null : json["id"],
        title: json["name"] == null ? null : json["name"],
        image: json["mobile_image"] == null ? null : json["mobile_image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "parent_id": parentId == null ? null : parentId,
        "title": title == null ? null : title,
        "image": image == null ? null : image,
      };
}

// To parse this JSON data, do
//
//     final postAdModel = postAdModelFromJson(jsonString);

import 'dart:convert';

PostAdModel postAdModelFromJson(String str) =>
    PostAdModel.fromJson(json.decode(str));

String postAdModelToJson(PostAdModel data) => json.encode(data.toJson());

class PostAdModel {
  PostAdModel({
    this.message,
    this.data,
    this.code,
  });

  String message;
  PostResult data;
  int code;

  factory PostAdModel.fromJson(Map<String, dynamic> json) => PostAdModel(
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : PostResult.fromJson(json["data"]),
        code: json["code"] == null ? null : json["code"],
      );

  Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
        "data": data == null ? null : data.toJson(),
        "code": code == null ? null : code,
      };
}

class PostResult {
  PostResult({
    this.id,
  });

  int id;

  factory PostResult.fromJson(Map<String, dynamic> json) => PostResult(
        id: json["id"] == null ? null : json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
      };
}

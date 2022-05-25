// To parse this JSON data, do
//
//     final categoriesResponse = categoriesResponseFromJson(jsonString);

import 'dart:convert';

import 'package:exservice/models/entity/category.dart';

CategoriesResponse categoriesResponseFromJson(String str) => CategoriesResponse.fromJson(json.decode(str));

String categoriesResponseToJson(CategoriesResponse data) => json.encode(data.toJson());

class CategoriesResponse {
  CategoriesResponse({
    this.data,
    this.message,
    this.code,
  });

  List<Category> data;
  String message;
  String code;

  factory CategoriesResponse.fromJson(Map<String, dynamic> json) => CategoriesResponse(
    data: json["data"] == null ? null : List<Category>.from(json["data"].map((x) => Category.fromJson(x))),
    message: json["message"] == null ? null : json["message"],
    code: json["code"] == null ? null : json["code"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message == null ? null : message,
    "code": code == null ? null : code,
  };
}
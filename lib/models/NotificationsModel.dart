// To parse this JSON data, do
//
//     final notificationsModel = notificationsModelFromJson(jsonString);

import 'dart:convert';

import 'package:exservice/renovation/models/entity/ad_model.dart';

import '../renovation/models/entity/user.dart';

NotificationsModel notificationsModelFromJson(String str) =>
    NotificationsModel.fromJson(json.decode(str));

String notificationsModelToJson(NotificationsModel data) =>
    json.encode(data.toJson());

class NotificationsModel {
  NotificationsModel({
    this.message,
    this.data,
    this.code,
  });

  String message;
  List<NotificationModel> data;
  int code;

  factory NotificationsModel.fromJson(Map<String, dynamic> json) =>
      NotificationsModel(
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<NotificationModel>.from(
                json["data"].map((x) => NotificationModel.fromJson(x))),
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

class NotificationModel {
  NotificationModel({
    this.id,
    this.userId,
    this.adId,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.ad,
  });

  int id;
  int userId;
  int adId;
  DateTime createdAt;
  DateTime updatedAt;
  User user;
  AdModel ad;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json["id"] == null ? null : json["id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        adId: json["ad_id"] == null ? null : json["ad_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        ad: json["ad"] == null ? null : AdModel.fromJson(json["ad"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "user_id": userId == null ? null : userId,
        "ad_id": adId == null ? null : adId,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "user": user == null ? null : user.toJson(),
        "ad": ad == null ? null : ad.toJson(),
      };
}

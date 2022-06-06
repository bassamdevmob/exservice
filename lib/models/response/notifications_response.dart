import 'package:exservice/models/entity/ad_model.dart';
import 'package:exservice/models/entity/user.dart';

class NotificationsResponse {
  NotificationsResponse({
    this.data,
    this.message,
    this.code,
  });

  List<NotificationModel> data;
  String message;
  String code;

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) => NotificationsResponse(
    data: json["data"] == null ? null : List<NotificationModel>.from(json["data"].map((x) => NotificationModel.fromJson(x))),
    message: json["message"] == null ? null : json["message"],
    code: json["code"] == null ? null : json["code"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message == null ? null : message,
    "code": code == null ? null : code,
  };
}

class NotificationModel {
  NotificationModel({
    this.id,
    this.date,
    this.user,
    this.ad,
  });

  int id;
  DateTime date;
  User user;
  AdBrief ad;

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    id: json["id"] == null ? null : json["id"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    ad: json["ad"] == null ? null : AdBrief.fromJson(json["ad"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "date": date == null ? null : date.toIso8601String(),
    "user": user == null ? null : user.toJson(),
    "ad": ad == null ? null : ad.toJson(),
  };
}

class AdBrief {
  AdBrief({
    this.id,
    this.title,
    this.cover,
  });

  int id;
  String title;
  Media cover;

  factory AdBrief.fromJson(Map<String, dynamic> json) => AdBrief(
    id: json["id"] == null ? null : json["id"],
    title: json["title"] == null ? null : json["title"],
    cover: json["cover"] == null ? null : Media.fromJson(json["cover"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "title": title == null ? null : title,
    "cover": cover == null ? null : cover.toJson(),
  };
}

import 'package:exservice/models/entity/meta.dart';

class NotificationsResponse {
  NotificationsResponse({
    this.meta,
    this.data,
    this.message,
    this.code,
  });

  Meta meta;
  List<NotificationModel> data;
  String message;
  String code;

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) => NotificationsResponse(
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    data: json["data"] == null ? null : List<NotificationModel>.from(json["data"].map((x) => NotificationModel.fromJson(x))),
    message: json["message"] == null ? null : json["message"],
    code: json["code"] == null ? null : json["code"],
  );

  Map<String, dynamic> toJson() => {
    "meta": meta == null ? null : meta.toJson(),
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
  UserBrief user;
  AdBrief ad;

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    id: json["id"] == null ? null : json["id"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    user: json["user"] == null ? null : UserBrief.fromJson(json["user"]),
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
  Cover cover;

  factory AdBrief.fromJson(Map<String, dynamic> json) => AdBrief(
    id: json["id"] == null ? null : json["id"],
    title: json["title"] == null ? null : json["title"],
    cover: json["cover"] == null ? null : Cover.fromJson(json["cover"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "title": title == null ? null : title,
    "cover": cover == null ? null : cover.toJson(),
  };
}

class Cover {
  Cover({
    this.id,
    this.link,
  });

  int id;
  String link;

  factory Cover.fromJson(Map<String, dynamic> json) => Cover(
    id: json["id"] == null ? null : json["id"],
    link: json["link"] == null ? null : json["link"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "link": link == null ? null : link,
  };
}

class UserBrief {
  UserBrief({
    this.id,
    this.username,
    this.profilePicture,
  });

  int id;
  String username;
  String profilePicture;

  factory UserBrief.fromJson(Map<String, dynamic> json) => UserBrief(
    id: json["id"] == null ? null : json["id"],
    username: json["username"] == null ? null : json["username"],
    profilePicture: json["profile_picture"] == null ? null : json["profile_picture"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "username": username == null ? null : username,
    "profile_picture": profilePicture == null ? null : profilePicture,
  };
}
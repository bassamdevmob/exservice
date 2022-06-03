import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exservice/models/entity/user.dart';

class ChatsResponse {
  ChatsResponse({
    this.data,
    this.message,
    this.code,
  });

  List<Chat> data;
  String message;
  String code;

  factory ChatsResponse.fromJson(Map<String, dynamic> json) => ChatsResponse(
    data: json["data"] == null ? null : List<Chat>.from(json["data"].map((x) => Chat.fromJson(x))),
    message: json["message"] == null ? null : json["message"],
    code: json["code"] == null ? null : json["code"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message == null ? null : message,
    "code": code == null ? null : code,
  };
}

class Chat {
  Chat({
    this.id,
    this.user,
    this.message,
  });

  int id;
  User user;
  Message message;

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
    id: json["id"] == null ? null : json["id"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    message: json["message"] == null ? null : Message.fromJson(json["message"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "user": user == null ? null : user.toJson(),
    "message": message == null ? null : message.toJson(),
  };
}

class Message {
  Message({
    this.senderId,
    this.content,
    this.date,
  });

  int senderId;
  String content;
  DateTime date;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    senderId: json["sender_id"] == null ? null : json["sender_id"],
    content: json["content"] == null ? null : json["content"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
  );

  factory Message.fromFirestoreJson(Map<String, dynamic> json) => Message(
    senderId: json["sender_id"] == null ? null : json["sender_id"],
    content: json["content"] == null ? null : json["content"],
    date: json["date"] == null ? null : json["date"].toDate(),
  );

  Map<String, dynamic> toJson() => {
    "sender_id": senderId == null ? null : senderId,
    "content": content == null ? null : content,
    "date": date == null ? null : date.toIso8601String(),
  };

  Map<String, dynamic> toFirestoreJson() => {
    "sender_id": senderId == null ? null : senderId,
    "content": content == null ? null : content,
    "date": date == null ? null : Timestamp.fromDate(date),
  };
}

import '../renovation/models/common/user_model.dart';

class MessageModel {
  MessageModel({
    this.content,
    this.senderId,
    this.senderName,
    this.timestamp,
  });

  String content;
  int senderId;
  String senderName;
  int timestamp;

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        content: json["content"] == null ? null : json["content"],
        senderId: json["sender_id"] == null ? null : json["sender_id"],
        senderName: json["sender_name"] == null ? null : json["sender_name"],
        timestamp: json["timestamp"] == null ? null : json["timestamp"],
      );

  Map<String, dynamic> toJson() => {
        "content": content == null ? null : content,
        "sender_id": senderId == null ? null : senderId,
        "sender_name": senderName == null ? null : senderName,
        "timestamp": timestamp == null ? null : timestamp,
      };
}

class Chatter {
  Chatter(this.user, {this.message});

  UserModel user;
  MessageModel message;
}

// To parse this JSON data, do
//
//     final mediaModel = mediaModelFromJson(jsonString);

import 'dart:convert';

MediaModel mediaModelFromJson(String str) =>
    MediaModel.fromJson(json.decode(str));

String mediaModelToJson(MediaModel data) => json.encode(data.toJson());

class MediaModel {
  MediaModel({
    this.message,
    this.data,
    this.code,
  });

  String message;
  UploadData data;
  int code;

  factory MediaModel.fromJson(Map<String, dynamic> json) => MediaModel(
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : UploadData.fromJson(json["data"]),
        code: json["code"] == null ? null : json["code"],
      );

  Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
        "data": data == null ? null : data.toJson(),
        "code": code == null ? null : code,
      };
}

class UploadData {
  UploadData({
    this.imagePath,
    this.videoPath,
  });

  String imagePath;
  String videoPath;

  factory UploadData.fromJson(Map<String, dynamic> json) => UploadData(
        imagePath: json["imagePath"] == null ? null : json["imagePath"],
        videoPath: json["videoPath"] == null ? null : json["videoPath"],
      );

  Map<String, dynamic> toJson() => {
        "imagePath": imagePath == null ? null : imagePath,
        "videoPath": videoPath == null ? null : videoPath,
      };
}

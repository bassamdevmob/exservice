import 'package:exservice/renovation/models/entity/ad_model.dart';

class FetchSavedAdsResponse {
  FetchSavedAdsResponse({
    this.message,
    this.data,
    this.code,
  });

  String message;
  List<SavedAdModel> data;
  int code;

  factory FetchSavedAdsResponse.fromJson(Map<String, dynamic> json) =>
      FetchSavedAdsResponse(
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : List<SavedAdModel>.from(json["data"].map((x) => SavedAdModel.fromJson(x))),
        code: json["code"] == null ? null : json["code"],
      );

  Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
        "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
        "code": code == null ? null : code,
      };
}

class SavedAdModel {
  SavedAdModel({
    this.userId,
    this.adId,
    this.createdAt,
    this.updatedAt,
    this.ad,
  });

  int userId;
  int adId;
  DateTime createdAt;
  DateTime updatedAt;
  AdModel ad;

  factory SavedAdModel.fromJson(Map<String, dynamic> json) => SavedAdModel(
        userId: json["user_id"] == null ? null : json["user_id"],
        adId: json["ad_id"] == null ? null : json["ad_id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        ad: json["ad"] == null ? null : AdModel.fromJson(json["ad"]),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId == null ? null : userId,
        "ad_id": adId == null ? null : adId,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "ad": ad == null ? null : ad.toJson(),
      };
}

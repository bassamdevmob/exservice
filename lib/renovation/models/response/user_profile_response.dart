import '../entity/ad_model.dart';
import '../entity/user.dart';

class UserProfileResponse {
  UserProfileResponse({
    this.message,
    this.data,
    this.code,
  });

  String message;
  UserProfileModel data;
  int code;

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) =>
      UserProfileResponse(
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : UserProfileModel.fromJson(json["data"]),
        code: json["code"] == null ? null : json["code"],
      );

  Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
        "data": data == null ? null : data.toJson(),
        "code": code == null ? null : code,
      };
}

class UserProfileModel {
  UserProfileModel({
    this.user,
    this.ads,
    this.activeCount,
    this.inactiveCount,
    this.expiredCount,
  });

  User user;
  List<AdModel> ads;
  int activeCount;
  int inactiveCount;
  int expiredCount;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) => UserProfileModel(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        ads: json["ads"] == null ? null : List<AdModel>.from(json["ads"].map((x) => AdModel.fromJson(x))),
        activeCount: json["active_ads"] == null ? null : json["active_ads"],
        inactiveCount: json["de_active_ads"] == null ? null : json["de_active_ads"],
        expiredCount: json["pending_ads"] == null ? null : json["pending_ads"],
      );

  Map<String, dynamic> toJson() => {
        "user": user == null ? null : user.toJson(),
        "ads": ads == null ? null : List<dynamic>.from(ads.map((x) => x.toJson())),
        "active_ads": activeCount == null ? null : activeCount,
        "de_active_ads": inactiveCount == null ? null : inactiveCount,
        "pending_ads": expiredCount == null ? null : expiredCount,
      };
}

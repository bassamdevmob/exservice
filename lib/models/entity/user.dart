import 'package:exservice/models/entity/location.dart';

class User {
  User({
    this.id,
    this.username,
    this.fcmToken,
    this.email,
    this.phoneNumber,
    this.location,
    this.countryCode,
    this.bio,
    this.website,
    this.companyName,
    this.profilePicture,
    this.statistics,
  });

  int id;
  String username;
  String fcmToken;
  String email;
  String phoneNumber;
  Location location;
  String countryCode;
  String bio;
  String website;
  String companyName;
  String profilePicture;
  Statistics statistics;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"] == null ? null : json["id"],
    username: json["username"] == null ? null : json["username"],
    fcmToken: json["fcm_token"] == null ? null : json["fcm_token"],
    email: json["email"] == null ? null : json["email"],
    phoneNumber: json["phone_number"] == null ? null : json["phone_number"],
    location: json["location"] == null ? null : Location.fromJson(json["location"]),
    countryCode: json["country_code"] == null ? null : json["country_code"],
    bio: json["bio"] == null ? null : json["bio"],
    website: json["website"] == null ? null : json["website"],
    companyName: json["company_name"] == null ? null : json["company_name"],
    profilePicture: json["profile_picture"] == null ? null : json["profile_picture"],
    statistics: json["statistics"] == null ? null : Statistics.fromJson(json["statistics"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "username": username == null ? null : username,
    "fcm_token": fcmToken == null ? null : fcmToken,
    "email": email == null ? null : email,
    "phone_number": phoneNumber == null ? null : phoneNumber,
    "location": location == null ? null : location.toJson(),
    "country_code": countryCode == null ? null : countryCode,
    "bio": bio == null ? null : bio,
    "website": website == null ? null : website,
    "company_name": companyName == null ? null : companyName,
    "profile_picture": profilePicture == null ? null : profilePicture,
    "statistics": statistics == null ? null : statistics.toJson(),
  };
}

class Statistics {
  Statistics({
    this.activeAdsCount,
    this.inactiveAdsCount,
    this.expiredAdsCount,
  });

  int activeAdsCount;
  int inactiveAdsCount;
  int expiredAdsCount;

  factory Statistics.fromJson(Map<String, dynamic> json) => Statistics(
    activeAdsCount: json["active_ads_count"] == null ? null : json["active_ads_count"],
    inactiveAdsCount: json["inactive_ads_count"] == null ? null : json["inactive_ads_count"],
    expiredAdsCount: json["expired_ads_count"] == null ? null : json["expired_ads_count"],
  );

  Map<String, dynamic> toJson() => {
    "active_ads_count": activeAdsCount == null ? null : activeAdsCount,
    "inactive_ads_count": inactiveAdsCount == null ? null : inactiveAdsCount,
    "expired_ads_count": expiredAdsCount == null ? null : expiredAdsCount,
  };
}

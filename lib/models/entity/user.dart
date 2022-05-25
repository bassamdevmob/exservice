class User {
  User({
    this.id,
    this.username,
    this.fcmToken,
    this.email,
    this.phoneNumber,
    this.country,
    this.countryCode,
    this.type,
    this.business,
    this.profilePicture,
    this.profileVideo,
    this.statistics,
  });

  int id;
  String username;
  String fcmToken;
  String email;
  String phoneNumber;
  String country;
  String countryCode;
  String type;
  Business business;
  String profilePicture;
  String profileVideo;
  Statistics statistics;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"] == null ? null : json["id"],
    username: json["username"] == null ? null : json["username"],
    fcmToken: json["fcm_token"] == null ? null : json["fcm_token"],
    email: json["email"] == null ? null : json["email"],
    phoneNumber: json["phone_number"] == null ? null : json["phone_number"],
    country: json["country"] == null ? null : json["country"],
    countryCode: json["country_code"] == null ? null : json["country_code"],
    type: json["type"] == null ? null : json["type"],
    business: json["business"] == null ? null : Business.fromJson(json["business"]),
    profilePicture: json["profile_picture"] == null ? null : json["profile_picture"],
    profileVideo: json["profile_video"] == null ? null : json["profile_video"],
    statistics: json["statistics"] == null ? null : Statistics.fromJson(json["statistics"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "username": username == null ? null : username,
    "fcm_token": fcmToken == null ? null : fcmToken,
    "email": email == null ? null : email,
    "phone_number": phoneNumber == null ? null : phoneNumber,
    "country": country == null ? null : country,
    "country_code": countryCode == null ? null : countryCode,
    "type": type == null ? null : type,
    "business": business == null ? null : business.toJson(),
    "profile_picture": profilePicture == null ? null : profilePicture,
    "profile_video": profileVideo == null ? null : profileVideo,
    "statistics": statistics == null ? null : statistics.toJson(),
  };
}

class Business {
  Business({
    this.publicPhone,
    this.bio,
    this.website,
    this.companyName,
  });

  String publicPhone;
  String bio;
  String website;
  String companyName;

  factory Business.fromJson(Map<String, dynamic> json) => Business(
    publicPhone: json["public_phone"] == null ? null : json["public_phone"],
    bio: json["bio"] == null ? null : json["bio"],
    website: json["website"] == null ? null : json["website"],
    companyName: json["company_name"] == null ? null : json["company_name"],
  );

  Map<String, dynamic> toJson() => {
    "public_phone": publicPhone == null ? null : publicPhone,
    "bio": bio == null ? null : bio,
    "website": website == null ? null : website,
    "company_name": companyName == null ? null : companyName,
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

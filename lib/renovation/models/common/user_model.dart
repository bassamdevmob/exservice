import 'package:exservice/renovation/utils/enums.dart';

import 'town_model.dart';

class UserModel {
  UserModel({
    this.id,
    this.username,
    this.companyName,
    this.email,
    this.phoneNumber,
    this.publicPhone,
    this.logo,
    this.bio,
    this.profilePic,
    this.apiToken,
    this.firebaseToken,
    this.profileVideo,
    this.website,
    this.status,
    this.town,
    this.type,
  });

  int id;
  String username;
  String companyName;
  String email;
  String phoneNumber;
  String publicPhone;
  String logo;
  String bio;
  String profilePic;
  String apiToken;
  String firebaseToken;
  String profileVideo;
  String website;
  int status;
  TownModel town;
  UserType type;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"] == null ? null : json["id"],
        username: json["name"] == null ? null : json["name"],
        companyName: json["username"],
        email: json["email"] == null ? null : json["email"],
        phoneNumber: json["phone_number"],
        publicPhone: json["public_phone"],
        logo: json["logo"] == null ? null : json["logo"],
        bio: json["bio"] == null ? null : json["bio"],
        profilePic: json["profile_pic"],
        apiToken: json["api_token"] == null ? null : json["api_token"],
        firebaseToken: json["firebase_token"],
        profileVideo: json["profile_video"],
        website: json["website"] == null ? null : json["website"],
        status: json["status"] == null ? null : json["status"],
        town: json["town"] == null ? null : TownModel.fromJson(json["town"]),
        type: json["type"] == null ? null : UserType.fromJson(json["type"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": username == null ? null : username,
        "username": companyName,
        "email": email == null ? null : email,
        "phone_number": phoneNumber,
        "public_phone": publicPhone,
        "logo": logo == null ? null : logo,
        "bio": bio == null ? null : bio,
        "profile_pic": profilePic,
        "api_token": apiToken == null ? null : apiToken,
        "firebase_token": firebaseToken,
        "profile_video": profileVideo,
        "website": website == null ? null : website,
        "status": status == null ? null : status,
        "town": town == null ? null : town.toJson(),
        "type": type == null ? null : type.toJson(),
      };
}

class UserType {
  UserType({
    this.id,
    this.title,
  });

  int id;
  String title;

  bool get isCompany => id == AccountType.company.id;

  factory UserType.fromJson(Map<String, dynamic> json) => UserType(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "title": title == null ? null : title,
      };
}

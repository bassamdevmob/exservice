//import 'Town.dart';
//import 'Type.dart';
//
//class User {
//  User({
//    this.id,
//    this.name,
//    this.username,
//    this.email,
//    this.phoneNumber,
//    this.publicPhone,
//    this.logo,
//    this.bio,
//    this.profilePic,
//    this.townId,
//    this.typeId,
//    this.apiToken,
//    this.isVerify,
//    this.verifiedAt,
//    this.profileVideo,
//    this.website,
//    this.status,
//    this.createdAt,
//    this.updatedAt,
//    this.town,
//    this.type,
//  });
//
//  int id;
//  String name;
//  String username;
//  String email;
//  String phoneNumber;
//  String publicPhone;
//  String logo;
//  String bio;
//  String profilePic;
//  int townId;
//  int typeId;
//  String apiToken;
//  int isVerify;
//  DateTime verifiedAt;
//  String profileVideo;
//  String website;
//  int status;
//  DateTime createdAt;
//  DateTime updatedAt;
//  Town town;
//  Type type;
//
//  bool get isCompany => typeId > 2;
//
//  factory User.fromJson(Map<String, dynamic> json) => User(
//        id: json["id"] == null ? null : json["id"],
//        name: json["name"] == null ? null : json["name"],
//        username: json["username"] == null ? null : json["username"],
//        email: json["email"] == null ? null : json["email"],
//        phoneNumber: json["phone_number"] == null ? null : json["phone_number"],
//        publicPhone: json["public_phone"] == null ? null : json["public_phone"],
//        logo: json["logo"] == null ? null : json["logo"],
//        bio: json["bio"] == null ? null : json["bio"],
//        profilePic: json["profile_pic"] == null ? null : json["profile_pic"],
//        townId: json["town_id"] == null ? null : json["town_id"],
//        typeId: json["type_id"] == null ? null : json["type_id"],
//        apiToken: json["api_token"] == null ? null : json["api_token"],
//        isVerify: json["is_verify"] == null ? null : json["is_verify"],
//        verifiedAt: json["verified_at"] == null ? null : DateTime.parse(json["verified_at"]),
//        profileVideo: json["profile_video"] == null ? null : json["profile_video"],
//        website: json["website"] == null ? null : json["website"],
//        status: json["status"] == null ? null : json["status"],
//        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
//        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
//        town: json["town"] == null ? null : Town.fromJson(json["town"]),
//        type: json["type"] == null ? null : Type.fromJson(json["type"]),
//      );
//
//  Map<String, dynamic> toJson() => {
//        "id": id == null ? null : id,
//        "name": name == null ? null : name,
//        "username": username == null ? null : username,
//        "email": email == null ? null : email,
//        "phone_number": phoneNumber == null ? null : phoneNumber,
//        "public_phone": publicPhone == null ? null : publicPhone,
//        "logo": logo == null ? null : logo,
//        "bio": bio == null ? null : bio,
//        "profile_pic": profilePic == null ? null : profilePic,
//        "town_id": townId == null ? null : townId,
//        "type_id": typeId == null ? null : typeId,
//        "api_token": apiToken == null ? null : apiToken,
//        "is_verify": isVerify == null ? null : isVerify,
//        "verified_at": verifiedAt == null ? null : verifiedAt.toIso8601String(),
//        "profile_video": profileVideo == null ? null : profileVideo,
//        "website": website == null ? null : website,
//        "status": status == null ? null : status,
//        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
//        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
//        "town": town == null ? null : town.toJson(),
//        "type": type == null ? null : type.toJson(),
//      };
//}

// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

import 'package:exservice/renovation/utils/enums.dart';

import 'Town.dart';

UserModel userFromJson(String str) => UserModel.fromJson(json.decode(str));

String userToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.message,
    this.data,
    this.code,
  });

  String message;
  User data;
  int code;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : User.fromJson(json["data"]),
        code: json["code"] == null ? null : json["code"],
      );

  Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
        "data": data == null ? null : data.toJson(),
        "code": code == null ? null : code,
      };
}

class User {
  User({
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
  Town town;
  UserType type;

  factory User.fromJson(Map<String, dynamic> json) => User(
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
        town: json["town"] == null ? null : Town.fromJson(json["town"]),
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

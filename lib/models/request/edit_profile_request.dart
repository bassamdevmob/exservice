import 'package:dio/dio.dart';

class EditProfileRequest {
  EditProfileRequest({
    this.profilePicture,
    this.username,
    this.companyName,
    this.website,
    this.bio,
  });

  String profilePicture;
  String username;
  String companyName;
  String website;
  String bio;

  Future<FormData> toFormData() async => FormData.fromMap({
    "profile_picture": profilePicture == null ? null : await MultipartFile.fromFile(profilePicture),
    "username": username == null ? null : username,
    "company_name": companyName == null ? null : companyName,
    "website": website == null ? null : website,
    "bio": bio == null ? null : bio,
  });
}

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:exservice/models/GetChatUsersModel.dart';
import 'package:exservice/renovation/models/responses/user_profile_response.dart';
import 'package:exservice/models/NotificationsModel.dart';
import 'package:exservice/models/PostAdModel.dart';
import 'package:exservice/models/UploadMediaModel.dart';
import 'package:exservice/renovation/models/common/ad_model.dart';
import 'package:exservice/renovation/models/responses/general_response.dart';
import 'package:exservice/renovation/models/common/town_model.dart';
import 'package:exservice/renovation/models/common/user_model.dart';
import 'package:exservice/models/options/AdPricesListModel.dart';
import 'package:exservice/models/options/GetCountriesListModel.dart';
import 'package:exservice/renovation/models/common/category.dart';
import 'package:exservice/renovation/models/responses/session_response.dart';
import 'package:flutter/material.dart';

abstract class ApiProviderDelegate {
  Future<PostAdModel> fetchStoreAd(BuildContext context, bool isFree);

  Future<AdModel> fetchGetAdDetails(int id);

  Future<void> fetchDeleteAd(int adId);

  Future<List<AdModel>> fetchGetUserAds(int offset, int status);

  Future<GeneralResponse> fetchUploadAdMedia(
    int adId,
    ProgressCallback cb,
  );

  Future<String> fetchPayment(
      BuildContext context, int adId, int priceId, int days);

  Future<void> fetchChangeAdStatus(int adId, int status);

  Future<void> fetchEditAd(adId, title, description);

  Future<void> fetchVerifyPin(String session, String pin);

  Future<SessionResponse> fetchManageEmailAddress(String email, String password);

  Future<SessionResponse> fetchUpdatePhoneNumber(String phoneNumber, String password);

  Future<void> fetchSwitchToBusiness(username, website, bio);

  Future<UserProfileModel> fetchGetUserAccount(int id);

  Future<UserProfileModel> fetchGetUserProfile();

  Future<UploadData> fetchUpdateUserPicture({String image, String video});

  Future<List<NotificationModel>> fetchNotifications();

  Future<void> fetchUpdateFirebaseToken(token);

  Future<void> fetchEditProfile({
    name,
    email,
    townId,
    bio,
    website,
    phoneNumber,
    publicPhone,
    companyName,
    typeId,
  });

  Future<void> fetchUpdatePassword(oldWord, newWord, confirm);

  Future<List<Chatter>> fetchGetChatUsers();

  Future<List<UserType>> fetchUserTypesList(BuildContext context);

  Future<List<Choice>> fetchCountriesList(BuildContext context);

  Future<List<TownModel>> fetchTownsList(BuildContext context, int countryId);

  Future<List<AdPrice>> fetchAdPricesList(BuildContext context);

  Future<UserModel> login(account, password);

  Future<SessionResponse> fetchSignUp(name, account, password);

  Future<SessionResponse> fetchForgetPassword(account);

  Future<void> fetchResetPassword(code, password, confirm);

  Future<bool> fetchCheckAccount(account);

  Future<UserModel> fetchVerifyUser(String session, String code);

  Future<void> fetchResendVerificationCode(account);

  Future<List<Category>> fetchCategories();

  Future<List<AdModel>> fetchGetAdsList(
    offset, {
    townId,
    ownerId,
    status,
    option,
    type,
    furniture,
    rooms,
    balcony,
    bath,
    terrace,
    fromPrice,
    toPrice,
    garage,
    fromSize,
    toSize,
  });

  Future<void> fetchSaveAd(int id, bool value);

  Future<List<AdModel>> getFavoritesAds(int offset);
}

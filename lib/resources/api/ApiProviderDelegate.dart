import 'dart:async';

import 'package:dio/dio.dart';
import 'package:exservice/models/GetChatUsersModel.dart';
import 'package:exservice/models/GetUserProfileModel.dart';
import 'package:exservice/models/NotificationsModel.dart';
import 'package:exservice/models/PostAdModel.dart';
import 'package:exservice/models/UploadMediaModel.dart';
import 'package:exservice/models/common/AdModel.dart';
import 'package:exservice/models/common/SimpleResponseModel.dart';
import 'package:exservice/models/common/Town.dart';
import 'package:exservice/models/common/User.dart';
import 'package:exservice/models/options/AdPricesListModel.dart';
import 'package:exservice/models/options/GetCountriesListModel.dart';
import 'package:exservice/renovation/models/category.dart';
import 'package:flutter/material.dart';

abstract class ApiProviderDelegate {
  Future<PostAdModel> fetchStoreAd(BuildContext context, bool isFree);

  Future<AdModel> fetchGetAdDetails(int id);

  Future<void> fetchDeleteAd(int adId);

  Future<List<AdModel>> fetchGetUserAds(int offset, int status);

  Future<SimpleResponseModel> fetchUploadAdMedia(
    int adId,
    ProgressCallback cb,
  );

  Future<String> fetchPayment(
      BuildContext context, int adId, int priceId, int days);

  Future<void> fetchChangeAdStatus(int adId, int status);

  Future<void> fetchEditAd(BuildContext context, adId, title, description);

  Future<void> fetchCompleteUpdateEmailPhone(
      BuildContext context, code, account, type);

  Future<void> fetchUpdateEmailPhone(BuildContext context, account, type);

  Future<void> fetchSwitchToBusiness(username, website, bio);

  Future<UserProfile> fetchGetUserAccount(int id);

  Future<UserProfile> fetchGetUserProfile();

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

  Future<List<Town>> fetchTownsList(BuildContext context, int countryId);

  Future<List<AdPrice>> fetchAdPricesList(BuildContext context);

  Future<User> login(account, password);

  Future<void> fetchSignUp(name, account, password);

  Future<void> fetchForgetPassword(account);

  Future<void> fetchResetPassword(code, password, confirm);

  Future<bool> fetchCheckAccount(account);

  Future<User> fetchVerifyUser(account, code);

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

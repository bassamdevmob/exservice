import 'package:exservice/models/GetUserProfileModel.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'api/ApiProviderDelegate.dart';

class AccountManager {
  bool get exists => _profile != null;

  void clear() => _profile = null;

  UserProfile get profile => _profile;

  UserProfile _profile;

  Future<void> initialize(BuildContext context) async {
    _profile = await GetIt.I.get<ApiProviderDelegate>().fetchGetUserProfile();
    return;
  }
}

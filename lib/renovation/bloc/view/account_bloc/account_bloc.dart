import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:exservice/renovation/models/response/user_profile_response.dart';
import 'package:exservice/renovation/utils/enums.dart';
import 'package:exservice/resources/api/ApiProviderDelegate.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

part 'account_event.dart';

part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final ScrollController scrollController = ScrollController();

  UserProfileModel profile;
  AccountTab currentTab = AccountTab.details;

  AccountBloc() : super(AccountAwaitState()) {
    on((event, emit) async {
      if (event is AccountFetchEvent) {
        try {
          emit(AccountAwaitState());
          profile =
              await GetIt.I.get<ApiProviderDelegate>().fetchGetUserProfile();
          emit(AccountAccessibleState());
        } catch (e) {
          emit(AccountErrorState("$e"));
        }
      } else if (event is AccountRefreshEvent) {
        emit(AccountInitial());
      } else if (event is AccountChangeTabEvent) {
        currentTab = event.tab;
        emit(AccountChangeTabState());
      } else if (event is AccountUploadVideoEvent) {
        emit(AccountAwaitVideoUploadState());
        try {
          final res = await GetIt.I
              .get<ApiProviderDelegate>()
              .fetchUpdateUserPicture(video: event.path);
          profile.user.profileVideo = res.videoPath;
          emit(AccountVideoState());
        } catch (e) {
          emit(AccountErrorVideoUploadState("$e"));
        }
      } else if (event is AccountChangeProfileImageEvent) {
        emit(AccountAwaitImageUploadState());
        try {
          final res = await GetIt.I
              .get<ApiProviderDelegate>()
              .fetchUpdateUserPicture(image: event.path);
          profile.user.profilePicture = res.imagePath;
          emit(AccountImageState());
        } catch (e) {
          emit(AccountErrorImageUploadState("$e"));
        }
      }
    });
  }

  @override
  Future<void> close() {
    scrollController.dispose();
    return super.close();
  }
}

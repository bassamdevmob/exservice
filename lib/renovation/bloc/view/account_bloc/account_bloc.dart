import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:exservice/helper/Enums.dart';
import 'package:exservice/models/GetUserProfileModel.dart';
import 'package:exservice/resources/api/ApiProviderDelegate.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final ScrollController scrollController = ScrollController();

  UserProfile profile;
  AccountTab currentTab = AccountTab.details;

  AccountBloc() : super(AccountAwaitState());

  @override
  Future<void> close() {
    scrollController.dispose();
    return super.close();
  }

  @override
  Stream<AccountState> mapEventToState(
    AccountEvent event,
  ) async* {
    if (event is AccountFetchEvent) {
      try {
        yield AccountAwaitState();
        profile =
            await GetIt.I.get<ApiProviderDelegate>().fetchGetUserProfile();
        yield AccountAccessibleState();
      } catch (e) {
        yield AccountErrorState("$e");
      }
    } else if (event is AccountRefreshEvent) {
      yield AccountInitial();
    } else if (event is AccountChangeTabEvent) {
      currentTab = event.tab;
      yield AccountChangeTabState();
    } else if (event is AccountUploadVideoEvent) {
      yield AccountAwaitVideoUploadState();
      try {
        final res = await GetIt.I
            .get<ApiProviderDelegate>()
            .fetchUpdateUserPicture(video: event.path);
        profile.user.profileVideo = res.videoPath;
        yield AccountVideoState();
      } catch (e) {
        yield AccountErrorVideoUploadState("$e");
      }
    } else if (event is AccountChangeProfileImageEvent) {
      yield AccountAwaitImageUploadState();
      try {
        final res = await GetIt.I
            .get<ApiProviderDelegate>()
            .fetchUpdateUserPicture(image: event.path);
        profile.user.profilePic = res.imagePath;
        yield AccountImageState();
      } catch (e) {
        yield AccountErrorImageUploadState("$e");
      }
    }
  }
}

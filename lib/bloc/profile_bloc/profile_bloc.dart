import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:exservice/models/entity/user.dart';
import 'package:exservice/resources/repository/user_repository.dart';
import 'package:exservice/utils/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ScrollController scrollController = ScrollController();

  User model;
  ProfileTab currentTab = ProfileTab.details;


  @override
  Future<void> close() {
    scrollController.dispose();
    return super.close();
  }

  ProfileBloc() : super(ProfileAwaitState()) {
    on((event, emit) async {
      if (event is ProfileFetchEvent) {
        try {
          emit(ProfileAwaitState());
          var response =
              await GetIt.I.get<UserRepository>().getProfile();
          model = response.data;
          emit(ProfileAccessibleState());
        } catch (e) {
          emit(ProfileErrorState("$e"));
        }
      } else if (event is ProfileRefreshEvent) {
        emit(ProfileInitial());
      } else if (event is ProfileChangeTabEvent) {
        currentTab = event.tab;
        emit(ProfileChangeTabState());
      } else if (event is ProfileUploadVideoEvent) {
        // emit(ProfileAwaitVideoUploadState());
        // try {
        //   final res = await GetIt.I
        //       .get<ApiProviderDelegate>()
        //       .fetchUpdateUserPicture(video: event.path);
        //   profile.user.profileVideo = res.videoPath;
        //   emit(ProfileVideoState());
        // } catch (e) {
        //   emit(ProfileErrorVideoUploadState("$e"));
        // }
      } else if (event is ProfileChangeProfileImageEvent) {
        // emit(ProfileAwaitImageUploadState());
        // try {
        //   final res = await GetIt.I
        //       .get<ApiProviderDelegate>()
        //       .fetchUpdateUserPicture(image: event.path);
        //   profile.user.profilePicture = res.imagePath;
        //   emit(ProfileImageState());
        // } catch (e) {
        //   emit(ProfileErrorImageUploadState("$e"));
        // }
      }
    });
  }

}

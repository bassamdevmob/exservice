import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:exservice/controller/data_store.dart';
import 'package:exservice/models/entity/user.dart';
import 'package:exservice/resources/api_client.dart';
import 'package:exservice/resources/repository/auth_repository.dart';
import 'package:exservice/resources/repository/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ScrollController scrollController = ScrollController();

  User model;

  bool get isAuthenticated => DataStore.instance.hasToken;

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
          var response = await GetIt.I.get<UserRepository>().getProfile();
          model = response.data;
          emit(ProfileAcceptState());
        } on DioError catch (ex) {
          emit(ProfileErrorState(ex.error));
        }
      } else if (event is ProfileUpdateEvent) {
        model = event.model;
        emit(ProfileRefreshState());
      } else if (event is ProfileRefreshEvent) {
        emit(ProfileRefreshState());
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
      } else if (event is ProfileLogoutEvent) {
        try {
          emit(ProfileLogoutAwaitState());
          await GetIt.I.get<AuthRepository>().logout();
          DataStore.instance.deleteCertificates();
          emit(ProfileLogoutAcceptState());
        } on DioError catch (ex) {
          if (ex.response?.statusCode == BaseClient.UNAUTHORIZED) {
            DataStore.instance.deleteCertificates();
            emit(ProfileLogoutAcceptState());
          } else {
            var e = ex.error;
            emit(ProfileLogoutErrorState(e));
          }
        }
      }
    });
  }
}

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
  User _model;

  User get model => _model;

  bool get isAuthenticated => DataStore.instance.hasToken;

  set model(User value) {
    User subscriber = value;
    DataStore.instance.setUser(_model = subscriber);
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

    _model = DataStore.instance.user;
    if (DataStore.instance.hasToken) {
      add(ProfileFetchEvent());
    }
  }
}

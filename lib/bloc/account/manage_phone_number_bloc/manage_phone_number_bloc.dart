import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:exservice/bloc/profile_bloc/profile_bloc.dart';
import 'package:exservice/resources/repository/user_repository.dart';
import 'package:exservice/utils/localized.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

part 'manage_phone_number_event.dart';

part 'manage_phone_number_state.dart';

class ManagePhoneNumberBloc
    extends Bloc<ManagePhoneNumberEvent, ManagePhoneNumberState> {
  final mobileNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final ProfileBloc profile;

  @override
  Future<void> close() async {
    mobileNumberController.dispose();
    passwordController.dispose();
    super.close();
  }

  Localized mobileErrorMessage;
  Localized passwordErrorMessage;

  bool get valid => mobileErrorMessage == null && passwordErrorMessage == null;

  void _validate() {
    String mobile = mobileNumberController.text.trim();
    String password = passwordController.text.trim();

    mobileErrorMessage = mobile.isEmpty ? Localized("field_required") : null;
    passwordErrorMessage =
        password.isEmpty ? Localized("field_required") : null;
  }

  bool obscurePassword = true;

  ManagePhoneNumberBloc(this.profile) : super(ManagePhoneNumberInitial()) {
    mobileNumberController.text = profile.model.phoneNumber;
    on<ManagePhoneNumberEvent>((event, emit) async {
      if (event is ManagePhoneNumberCommitEvent) {
        _validate();
        emit(ManagePhoneNumberValidateState());
        if (valid) {
          try {
            emit(ManagePhoneNumberAwaitState());
            String mobileNumber = mobileNumberController.text.trim();
            String password = passwordController.text.trim();
            var response =
                await GetIt.I.get<UserRepository>().updatePhoneNumber(
                      phoneNumber: mobileNumber,
                      password: password,
                    );
            emit(ManagePhoneNumberAcceptState(response.data.session));
          } on DioError catch (ex) {
            emit(ManagePhoneNumberErrorState(ex.error));
          }
        }
      } else if (event is ManagePhoneNumberShowPasswordEvent) {
        obscurePassword = !obscurePassword;
        emit(ManagePhoneNumberSecurePasswordState());
      }
    });
  }
}

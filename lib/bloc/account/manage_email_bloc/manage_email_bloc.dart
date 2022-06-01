import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:exservice/bloc/profile_bloc/profile_bloc.dart';
import 'package:exservice/resources/repository/user_repository.dart';
import 'package:exservice/utils/localized.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:string_validator/string_validator.dart';

part 'manage_email_event.dart';

part 'manage_email_state.dart';

class ManageEmailBloc extends Bloc<ManageEmailEvent, ManageEmailState> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final ProfileBloc profile;

  @override
  Future<void> close() async {
    emailController.dispose();
    passwordController.dispose();
    super.close();
  }

  Localized emailErrorMessage;
  Localized passwordErrorMessage;

  bool get valid => emailErrorMessage == null && passwordErrorMessage == null;

  void _validate() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty) {
      emailErrorMessage = Localized("field_required");
    } else if (!isEmail(email)) {
      emailErrorMessage = Localized("invalid_email");
    } else {
      emailErrorMessage = null;
    }
    passwordErrorMessage =
        password.isEmpty ? Localized("field_required") : null;
  }

  bool obscurePassword = true;

  ManageEmailBloc(this.profile) : super(ManageEmailInitial()) {
    emailController.text = profile.model.email;
    on<ManageEmailEvent>((event, emit) async {
      if (event is ManageEmailCommitEvent) {
        _validate();
        emit(ManageEmailValidateState());
        if (valid) {
          try {
            emit(ManageEmailAwaitState());
            String mobileNumber = emailController.text.trim();
            String password = passwordController.text.trim();
            var response = await GetIt.I
                .get<UserRepository>()
                .updateEmail(email: mobileNumber, password: password);
            emit(ManageEmailAcceptState(response.data.session));
          } on DioError catch (ex) {
            emit(ManageEmailErrorState(ex.error));
          }
        }
      } else if (event is ManageEmailShowPasswordEvent) {
        obscurePassword = !obscurePassword;
        emit(ManageEmailSecurePasswordState());
      }
    });
  }
}

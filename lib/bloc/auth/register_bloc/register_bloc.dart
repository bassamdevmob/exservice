import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:exservice/models/request/register_request.dart';
import 'package:exservice/resources/api_client.dart';
import 'package:exservice/resources/repository/auth_repository.dart';
import 'package:exservice/utils/localized.dart';
import 'package:exservice/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:string_validator/string_validator.dart';

part 'register_event.dart';

part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final accountController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;

  Localized accountErrorMessage;
  Localized usernameErrorMessage;
  Localized passwordErrorMessage;

  @override
  Future<void> close() {
    accountController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    return super.close();
  }

  void _validate() {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();
    String account = accountController.text.trim();

    if (account.isEmpty) {
      accountErrorMessage = Localized("field_required");
    } else if (!Utils.isPhoneNumber(account) && !isEmail(account)) {
      accountErrorMessage = Localized("invalid_account");
    } else {
      accountErrorMessage = null;
    }

    usernameErrorMessage =
        isLength(username, 6, 40) ? null : Localized("field_length_range");
    passwordErrorMessage =
        isLength(password, 6, 40) ? null : Localized("field_length_range");
  }

  bool get valid =>
      accountErrorMessage == null &&
      passwordErrorMessage == null &&
      usernameErrorMessage == null;

  RegisterBloc() : super(RegisterInitial()) {
    on((event, emit) async {
      if (event is RegisterCommitEvent) {
        _validate();
        emit(RegisterValidationState());
        if (valid) {
          emit(RegisterAwaitState());
          try {
            var account = accountController.text.trim();
            var password = passwordController.text.trim();
            var username = usernameController.text.trim();
            var response =
                await GetIt.I.get<AuthRepository>().register(RegisterRequest(
                      username: username,
                      account: account,
                      password: password,
                    ));
            emit(RegisterAcceptState(response.data.session));
          } on DioError catch (ex) {
            var error = ex.error;
            if (error is ValidationException) {
              accountErrorMessage = error.errors['account'];
              usernameErrorMessage = error.errors['username'];
              passwordErrorMessage = error.errors['password'];
              emit(RegisterValidationState());
            } else {
              emit(RegisterErrorState(error));
            }
          }
        }
      } else if (event is RegisterSecurePasswordEvent) {
        obscurePassword = !obscurePassword;
        emit(RegisterSecurePasswordState());
      }
    });
  }
}

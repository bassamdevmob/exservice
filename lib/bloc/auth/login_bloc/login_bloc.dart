import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:exservice/controller/data_store.dart';
import 'package:exservice/models/response/auth_response.dart';
import 'package:exservice/resources/api_client.dart';
import 'package:exservice/resources/repository/auth_repository.dart';
import 'package:exservice/utils/localized.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;

  Localized usernameErrorMessage;
  Localized passwordErrorMessage;

  @override
  Future<void> close() {
    usernameController.dispose();
    passwordController.dispose();
    return super.close();
  }

  bool get valid => usernameErrorMessage == null && passwordErrorMessage == null;

  void _validate() {
    String account = usernameController.text.trim();
    String password = passwordController.text.trim();

    usernameErrorMessage = account.isEmpty ? Localized("field_required") : null;

    passwordErrorMessage =
        password.isEmpty ? Localized("field_required") : null;
  }

  LoginBloc() : super(LoginInitial()) {
    on((event, emit) async {
      if (event is LoginCommitEvent) {
        _validate();
        emit(LoginValidationState());
        if (valid) {
          emit(LoginAwaitState());
          try {
            var username = usernameController.text.trim();
            var password = passwordController.text.trim();
            var response = await GetIt.I.get<AuthRepository>().login(
                  username,
                  password,
                );
            emit(LoginAcceptState(response.data));
          } on DioError catch (ex) {
            var error = ex.error;
            if (error is ValidationException) {
              usernameErrorMessage = error.errors['account'];
              passwordErrorMessage = error.errors['password'];
              emit(LoginValidationState());
            } else {
              emit(LoginErrorState(error));
            }
          }
        }
      } else if (event is LoginSecurePasswordEvent) {
        obscurePassword = !obscurePassword;
        emit(LoginSecurePasswordState());
      }
    });
  }
}

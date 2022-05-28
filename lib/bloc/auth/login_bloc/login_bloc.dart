import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:exservice/controller/data_store.dart';
import 'package:exservice/resources/api_client.dart';
import 'package:exservice/resources/repository/auth_repository.dart';
import 'package:exservice/utils/localized.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final accountController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;

  Localized accountErrorMessage;
  Localized passwordErrorMessage;

  @override
  Future<void> close() {
    accountController.dispose();
    passwordController.dispose();
    return super.close();
  }

  bool get valid => accountErrorMessage == null && passwordErrorMessage == null;

  void _validate() {
    String account = accountController.text.trim();
    String password = passwordController.text.trim();

    accountErrorMessage = account.isEmpty ? Localized("field_required") : null;

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
            var account = accountController.text.trim();
            var password = passwordController.text.trim();
            var response = await GetIt.I.get<AuthRepository>().login(
                  account,
                  password,
                );
            DataStore.instance.setToken(response.data.token);
            emit(LoginAcceptState());
          } on DioError catch (ex) {
            var error = ex.error;
            if (error is ValidationException) {
              accountErrorMessage = error.errors['account'];
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

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:exservice/renovation/controller/data_store.dart';
import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/renovation/resources/repository/auth_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final accountController = TextEditingController();
  final passwordController = TextEditingController();
  final BuildContext context;

  bool obscurePassword = true;

  String accountErrorMessage;
  String passwordErrorMessage;

  LoginBloc(this.context) : super(LoginInitial()) {
    accountController.text = DataStore.instance.settings.account;
    passwordController.text = DataStore.instance.settings.password;
    on((event, emit) async {
      if (event is LoginValidateEvent) {
        _validate();
        emit(LoginValidationState());
      } else if (event is LoginCommitEvent) {
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
            DataStore.instance.setAccount(account, password);
            DataStore.instance.token = response.data.token;
            DataStore.instance.user = response.data.user;
            emit(LoginCommittedState());
          } catch (e) {
            emit(LoginErrorState("$e"));
          }
        }
      } else if (event is LoginSecurePasswordEvent) {
        obscurePassword = !obscurePassword;
        emit(LoginSecurePasswordState());
      }
    });
  }

  bool get valid => accountErrorMessage == null && passwordErrorMessage == null;

  void _validate() {
    String account = accountController.text.trim();
    String password = passwordController.text.trim();

    accountErrorMessage = account.isEmpty
        ? AppLocalization.of(context).trans("field_required")
        : null;

    passwordErrorMessage = password.isEmpty
        ? AppLocalization.of(context).trans("field_required")
        : null;
  }

  @override
  Future<void> close() {
    accountController.dispose();
    passwordController.dispose();
    return super.close();
  }
}

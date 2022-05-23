import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:exservice/renovation/controller/data_store.dart';
import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/resources/api/ApiProviderDelegate.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

part 'reset_password_event.dart';
part 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  final String account;
  final String code;
  final BuildContext context;

  bool obscurePassword = true;

  String passwordErrorMessage;
  String confirmErrorMessage;

  ResetPasswordBloc(this.context, this.account, this.code)
      : super(ResetPasswordInitial()){
    on((event, emit) async{
      if (event is ResetPasswordValidateEvent) {
        _validate();
        emit (ResetPasswordValidationState());
      } else if (event is ResetPasswordCommitEvent) {
        _validate();
        emit (ResetPasswordValidationState());
        if (valid) {
          emit (ResetPasswordAwaitState());
          try {
            var password = passwordController.text.trim();
            var confirm = confirmController.text.trim();
            await GetIt.I
                .get<ApiProviderDelegate>()
                .fetchResetPassword(code, password, confirm);
            var response =
            await GetIt.I.get<ApiProviderDelegate>().login(account, password);
            DataStore.instance.user = response;
            emit (ResetPasswordCommittedState());
          } catch (e) {
            emit (ResetPasswordErrorState("$e"));
          }
        }
      } else if (event is ResetPasswordSecurePasswordEvent) {
        obscurePassword = !obscurePassword;
        emit (ResetPasswordSecurePasswordState());
      }
    });
  }

  bool get valid => confirmErrorMessage == null && passwordErrorMessage == null;

  void _validate() {
    String password = passwordController.text.trim();
    String confirm = confirmController.text.trim();

    passwordErrorMessage = password.length < 6 || password.length > 40
        ? AppLocalization.of(context).trans("allow_chars_number")
        : null;

    if (confirm.isEmpty) {
      confirmErrorMessage = AppLocalization.of(context).trans("field_required");
    } else if (confirm != password) {
      confirmErrorMessage =
          AppLocalization.of(context).trans("password_not_match");
    } else {
      confirmErrorMessage = null;
    }
  }

  @override
  Future<void> close() {
    confirmController.dispose();
    passwordController.dispose();
    return super.close();
  }
}

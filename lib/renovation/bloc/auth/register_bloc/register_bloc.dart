import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:exservice/renovation/controller/data_store.dart';
import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/renovation/utils/enums.dart';
import 'package:exservice/renovation/utils/utils.dart';
import 'package:exservice/resources/api/ApiProviderDelegate.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:string_validator/string_validator.dart' as validator;

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final accountController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final BuildContext context;

  bool obscurePassword = true;
  AccountRegistrationIdentifier identifier =
      AccountRegistrationIdentifier.phone;

  String accountErrorMessage;
  String usernameErrorMessage;
  String passwordErrorMessage;

  RegisterBloc(this.context) : super(RegisterInitial());

  void _validate() {
    String password = passwordController.text.trim();
    String username = usernameController.text.trim();

    passwordErrorMessage = password.length < 6 || password.length > 40
        ? AppLocalization.of(context).trans("allow_chars_number")
        : null;

    usernameErrorMessage = username.length < 6 || username.length > 40
        ? AppLocalization.of(context).trans("allow_chars_number")
        : null;
  }

  bool get valid =>
      accountErrorMessage == null &&
      passwordErrorMessage == null &&
      usernameErrorMessage == null;

  void _validateAccount() {
    String account = accountController.text.trim();
    if (account.isEmpty) {
      accountErrorMessage = AppLocalization.of(context).trans("field_required");
      return;
    } else if (identifier == AccountRegistrationIdentifier.phone &&
        !Utils.isPhoneNumber(account)) {
      accountErrorMessage =
          AppLocalization.of(context).trans('invalid_phone_number');
    } else if (identifier == AccountRegistrationIdentifier.email &&
        !validator.isEmail(account)) {
      accountErrorMessage = AppLocalization.of(context).trans('invalid_email');
    } else {
      accountErrorMessage = null;
    }
  }

  @override
  Future<void> close() {
    accountController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    return super.close();
  }

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is RegisterChangeIdentifierEvent) {
      identifier = event.identifier;
      accountController.clear();
      yield RegisterChangeIdentifierState();
    } else if (event is RegisterValidateEvent) {
      _validate();
      yield RegisterValidationState();
    } else if (event is RegisterCommitEvent) {
      _validate();
      yield RegisterValidationState();
      if (valid) {
        yield RegisterAwaitState();
        try {
          var account = accountController.text.trim();
          var password = passwordController.text.trim();
          var username = usernameController.text.trim();
          await GetIt.I
              .get<ApiProviderDelegate>()
              .fetchSignUp(username, account, password);
          try {
            await DataStore.instance.setAccount(account, password);
          } finally {
            yield RegisterCommittedState();
          }
        } catch (e) {
          yield RegisterErrorState("$e");
        }
      }
    } else if (event is RegisterValidateAccountEvent) {
      _validateAccount();
      yield RegisterValidationState();
    } else if (event is RegisterCheckAccountEvent) {
      _validateAccount();
      yield RegisterValidationState();
      if (accountErrorMessage == null) {
        yield RegisterAwaitCheckAccountState();
        try {
          var account = accountController.text.trim();
          var exists = await GetIt.I
              .get<ApiProviderDelegate>()
              .fetchCheckAccount(account);
          if (exists) {
            accountErrorMessage =
                AppLocalization.of(context).trans("already_exists");
            yield RegisterInitial();
          } else {
            yield RegisterUniqueAccountState();
          }
        } catch (e) {
          yield RegisterErrorState("$e");
        }
      }
    } else if (event is RegisterSecurePasswordEvent) {
      obscurePassword = !obscurePassword;
      yield RegisterSecurePasswordState();
    }
  }
}

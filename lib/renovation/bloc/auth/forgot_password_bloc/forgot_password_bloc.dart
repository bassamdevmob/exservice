import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:exservice/renovation/controller/data_store.dart';
import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/renovation/utils/utils.dart';
import 'package:exservice/resources/api/ApiProviderDelegate.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:string_validator/string_validator.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final accountController = TextEditingController();
  final BuildContext context;

  String accountErrorMessage;

  ForgotPasswordBloc(this.context) : super(ForgotPasswordInitial()) {
    if (DataStore.instance.settings.account != null) {
      accountController.text = DataStore.instance.settings.account;
    }
  }

  bool get valid => accountErrorMessage == null;

  void _validate() {
    String account = accountController.text.trim();

    if (account.isEmpty) {
      accountErrorMessage = AppLocalization.of(context).trans("field_required");
    } else if (!Utils.isPhoneNumber(account) && !isEmail(account)) {
      accountErrorMessage =
          AppLocalization.of(context).trans("invalid_account");
    } else {
      accountErrorMessage = null;
    }
  }

  @override
  Stream<ForgotPasswordState> mapEventToState(
    ForgotPasswordEvent event,
  ) async* {
    if (event is ForgotPasswordValidateEvent) {
      _validate();
      yield ForgotPasswordValidationState();
    } else if (event is ForgotPasswordCommitEvent) {
      _validate();
      yield ForgotPasswordValidationState();
      if (valid) {
        yield ForgotPasswordAwaitState();
        try {
          var account = accountController.text.trim();
          var response = await GetIt.I.get<ApiProviderDelegate>().fetchForgetPassword(account);
          yield ForgotPasswordCommittedState(response.data.session);
        } catch (e) {
          yield ForgotPasswordErrorState("$e");
        }
      }
    }
  }
}

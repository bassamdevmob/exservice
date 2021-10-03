import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/renovation/utils/utils.dart';
import 'package:exservice/resources/api/ApiProviderDelegate.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'change_password_event.dart';

part 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final BuildContext context;

  ChangePasswordBloc(this.context) : super(ChangePasswordInitial());

  // if password text field is obscure text or not
  bool obscureOldPassword = true;
  bool obscureNewPassword = true;
  bool obscureConfirmPassword = true;

  // Text field controller
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Form error message
  String errorOldPasswordMsg;
  String errorNewPasswordMsg;
  String errorConfirmPasswordMsg;

  void _validate() {
    String oldPassword = this.oldPasswordController.text.trim();
    String newPassword = this.newPasswordController.text.trim();
    String confirmPassword = this.confirmPasswordController.text.trim();

    this.errorOldPasswordMsg = oldPassword.isEmpty
        ? AppLocalization.of(context).trans("field_required")
        : null;

    this.errorNewPasswordMsg = newPassword.isEmpty
        ? AppLocalization.of(context).trans("field_required")
        : null;
    var strengthPassword = Utils.estimateBruteforceStrength(newPassword);
    if (!(strengthPassword > 0.3 && strengthPassword <= 1)) {
      errorNewPasswordMsg = AppLocalization.of(context).trans("weak_password");
    }

    this.errorConfirmPasswordMsg = confirmPassword.isEmpty
        ? AppLocalization.of(context).trans("field_required")
        : null;
  }

  bool get valid =>
      errorConfirmPasswordMsg == null &&
      errorNewPasswordMsg == null &&
      errorOldPasswordMsg == null;

  @override
  Stream<ChangePasswordState> mapEventToState(
      ChangePasswordEvent event) async* {
    if (event is ChangePasswordFormValidationEvent) {
      _validate();
      yield ChangePasswordFormValidationState();
    } else if (event is ChangePasswordObscureOldPasswordEvent) {
      this.obscureOldPassword = !this.obscureOldPassword;
      yield ChangePasswordShowOldPasswordState();
    } else if (event is ChangePasswordObscureNewPasswordEvent) {
      this.obscureNewPassword = !this.obscureNewPassword;
      yield ChangePasswordShowNewPasswordState();
    } else if (event is ChangePasswordObscureConfirmPasswordEvent) {
      this.obscureConfirmPassword = !this.obscureConfirmPassword;
      yield ChangePasswordShowConfirmPasswordState();
    } else if (event is OnChangePasswordEvent) {
      _validate();
      yield ChangePasswordFormValidationState();
      if (valid) {
        try {
          yield ChangePasswordAwaitState();
          await GetIt.I.get<ApiProviderDelegate>().fetchUpdatePassword(
                oldPasswordController.text,
                newPasswordController.text,
                confirmPasswordController.text,
              );
          yield OnChangePasswordState();
        } catch (e) {
          yield ChangePasswordErrorState("$e");
        }
      }
    }
  }
}

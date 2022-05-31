import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:exservice/models/request/change_password_request.dart';
import 'package:exservice/resources/repository/user_repository.dart';
import 'package:exservice/utils/localized.dart';
import 'package:exservice/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

part 'change_password_event.dart';

part 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool obscureOldPassword = true;
  bool obscureNewPassword = true;
  bool obscureConfirmPassword = true;

  Localized errorOldPasswordMsg;
  Localized errorNewPasswordMsg;
  Localized errorConfirmPasswordMsg;

  void _validate() {
    String oldPassword = oldPasswordController.text.trim();
    String newPassword = newPasswordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    errorOldPasswordMsg =
        oldPassword.isEmpty ? Localized("field_required") : null;

    print(Utils.estimateBruteforceStrength(newPassword));

    if (newPassword.isEmpty) {
      errorNewPasswordMsg = Localized("field_required");
    } else if (Utils.estimateBruteforceStrength(newPassword) < 0.3) {
      errorNewPasswordMsg = Localized("weak_password");
    } else {
      errorNewPasswordMsg = null;
    }

    errorConfirmPasswordMsg =
        confirmPassword.isEmpty ? Localized("field_required") : null;
  }

  bool get valid =>
      errorConfirmPasswordMsg == null &&
      errorNewPasswordMsg == null &&
      errorOldPasswordMsg == null;

  ChangePasswordBloc() : super(ChangePasswordInitial()) {
    on((event, emit) async {
      if (event is ChangePasswordObscureOldPasswordEvent) {
        obscureOldPassword = !obscureOldPassword;
        emit(ChangePasswordShowOldPasswordState());
      } else if (event is ChangePasswordObscureNewPasswordEvent) {
        obscureNewPassword = !obscureNewPassword;
        emit(ChangePasswordShowNewPasswordState());
      } else if (event is ChangePasswordObscureConfirmPasswordEvent) {
        obscureConfirmPassword = !obscureConfirmPassword;
        emit(ChangePasswordShowConfirmPasswordState());
      } else if (event is ChangePasswordCommitEvent) {
        _validate();
        emit(ChangePasswordValidationState());
        if (valid) {
          try {
            emit(ChangePasswordAwaitState());
            await GetIt.I
                .get<UserRepository>()
                .changePassword(ChangePasswordRequest(
                  oldPassword: oldPasswordController.text,
                  newPassword: newPasswordController.text,
                  confirmPassword: confirmPasswordController.text,
                ));
            emit(ChangePasswordAcceptState());
          } on DioError catch (ex) {
            emit(ChangePasswordErrorState(ex.error));
          }
        }
      }
    });
  }
}

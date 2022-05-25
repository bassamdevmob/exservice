import 'package:bloc/bloc.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/models/request/change_password_request.dart';
import 'package:exservice/resources/repository/user_repository.dart';
import 'package:exservice/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

part 'change_password_event.dart';

part 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final BuildContext context;

  ChangePasswordBloc(this.context) : super(ChangePasswordInitial()) {
    on((event, emit) async {
      if (event is ChangePasswordFormValidationEvent) {
        _validate();
        emit(ChangePasswordFormValidationState());
      } else if (event is ChangePasswordObscureOldPasswordEvent) {
        this.obscureOldPassword = !this.obscureOldPassword;
        emit(ChangePasswordShowOldPasswordState());
      } else if (event is ChangePasswordObscureNewPasswordEvent) {
        this.obscureNewPassword = !this.obscureNewPassword;
        emit(ChangePasswordShowNewPasswordState());
      } else if (event is ChangePasswordObscureConfirmPasswordEvent) {
        this.obscureConfirmPassword = !this.obscureConfirmPassword;
        emit(ChangePasswordShowConfirmPasswordState());
      } else if (event is OnChangePasswordEvent) {
        _validate();
        emit(ChangePasswordFormValidationState());
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
            emit(OnChangePasswordState());
          } catch (e) {
            emit(ChangePasswordErrorState("$e"));
          }
        }
      }
    });
  }

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
}

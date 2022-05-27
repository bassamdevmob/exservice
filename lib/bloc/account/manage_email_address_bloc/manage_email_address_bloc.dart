import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/resources/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:string_validator/string_validator.dart';

part 'manage_email_address_event.dart';

part 'manage_email_address_state.dart';

class ManageEmailAddressBloc
    extends Bloc<ManageEmailAddressEvent, ManageEmailAddressState> {
  final mobileNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final BuildContext context;

  @override
  Future<void> close() async {
    mobileNumberController.dispose();
    passwordController.dispose();
    super.close();
  }

  String mobileNumberMsg;
  String passwordMsg;

  bool get validMobileNumber => mobileNumberMsg == null;

  bool get validPassword => mobileNumberMsg == null;

  bool get valid => validMobileNumber && validPassword;

  String validateMobileNumber() {
    String mobileNumber = mobileNumberController.text.trim();
    if (mobileNumber.isEmpty)
      return AppLocalization.of(context).translate("filed_required");
    if (!isEmail(mobileNumber))
      return AppLocalization.of(context).translate("error_email_msg");
    return null;
  }

  String validatePassword() {
    String password = passwordController.text.trim();
    if (password.isEmpty)
      return AppLocalization.of(context).translate("filed_required");
    return null;
  }

  void _validate() {
    mobileNumberMsg = validateMobileNumber();
    passwordMsg = validatePassword();
  }

  bool obscurePassword = true;

  ManageEmailAddressBloc(this.context) : super(ManageEmailAddressInitial()) {
    on<ManageEmailAddressEvent>((event, emit) async {
      if (event is ManageEmailAddressValidateEvent) {
        _validate();
        emit(ValidationUpdateNumberState());
      } else if (event is ManageEmailAddressCommitEvent) {
        try {
          _validate();
          emit(ValidationUpdateNumberState());
          if (valid) {
            emit(ManageEmailAddressAwaitState());
            String mobileNumber = mobileNumberController.text.trim();
            String password = passwordController.text.trim();
            var response =
                await GetIt.I.get<UserRepository>().updateEmail(
                      email: mobileNumber,
                      password: password,
                    );
            emit(ManageEmailAddressCommittedState(response.data.session));
          }
        } catch (e) {
          emit(ManageEmailAddressErrorState("$e"));
        }
      } else if (event is ManageEmailAddressShowPasswordEvent) {
        obscurePassword = !obscurePassword;
        emit(ManageEmailAddressInitial());
      }
    });
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/resources/repository/user_repository.dart';
import 'package:exservice/utils/global.dart';
import 'package:exservice/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

part 'manage_phone_number_event.dart';

part 'manage_phone_number_state.dart';

class ManagePhoneNumberBloc
    extends Bloc<ManagePhoneNumberEvent, ManagePhoneNumberState> {
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
    String mobileNumber =
        phoneNumberFormatter.unmaskText(mobileNumberController.text.trim());
    if (mobileNumber.isEmpty)
      return AppLocalization.of(context).translate("filed_required");
    if (!Utils.isPhoneNumber(mobileNumber))
      return AppLocalization.of(context).translate("error_mobile_number_msg");
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

  ManagePhoneNumberBloc(this.context) : super(ManagePhoneNumberInitial()) {
    on<ManagePhoneNumberEvent>((event, emit) async {
      if (event is ManagePhoneNumberValidateEvent) {
        _validate();
        emit(ValidationUpdateNumberState());
      } else if (event is ManagePhoneNumberCommitEvent) {
        try {
          _validate();
          emit(ValidationUpdateNumberState());
          if (valid) {
            emit(ManagePhoneNumberAwaitState());
            String mobileNumber = mobileNumberController.text.trim();
            String password = passwordController.text.trim();
            var response =
                await GetIt.I.get<UserRepository>().updatePhoneNumber(
                      phoneNumber: mobileNumber,
                      password: password,
                    );
            emit(ManagePhoneNumberCommittedState(response.data.session));
          }
        } catch (e) {
          emit(ManagePhoneNumberErrorState("$e"));
        }
      } else if (event is ManagePhoneNumberShowPasswordEvent) {
        obscurePassword = !obscurePassword;
        emit(ManagePhoneNumberInitial());
      }
    });
  }
}

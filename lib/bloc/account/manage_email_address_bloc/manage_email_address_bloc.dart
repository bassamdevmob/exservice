import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/resources/repository/user_repository.dart';
import 'package:exservice/utils/localized.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:string_validator/string_validator.dart';

part 'manage_email_address_event.dart';

part 'manage_email_address_state.dart';

class ManageEmailAddressBloc
    extends Bloc<ManageEmailAddressEvent, ManageEmailAddressState> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Future<void> close() async {
    emailController.dispose();
    passwordController.dispose();
    super.close();
  }

  Localized emailErrorMessage;
  Localized passwordErrorMessage;

  bool get valid => emailErrorMessage == null && emailErrorMessage == null;

  void _validate() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty) {
      emailErrorMessage = Localized("field_required");
    } else if (!isEmail(email)) {
      emailErrorMessage = Localized("invalid_email");
    } else {
      emailErrorMessage = null;
    }
    passwordErrorMessage = password.isEmpty ? Localized("field_required") : null;
  }

  bool obscurePassword = true;

  ManageEmailAddressBloc() : super(ManageEmailAddressInitial()) {
    on<ManageEmailAddressEvent>((event, emit) async {
      if (event is ManageEmailAddressCommitEvent) {
        try {
          _validate();
          emit(ManageEmailAddressValidateState());
          if (valid) {
            emit(ManageEmailAddressAwaitState());
            String mobileNumber = emailController.text.trim();
            String password = passwordController.text.trim();
            var response = await GetIt.I.get<UserRepository>().updateEmail(
                  email: mobileNumber,
                  password: password,
                );
            emit(ManageEmailAddressAcceptState(response.data.session));
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

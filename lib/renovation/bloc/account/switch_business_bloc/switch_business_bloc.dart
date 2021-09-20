import 'dart:async';

import 'package:exservice/helper/Utils.dart';
import 'package:exservice/renovation/bloc/view/account_bloc/account_bloc.dart';
import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/renovation/utils/enums.dart';
import 'package:exservice/resources/api/ApiProviderDelegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:string_validator/string_validator.dart' as validator;

part 'switch_business_event.dart';
part 'switch_business_state.dart';

class SwitchBusinessBloc
    extends Bloc<SwitchBusinessEvent, SwitchBusinessState> {
  final companyNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final websiteController = TextEditingController();
  final bioController = TextEditingController();
  final BuildContext context;

  String companyNameErrorMessage;
  String phoneNumberErrorMessage;
  String websiteErrorMessage;
  String bioErrorMessage;

  SwitchBusinessBloc(this.context) : super(SwitchBusinessInitial());

  @override
  Future<void> close() {
    companyNameController.dispose();
    phoneNumberController.dispose();
    websiteController.dispose();
    bioController.dispose();
    return super.close();
  }

  bool get valid =>
      companyNameErrorMessage == null &&
      phoneNumberErrorMessage == null &&
      websiteErrorMessage == null &&
      bioErrorMessage == null;

  void _validate() {
    String companyName = companyNameController.text.trim();
    String phoneNumber = phoneNumberController.text.trim();
    String website = websiteController.text.trim();
    String bio = bioController.text.trim();

    companyNameErrorMessage = companyName.isEmpty
        ? AppLocalization.of(context).trans("filed_required")
        : null;

    if (phoneNumber.isEmpty) {
      phoneNumberErrorMessage =
          AppLocalization.of(context).trans("filed_required");
    } else if (!Utils.isPhoneNumber(phoneNumber)) {
      phoneNumberErrorMessage =
          AppLocalization.of(context).trans("invalid_phone_number");
    } else {
      phoneNumberErrorMessage = null;
    }

    if (website.isEmpty) {
      websiteErrorMessage = AppLocalization.of(context).trans("filed_required");
    } else if (!validator.isURL(website)) {
      websiteErrorMessage = AppLocalization.of(context).trans("invalid_url");
    } else {
      websiteErrorMessage = null;
    }

    bioErrorMessage = bio.isEmpty
        ? AppLocalization.of(context).trans("filed_required")
        : null;
  }

  @override
  Stream<SwitchBusinessState> mapEventToState(
    SwitchBusinessEvent event,
  ) async* {
    if (event is SwitchBusinessCommitEvent) {
      try {
        _validate();
        yield SwitchBusinessValidationState();
        if (valid) {
          yield SwitchBusinessAwaitState();
          String companyName = companyNameController.text.trim();
          String phoneNumber = phoneNumberController.text.trim();
          String website = websiteController.text.trim();
          String bio = bioController.text.trim();
          await GetIt.I
              .get<ApiProviderDelegate>()
              .fetchSwitchToBusiness(companyName, phoneNumber, website, bio);
          var _accountBloc = context.read<AccountBloc>();
          _accountBloc.profile.user
            ..companyName = companyName
            ..website = phoneNumber
            ..publicPhone = website
            ..bio = bio
            ..type.id = AccountType.company.id;
          _accountBloc.add(AccountRefreshEvent());
          yield SwitchBusinessCommittedState();
        }
      } catch (e) {
        yield SwitchBusinessErrorState("$e");
      }
    }
  }
}

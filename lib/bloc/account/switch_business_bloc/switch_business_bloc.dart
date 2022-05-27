import 'dart:async';

import 'package:exservice/bloc/profile_bloc/profile_bloc.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/models/request/switch_business_request.dart';
import 'package:exservice/resources/repository/user_repository.dart';
import 'package:exservice/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:string_validator/string_validator.dart' as validator;

part 'switch_business_event.dart';

part 'switch_business_state.dart';

class SwitchBusinessBloc
    extends Bloc<SwitchBusinessEvent, SwitchBusinessState> {
  final companyNameController = TextEditingController();
  final websiteController = TextEditingController();
  final bioController = TextEditingController();
  final BuildContext context;

  String companyNameErrorMessage;
  String websiteErrorMessage;
  String bioErrorMessage;

  SwitchBusinessBloc(this.context) : super(SwitchBusinessInitial()) {
    on((event, emit) async {
      if (event is SwitchBusinessCommitEvent) {
        try {
          _validate();
          emit(SwitchBusinessValidationState());
          if (valid) {
            emit(SwitchBusinessAwaitState());
            String companyName = companyNameController.text.trim();
            String website = websiteController.text.trim();
            String bio = bioController.text.trim();
            await GetIt.I
                .get<UserRepository>()
                .switchToBusiness(SwitchBusinessRequest(
                  companyName: companyName,
                  bio: bio,
                  website: website,
                ));
            var _accountBloc = BlocProvider.of<ProfileBloc>(context);
            _accountBloc.model.business
              ..companyName = companyName
              ..website = website
              ..bio = bio;
            _accountBloc.model.type = UserType.BUSINESS.name;
            _accountBloc.add(ProfileRefreshEvent());
            emit(SwitchBusinessCommittedState());
          }
        } catch (e) {
          emit(SwitchBusinessErrorState("$e"));
        }
      }
    });
  }

  @override
  Future<void> close() {
    companyNameController.dispose();
    websiteController.dispose();
    bioController.dispose();
    return super.close();
  }

  bool get valid =>
      companyNameErrorMessage == null &&
      websiteErrorMessage == null &&
      bioErrorMessage == null;

  void _validate() {
    String companyName = companyNameController.text.trim();
    String website = websiteController.text.trim();
    String bio = bioController.text.trim();

    companyNameErrorMessage = companyName.isEmpty
        ? AppLocalization.of(context).translate("filed_required")
        : null;

    if (website.isEmpty) {
      websiteErrorMessage = AppLocalization.of(context).translate("filed_required");
    } else if (!validator.isURL(website)) {
      websiteErrorMessage = AppLocalization.of(context).translate("invalid_url");
    } else {
      websiteErrorMessage = null;
    }

    bioErrorMessage = bio.isEmpty
        ? AppLocalization.of(context).translate("filed_required")
        : null;
  }
}

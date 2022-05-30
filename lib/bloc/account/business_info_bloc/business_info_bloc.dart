import 'dart:async';

import 'package:exservice/bloc/profile_bloc/profile_bloc.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/resources/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:string_validator/string_validator.dart' as validator;

part 'business_info_event.dart';

part 'business_info_state.dart';

class BusinessInfoBloc extends Bloc<BusinessInfoEvent, BusinessInfoState> {
  final companyNameController = TextEditingController();
  final websiteController = TextEditingController();
  final bioController = TextEditingController();
  final BuildContext context;

  String companyNameErrorMessage;
  String websiteErrorMessage;
  String bioErrorMessage;

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

  BusinessInfoBloc(this.context) : super(BusinessInfoInitial()) {
    var _accountBloc = BlocProvider.of<ProfileBloc>(context);
    companyNameController.text = _accountBloc.model.companyName;
    websiteController.text = _accountBloc.model.website;
    bioController.text = _accountBloc.model.bio;
    on<BusinessInfoEvent>((event, emit) async {
      if (event is ResetBusinessInfoEvent) {
        companyNameController.text = _accountBloc.model.companyName;
        websiteController.text = _accountBloc.model.website;
        bioController.text = _accountBloc.model.bio;
        emit(BusinessInfoResetState());
      } else if (event is UpdateBusinessInfoEvent) {
        try {
          _validate();
          emit(BusinessInfoValidateState());
          if (valid) {
            emit(BusinessInfoAwaitState());
            String companyName = companyNameController.text.trim();
            String website = websiteController.text.trim();
            String bio = bioController.text.trim();
            await GetIt.I.get<UserRepository>().updateProfile();
            _accountBloc.model
              ..companyName = companyName
              ..website = website
              ..bio = bio;
            _accountBloc.add(ProfileRefreshEvent());
            emit(BusinessInfoCommittedState());
          }
        } catch (e) {
          emit(BusinessInfoErrorState("$e"));
        }
      }
    });
  }
}

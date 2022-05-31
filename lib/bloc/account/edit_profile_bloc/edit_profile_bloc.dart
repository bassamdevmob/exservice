import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:exservice/bloc/profile_bloc/profile_bloc.dart';
import 'package:exservice/models/request/edit_profile_request.dart';
import 'package:exservice/resources/repository/user_repository.dart';
import 'package:exservice/utils/localized.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:string_validator/string_validator.dart';

part 'edit_profile_event.dart';

part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final usernameController = TextEditingController();
  final companyNameController = TextEditingController();
  final websiteController = TextEditingController();
  final bioController = TextEditingController();
  final ProfileBloc profileBloc;

  String profilePicture;

  Localized usernameErrorMessage;
  Localized companyNameErrorMessage;
  Localized websiteErrorMessage;
  Localized bioErrorMessage;

  ImageProvider get profilePictureProvider => profilePicture != null
      ? FileImage(File(profilePicture))
      : NetworkImage(profileBloc.model.profilePicture);

  @override
  Future<void> close() {
    usernameController.dispose();
    companyNameController.dispose();
    websiteController.dispose();
    bioController.dispose();
    return super.close();
  }

  bool get valid =>
      usernameErrorMessage == null &&
      companyNameErrorMessage == null &&
      websiteErrorMessage == null &&
      bioErrorMessage == null;

  void _validate() {
    String website = websiteController.text.trim();

    websiteErrorMessage =
        website.isNotEmpty && !isURL(website) ? Localized("invalid_url") : null;
  }

  EditProfileBloc(this.profileBloc) : super(EditProfileInitial()) {
    usernameController.text = profileBloc.model.username;
    companyNameController.text = profileBloc.model.companyName;
    websiteController.text = profileBloc.model.website;
    bioController.text = profileBloc.model.bio;
    on<EditProfileEvent>((event, emit) async {
      if (event is EditProfileCommitEvent) {
        _validate();
        emit(EditProfileValidationState());
        if (valid) {
          try {
            emit(EditProfileAwaitState());
            String username = usernameController.text.trim();
            String companyName = companyNameController.text.trim();
            String website = websiteController.text.trim();
            String bio = bioController.text.trim();
            var response = await GetIt.I
                .get<UserRepository>()
                .updateProfile(EditProfileRequest(
                  profilePicture: profilePicture,
                  username: username,
                  companyName: companyName,
                  website: website,
                  bio: bio,
                ));
            profileBloc.add(ProfileUpdateEvent(response.data));
            emit(EditProfileAcceptState());
          } on DioError catch (ex) {
            emit(EditProfileErrorState(ex.error));
          }
        }
      } else if (event is EditProfileChangeImageEvent) {
        profilePicture = event.file.path;
        emit(EditProfileInitial());
      }
    });
  }
}

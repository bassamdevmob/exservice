part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLogoutAwaitState extends ProfileState {}

class ProfileLogoutAcceptState extends ProfileState {}

class ProfileLogoutErrorState extends ProfileState {
  final dynamic error;

  ProfileLogoutErrorState(this.error);
}

class ProfileChangeTabState extends ProfileState {}

class ProfileAwaitState extends ProfileState {}

class ProfileAccessibleState extends ProfileState {}

class ProfileErrorState extends ProfileState {
  final String message;

  ProfileErrorState(this.message);
}

/// video
class ProfileAwaitVideoUploadState extends ProfileState {}

class ProfileVideoState extends ProfileState {}

class ProfileErrorVideoUploadState extends ProfileState {
  final String message;

  ProfileErrorVideoUploadState(this.message);
}

/// image
class ProfileAwaitImageUploadState extends ProfileState {}

class ProfileImageState extends ProfileState {}

class ProfileErrorImageUploadState extends ProfileState {
  final String message;

  ProfileErrorImageUploadState(this.message);
}

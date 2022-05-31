part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}

class ProfileFetchEvent extends ProfileEvent {}

class ProfileRefreshEvent extends ProfileEvent {}

class ProfileUpdateEvent extends ProfileEvent {
  final User model;

  ProfileUpdateEvent(this.model);
}

class ProfileLogoutEvent extends ProfileEvent {}

class ProfileUploadVideoEvent extends ProfileEvent {
  final String path;

  ProfileUploadVideoEvent(this.path);
}

class ProfileChangeProfileImageEvent extends ProfileEvent {
  final String path;

  ProfileChangeProfileImageEvent(this.path);
}

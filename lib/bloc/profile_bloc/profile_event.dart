part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}

class ProfileFetchEvent extends ProfileEvent {}

class ProfileRefreshEvent extends ProfileEvent {}

class ProfileLogoutEvent extends ProfileEvent {}

class ProfileChangeTabEvent extends ProfileEvent {
  final ProfileTab tab;

  ProfileChangeTabEvent(this.tab);
}

class ProfileUploadVideoEvent extends ProfileEvent {
  final String path;

  ProfileUploadVideoEvent(this.path);
}

class ProfileChangeProfileImageEvent extends ProfileEvent {
  final String path;

  ProfileChangeProfileImageEvent(this.path);
}

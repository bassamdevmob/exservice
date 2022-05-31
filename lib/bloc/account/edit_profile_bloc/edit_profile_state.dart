part of 'edit_profile_bloc.dart';

@immutable
abstract class EditProfileState {}

class EditProfileInitial extends EditProfileState {}

class EditProfileValidationState extends EditProfileState {}

class EditProfileAwaitState extends EditProfileState {}

class EditProfileAcceptState extends EditProfileState {}

class EditProfileErrorState extends EditProfileState {
  final dynamic error;

  EditProfileErrorState(this.error);
}

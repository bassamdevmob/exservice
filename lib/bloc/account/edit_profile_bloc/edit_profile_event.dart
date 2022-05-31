part of 'edit_profile_bloc.dart';

@immutable
abstract class EditProfileEvent {}

class EditProfileChangeImageEvent extends EditProfileEvent {
  final XFile file;

  EditProfileChangeImageEvent(this.file);
}

class EditProfileCommitEvent extends EditProfileEvent {}


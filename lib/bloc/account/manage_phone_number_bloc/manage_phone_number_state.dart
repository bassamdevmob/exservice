part of 'manage_phone_number_bloc.dart';

@immutable
abstract class ManagePhoneNumberState {}

class ManagePhoneNumberInitial extends ManagePhoneNumberState {}

class ManagePhoneNumberSecurePasswordState extends ManagePhoneNumberState {}

class ManagePhoneNumberValidateState extends ManagePhoneNumberState {}

class ManagePhoneNumberAwaitState extends ManagePhoneNumberState {}

class ManagePhoneNumberAcceptState extends ManagePhoneNumberState {
  final String session;

  ManagePhoneNumberAcceptState(this.session);
}

class ManagePhoneNumberErrorState extends ManagePhoneNumberState {
  final dynamic error;

  ManagePhoneNumberErrorState(this.error);
}

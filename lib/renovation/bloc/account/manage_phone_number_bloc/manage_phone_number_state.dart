part of 'manage_phone_number_bloc.dart';

@immutable
abstract class ManagePhoneNumberState {}

class ManagePhoneNumberInitial extends ManagePhoneNumberState {}

class ManagePhoneNumberAwaitState extends ManagePhoneNumberState {}

class ManagePhoneNumberCommittedState extends ManagePhoneNumberState {
  final String session;

  ManagePhoneNumberCommittedState(this.session);
}

class ManagePhoneNumberErrorState extends ManagePhoneNumberState {
  final String message;

  ManagePhoneNumberErrorState(this.message);
}

class ValidationUpdateNumberState extends ManagePhoneNumberState {}

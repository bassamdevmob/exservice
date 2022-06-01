part of 'manage_email_bloc.dart';

@immutable
abstract class ManageEmailState {}

class ManageEmailInitial extends ManageEmailState {}

class ManageEmailSecurePasswordState extends ManageEmailState {}

class ManageEmailValidateState extends ManageEmailState {}

class ManageEmailAwaitState extends ManageEmailState {}

class ManageEmailAcceptState extends ManageEmailState {
  final String session;

  ManageEmailAcceptState(this.session);
}

class ManageEmailErrorState extends ManageEmailState {
  final dynamic error;

  ManageEmailErrorState(this.error);
}

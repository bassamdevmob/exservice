part of 'reset_password_bloc.dart';

@immutable
abstract class ResetPasswordState {}

class ResetPasswordInitial extends ResetPasswordState {}

class ResetPasswordValidationState extends ResetPasswordState {}

class ResetPasswordAwaitState extends ResetPasswordState {}

class ResetPasswordCommittedState extends ResetPasswordState {}

class ResetPasswordSecurePasswordState extends ResetPasswordState {}

class ResetPasswordErrorState extends ResetPasswordState {
  final String message;

  ResetPasswordErrorState(this.message);
}

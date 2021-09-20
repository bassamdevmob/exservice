part of 'forgot_password_bloc.dart';

@immutable
abstract class ForgotPasswordState {}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordValidationState extends ForgotPasswordState {}

class ForgotPasswordAwaitState extends ForgotPasswordState {}

class ForgotPasswordCommittedState extends ForgotPasswordState {}

class ForgotPasswordErrorState extends ForgotPasswordState {
  final String message;

  ForgotPasswordErrorState(this.message);
}

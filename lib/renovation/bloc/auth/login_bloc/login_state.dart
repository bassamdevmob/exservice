part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginValidationState extends LoginState {}

class LoginAwaitState extends LoginState {}

class LoginCommittedState extends LoginState {}

class LoginSecurePasswordState extends LoginState {}

class LoginErrorState extends LoginState {
  final String message;

  LoginErrorState(this.message);
}

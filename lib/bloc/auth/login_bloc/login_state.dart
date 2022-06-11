part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginValidationState extends LoginState {}

class LoginAwaitState extends LoginState {}

class LoginAcceptState extends LoginState {
  final AuthModel model;

  LoginAcceptState(this.model);
}

class LoginSecurePasswordState extends LoginState {}

class LoginErrorState extends LoginState {
  final dynamic error;

  LoginErrorState(this.error);
}

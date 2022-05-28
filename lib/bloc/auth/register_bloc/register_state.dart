part of 'register_bloc.dart';

@immutable
abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterValidationState extends RegisterState {}

class RegisterAwaitState extends RegisterState {}

class RegisterAcceptState extends RegisterState {
  final String session;

  RegisterAcceptState(this.session);
}

class RegisterErrorState extends RegisterState {
  final dynamic error;

  RegisterErrorState(this.error);
}

class RegisterSecurePasswordState extends RegisterState {}

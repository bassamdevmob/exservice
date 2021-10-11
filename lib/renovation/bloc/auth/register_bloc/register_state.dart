part of 'register_bloc.dart';

@immutable
abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterValidationState extends RegisterState {}

class RegisterAwaitState extends RegisterState {}

class RegisterCommittedState extends RegisterState {
  final String session;

  RegisterCommittedState(this.session);
}

class RegisterAwaitCheckAccountState extends RegisterState {}

class RegisterUniqueAccountState extends RegisterState {}

class RegisterSecurePasswordState extends RegisterState {}

class RegisterChangeIdentifierState extends RegisterState {}

class RegisterErrorState extends RegisterState {
  final String message;

  RegisterErrorState(this.message);
}

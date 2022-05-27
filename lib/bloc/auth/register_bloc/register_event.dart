part of 'register_bloc.dart';

@immutable
abstract class RegisterEvent {}

class RegisterValidateEvent extends RegisterEvent {}

class RegisterValidateAccountEvent extends RegisterEvent {}

class RegisterCommitEvent extends RegisterEvent {}

class RegisterCheckAccountEvent extends RegisterEvent {}

class RegisterSecurePasswordEvent extends RegisterEvent {}

class RegisterChangeIdentifierEvent extends RegisterEvent {
  final AccountRegistrationType identifier;

  RegisterChangeIdentifierEvent(this.identifier);
}

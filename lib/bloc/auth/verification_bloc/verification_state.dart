part of 'verification_bloc.dart';

@immutable
abstract class VerificationState {}

class VerificationInitial extends VerificationState {}

class VerificationValidationState extends VerificationState {}

class VerificationAwaitState extends VerificationState {}

class VerificationAcceptState extends VerificationState {}

class VerificationErrorState extends VerificationState {
  final dynamic error;

  VerificationErrorState(this.error);
}

/// resend pin

class VerificationResendAwaitState extends VerificationState {}

class VerificationResendAcceptState extends VerificationState {}

class VerificationWaitBeforeResendState extends VerificationState {
  final int seconds;

  VerificationWaitBeforeResendState(this.seconds);
}

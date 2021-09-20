part of 'verification_bloc.dart';

@immutable
abstract class VerificationState {}

class VerificationInitial extends VerificationState {}

class VerificationValidationState extends VerificationState {}

class VerificationAwaitState extends VerificationState {}

class VerificationCommittedState extends VerificationState {}

class VerificationErrorState extends VerificationState {
  final String message;

  VerificationErrorState(this.message);
}

/// resend pin
class VerificationWaitBeforeResendState extends VerificationState {
  final int seconds;

  VerificationWaitBeforeResendState(this.seconds);
}

class VerificationAwaitResendState extends VerificationState {}

class VerificationCommittedResendState extends VerificationState {}
